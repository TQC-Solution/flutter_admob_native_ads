import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/native_ad_events.dart';
import '../models/native_ad_options.dart';
import '../services/app_lifecycle_manager.dart';
import '../services/network_connectivity_manager.dart';
import '../services/preload_scheduler.dart';
import '../services/reload_scheduler.dart';

export 'native_ad_controller.dart' show NativeAdState;

/// Controller for managing native ad lifecycle and state.
///
/// This controller handles communication with the native platform,
/// manages ad loading state, and routes callbacks from the native SDK
/// to Flutter.
///
/// Example:
/// ```dart
/// final controller = NativeAdController(
///   options: NativeAdOptions(adUnitId: 'xxx'),
///   events: NativeAdEvents(
///     onAdLoaded: () => print('Loaded'),
///     onAdFailed: (error, code) => print('Failed: $error'),
///   ),
/// );
///
/// await controller.loadAd();
/// // ... use controller
/// controller.dispose();
/// ```
class NativeAdController {
  /// Creates a [NativeAdController] with the given options and events.
  NativeAdController({
    required this.options,
    this.events = const NativeAdEvents(),
  }) : _id = _generateId() {
    _setupChannel();

    // Initialize smart preload if enabled
    if (options.enableSmartPreload) {
      _initializeSmartPreload();
    }

    // Initialize smart reload if enabled
    if (options.enableSmartReload) {
      _initializeSmartReload();
    }
  }

  /// Unique identifier for this controller instance.
  final String _id;

  /// Configuration options for the ad.
  final NativeAdOptions options;

  /// Event callbacks for ad lifecycle events.
  NativeAdEvents events;

  /// Method channel for platform communication.
  static const MethodChannel _channel =
      MethodChannel('flutter_admob_native_ads');

  /// Whether the controller has been disposed.
  bool _isDisposed = false;

  /// Whether the ad has been preloaded.
  bool _isPreloaded = false;

  /// Stream controller for state changes.
  final StreamController<NativeAdState> _stateController =
      StreamController<NativeAdState>.broadcast();

  /// Completer for preload operation (null if not preloading).
  Completer<bool>? _preloadCompleter;

  /// Current state of the ad.
  NativeAdState _state = NativeAdState.initial;

  /// Error message if loading failed.
  String? _errorMessage;

  /// Error code if loading failed.
  int? _errorCode;

  /// Smart preload services (lazy initialized when enableSmartPreload is true).
  AppLifecycleManager? _lifecycleManager;
  NetworkConnectivityManager? _networkManager;
  PreloadScheduler? _preloadScheduler;

  /// Reload scheduler (lazy initialized when enableSmartReload is true).
  ReloadScheduler? _reloadScheduler;

  /// Whether the ad is currently visible on screen.
  bool _isAdVisible = false;

  /// Reference to preloaded ad controller for cache management.
  /// Set via [setPreloadedAdController] when using cache-based reload.
  NativeAdController? _preloadedAdController;

  /// Counter for generating unique IDs.
  static int _idCounter = 0;

  /// Gets the unique identifier for this controller.
  String get id => _id;

  /// Gets the current state of the ad.
  NativeAdState get state => _state;

  /// Stream of state changes.
  Stream<NativeAdState> get stateStream => _stateController.stream;

  /// Whether the ad is currently loading.
  bool get isLoading => _state == NativeAdState.loading;

  /// Whether the ad has been loaded successfully.
  bool get isLoaded => _state == NativeAdState.loaded;

  /// Whether the ad failed to load.
  bool get hasError => _state == NativeAdState.error;

  /// Gets the error message if loading failed.
  String? get errorMessage => _errorMessage;

  /// Gets the error code if loading failed.
  int? get errorCode => _errorCode;

  /// Whether the controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Whether the ad has been preloaded.
  bool get isPreloaded => _isPreloaded;

  /// Whether the ad is currently visible on screen.
  bool get isAdVisible => _isAdVisible;

  /// Generates a unique ID for the controller.
  static String _generateId() {
    _idCounter++;
    return 'native_ad_${DateTime.now().millisecondsSinceEpoch}_$_idCounter';
  }

  /// Sets up the method channel for receiving callbacks.
  void _setupChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// Initializes smart preload services when enableSmartPreload is true.
  void _initializeSmartPreload() {
    // Create managers
    _lifecycleManager = AppLifecycleManager();
    _networkManager = NetworkConnectivityManager();

    // Initialize lifecycle manager
    _lifecycleManager!.initialize();

    // Initialize network manager asynchronously
    _networkManager!.initialize().then((_) {
      // Create scheduler after network check completes
      _preloadScheduler = PreloadScheduler(
        lifecycleManager: _lifecycleManager!,
        networkManager: _networkManager!,
        loadAdCallback: _performLoadAd,
        enableDebugLogs: options.enableDebugLogs,
      );
      _preloadScheduler!.initialize();

      if (options.enableDebugLogs) {
        debugPrint('[NativeAdController] Smart preload initialized for $_id');
      }

      // Trigger initial evaluation
      _preloadScheduler!.evaluateAndLoad();
    });
  }

  /// Initializes smart reload services when enableSmartReload is true.
  void _initializeSmartReload() {
    // Reuse lifecycle manager from preload if available, otherwise create new
    _lifecycleManager ??= AppLifecycleManager()..initialize();

    // Reuse network manager from preload if available, otherwise create new
    if (_networkManager == null) {
      _networkManager = NetworkConnectivityManager();
      _networkManager!.initialize().then((_) {
        _createReloadScheduler();
      });
    } else {
      _createReloadScheduler();
    }
  }

  void _createReloadScheduler() {
    _reloadScheduler = ReloadScheduler(
      lifecycleManager: _lifecycleManager!,
      networkManager: _networkManager!,
      reloadCallback: _performReload,
      cacheCheckCallback: _checkCachedAd,
      showCachedAdCallback: _showCachedAd,
      preloadTriggerCallback: _triggerPreloadForCache,
      reloadIntervalSeconds: options.reloadIntervalSeconds,
      retryDelaySeconds: options.retryDelaySeconds,
      enableDebugLogs: options.enableDebugLogs,
    );
    _reloadScheduler!.initialize();

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Smart reload initialized for $_id');
    }
  }

  /// Sets a preloaded ad controller for cache-based reload.
  ///
  /// When reload is triggered and this controller has a cached ad,
  /// it will be shown immediately instead of requesting a new ad.
  void setPreloadedAdController(NativeAdController? controller) {
    _preloadedAdController = controller;
    if (options.enableDebugLogs) {
      debugPrint(
        '[NativeAdController] Preloaded controller set: ${controller?.id}',
      );
    }
  }

  /// Updates the ad visibility state for reload logic.
  ///
  /// Call this when the ad becomes visible or hidden on screen.
  /// Reload logic only proceeds when the ad is visible.
  void updateVisibility(bool isVisible) {
    if (_isDisposed) return;

    _isAdVisible = isVisible;
    _reloadScheduler?.updateAdVisibility(isVisible);

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Visibility updated: $isVisible');
    }
  }

  /// Updates the remote config reload interval.
  ///
  /// Call this when remote config value changes at runtime.
  void updateReloadInterval(int? seconds) {
    _reloadScheduler?.updateReloadInterval(seconds);
  }

  /// Triggers a smart reload (visibility-aware with cache check).
  ///
  /// Only works when enableSmartReload is true.
  /// Respects visibility check and cache priority.
  void triggerSmartReload() {
    if (!options.enableSmartReload || _reloadScheduler == null) {
      if (options.enableDebugLogs) {
        debugPrint(
          '[NativeAdController] Smart reload not enabled, using direct reload',
        );
      }
      reload();
      return;
    }

    _reloadScheduler!.triggerReload();
  }

  /// Internal: Checks if a cached ad is available.
  bool _checkCachedAd() {
    if (_preloadedAdController == null) return false;
    return _preloadedAdController!.isLoaded &&
        !_preloadedAdController!.isDisposed;
  }

  /// Internal: Shows the cached ad.
  Future<void> _showCachedAd() async {
    // In the current architecture, showing cached ad means:
    // 1. The widget will swap to use the preloaded controller
    // 2. This is handled via events to the widget
    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Showing cached ad from preload');
    }

    // Emit a special event to notify widget to swap controllers
    events.onCachedAdReady?.call();
  }

  /// Internal: Triggers preload for next cache.
  Future<void> _triggerPreloadForCache() async {
    if (_preloadedAdController != null && !_preloadedAdController!.isDisposed) {
      if (options.enableDebugLogs) {
        debugPrint('[NativeAdController] Triggering preload for next cache');
      }
      _preloadedAdController!.preload();
    }
  }

  /// Internal: Performs the actual reload.
  Future<void> _performReload() async {
    if (_isDisposed) return;

    _state = NativeAdState.loading;
    _errorMessage = null;
    _errorCode = null;
    _stateController.add(_state);

    // Notify schedulers of state change
    _preloadScheduler?.updateAdState(_state);
    
    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Performing reload: $_id');
    }

    try {
      await _channel.invokeMethod('reloadAd', {
        'controllerId': _id,
        ...options.toMap(),
      });
    } on PlatformException catch (e) {
      _handleReloadFailed(e.message ?? 'Platform error', -1);
    }
  }

  void _handleReloadFailed(String error, int code) {
    _state = NativeAdState.error;
    _errorMessage = error;
    _errorCode = code;
    _stateController.add(_state);

    _reloadScheduler?.onReloadFailed();
    
    events.onAdFailed?.call(error, code);

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Reload failed: $error (code: $code)');
    }
  }

  /// Handles method calls from the native platform.
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    // Check if this call is for this controller
    final String? controllerId = call.arguments?['controllerId'];
    if (controllerId != null && controllerId != _id) {
      return;
    }

    if (_isDisposed) return;

    switch (call.method) {
      case 'onAdLoaded':
        _handleAdLoaded();
        break;
      case 'onAdFailedToLoad':
        final error = call.arguments?['error'] as String? ?? 'Unknown error';
        final code = call.arguments?['errorCode'] as int? ?? -1;
        _handleAdFailed(error, code);
        break;
      case 'onAdClicked':
        _handleAdClicked();
        break;
      case 'onAdImpression':
        _handleAdImpression();
        break;
      case 'onAdOpened':
        _handleAdOpened();
        break;
      case 'onAdClosed':
        _handleAdClosed();
        break;
    }
  }

  /// Handles successful ad load.
  void _handleAdLoaded() {
    _state = NativeAdState.loaded;
    _errorMessage = null;
    _errorCode = null;
    _stateController.add(_state);

    // Notify schedulers
    _preloadScheduler?.onAdLoaded();
    _preloadScheduler?.updateAdState(_state);
    _reloadScheduler?.onReloadSuccess();
    
    events.onAdLoaded?.call();

    // Complete preload if pending
    if (_preloadCompleter != null && !_preloadCompleter!.isCompleted) {
      _isPreloaded = true;
      _preloadCompleter!.complete(true);
      _preloadCompleter = null;
    }

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Ad loaded: $_id');
    }
  }

  /// Handles ad load failure.
  void _handleAdFailed(String error, int code) {
    _state = NativeAdState.error;
    _errorMessage = error;
    _errorCode = code;
    _stateController.add(_state);

    // Notify schedulers to trigger backoff retry
    _preloadScheduler?.onAdFailed();
    _preloadScheduler?.updateAdState(_state);
    _reloadScheduler?.onReloadFailed();
    
    events.onAdFailed?.call(error, code);

    // Complete preload with failure if pending
    if (_preloadCompleter != null && !_preloadCompleter!.isCompleted) {
      _preloadCompleter!.complete(false);
      _preloadCompleter = null;
    }

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Ad failed: $error (code: $code)');
    }
  }

  /// Handles ad click.
  void _handleAdClicked() {
    events.onAdClicked?.call();
    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Ad clicked: $_id');
    }
  }

  /// Handles ad impression.
  void _handleAdImpression() {
    // Notify scheduler to start cooldown if smart preload enabled
    _preloadScheduler?.onAdImpression();

    events.onAdImpression?.call();
    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Ad impression: $_id');
    }
  }

  /// Handles ad opened.
  void _handleAdOpened() {
    events.onAdOpened?.call();
    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Ad opened: $_id');
    }
  }

  /// Handles ad closed.
  void _handleAdClosed() {
    events.onAdClosed?.call();
    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Ad closed: $_id');
    }
  }

  /// Preloads the native ad and waits for completion.
  ///
  /// Unlike [loadAd], this method waits until the ad is fully loaded
  /// or fails to load. Use this when you want to preload ads before
  /// displaying them.
  ///
  /// Returns `true` if the ad loaded successfully, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final controller = NativeAdController(options: options);
  /// final success = await controller.preload();
  /// if (success) {
  ///   // Ad is ready, show the widget
  /// }
  /// ```
  Future<bool> preload() async {
    if (_isDisposed) {
      throw StateError('Cannot preload: controller has been disposed');
    }

    // Already preloaded or loaded
    if (_isPreloaded || _state == NativeAdState.loaded) {
      return true;
    }

    // Create completer for this preload operation
    _preloadCompleter = Completer<bool>();

    // Trigger load
    await loadAd();

    // Return the completer's future (will be completed in _handleAdLoaded or _handleAdFailed)
    return _preloadCompleter!.future;
  }

  /// Loads the native ad.
  ///
  /// This triggers the native platform to load an ad with the
  /// configured options. The result is communicated through
  /// the [events] callbacks or [stateStream].
  ///
  /// Returns a Future that completes when the load request is sent.
  /// Note: This does not wait for the ad to actually load.
  /// For preloading with completion, use [preload] instead.
  Future<void> loadAd() async {
    if (_isDisposed) {
      throw StateError('Cannot load ad: controller has been disposed');
    }

    // If smart preload enabled, let scheduler decide
    if (options.enableSmartPreload && _preloadScheduler != null) {
      if (options.enableDebugLogs) {
        debugPrint('[NativeAdController] Smart preload enabled, evaluating...');
      }
      _preloadScheduler!.evaluateAndLoad();
      return;
    }

    // Otherwise use direct load (existing behavior)
    await _performLoadAd();
  }

  /// Internal method that actually performs the ad load.
  ///
  /// Called by scheduler when smart preload is enabled, or directly
  /// by loadAd() when smart preload is disabled.
  Future<void> _performLoadAd() async {
    if (_isDisposed) return;

    _state = NativeAdState.loading;
    _errorMessage = null;
    _errorCode = null;
    _stateController.add(_state);

    // Notify scheduler of state change
    _preloadScheduler?.updateAdState(_state);

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Loading ad: $_id');
    }

    try {
      await _channel.invokeMethod('loadAd', {
        'controllerId': _id,
        ...options.toMap(),
      });
    } on PlatformException catch (e) {
      _handleAdFailed(e.message ?? 'Platform error', -1);
    }
  }

  /// Reloads the native ad.
  ///
  /// This destroys any existing ad and loads a new one.
  Future<void> reload() async {
    if (_isDisposed) {
      throw StateError('Cannot reload ad: controller has been disposed');
    }

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Reloading ad: $_id');
    }

    // Use the same reload flow as smart reload
    await _performReload();
  }

  /// Updates the event callbacks.
  void updateEvents(NativeAdEvents newEvents) {
    events = newEvents;
  }

  /// Disposes the controller and releases resources.
  ///
  /// After calling dispose, the controller cannot be used again.
  Future<void> dispose() async {
    if (_isDisposed) return;

    _isDisposed = true;

    // Dispose smart preload and reload services
    _preloadScheduler?.dispose();
    _reloadScheduler?.dispose();
    _lifecycleManager?.dispose();
    _networkManager?.dispose();

    if (options.enableDebugLogs) {
      debugPrint('[NativeAdController] Disposing: $_id');
    }

    try {
      await _channel.invokeMethod('disposeAd', {'controllerId': _id});
    } on PlatformException catch (e) {
      if (options.enableDebugLogs) {
        debugPrint('[NativeAdController] Dispose error: ${e.message}');
      }
    }

    await _stateController.close();
  }
}

/// Represents the state of a native ad.
enum NativeAdState {
  /// Initial state, ad has not been loaded yet.
  initial,

  /// Ad is currently being loaded.
  loading,

  /// Ad has been loaded successfully.
  loaded,

  /// Ad failed to load.
  error,
}
