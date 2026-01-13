import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../services/app_lifecycle_manager.dart';
import '../services/network_connectivity_manager.dart';
import '../services/preload_scheduler.dart';
import '../services/reload_scheduler.dart';

/// Mixin containing shared ad controller logic.
///
/// This mixin provides all common functionality for [NativeAdController] and
/// [BannerAdController], including smart preload/reload, visibility tracking,
/// and event handling.
///
/// Classes using this mixin must provide:
/// - The method channel
/// - State getter/setter
/// - ID getter
/// - Options map
/// - Debug logs flag
mixin AdControllerMixin<TState> {
  /// Method channel for platform communication.
  MethodChannel get channel;

  /// Current state of the ad.
  TState get state;

  /// Sets the current state.
  set state(TState newState);

  /// Gets the state from an index (for scheduler callbacks).
  TState stateFromIndex(int index);

  /// Gets the numeric index of the current state (used by schedulers).
  int get stateIndex;

  /// Unique identifier for this controller instance.
  String get id;

  /// Options map from the concrete controller.
  Map<String, dynamic> get optionsMap;

  /// Whether debug logs are enabled.
  bool get enableDebugLogs;

  /// Stream controller for state changes.
  StreamController<TState> get stateController;

  /// Event callback for ad loaded.
  void Function() get onAdLoadedCallback;

  /// Event callback for ad failed.
  void Function(String error, int code) get onAdFailedCallback;

  /// Event callback for ad clicked.
  void Function() get onAdClickedCallback;

  /// Event callback for ad impression.
  void Function() get onAdImpressionCallback;

  /// Event callback for ad opened.
  void Function() get onAdOpenedCallback;

  /// Event callback for ad closed.
  void Function() get onAdClosedCallback;

  /// Whether the controller has been disposed.
  bool get isDisposed;
  set isDisposed(bool value);

  /// Whether the ad has been preloaded.
  bool get isPreloaded;
  set isPreloaded(bool value);

  /// Completer for preload operation (null if not preloading).
  Completer<bool>? get preloadCompleter;
  set preloadCompleter(Completer<bool>? value);

  /// Error message if loading failed.
  String? get errorMessage;
  set errorMessage(String? value);

  /// Error code if loading failed.
  int? get errorCode;
  set errorCode(int? value);

  /// Smart preload services (lazy initialized when enableSmartPreload is true).
  AppLifecycleManager? get lifecycleManager;
  set lifecycleManager(AppLifecycleManager? value);

  NetworkConnectivityManager? get networkManager;
  set networkManager(NetworkConnectivityManager? value);

  PreloadScheduler? get preloadScheduler;
  set preloadScheduler(PreloadScheduler? value);

  /// Reload scheduler (lazy initialized when enableSmartReload is true).
  ReloadScheduler? get reloadScheduler;
  set reloadScheduler(ReloadScheduler? value);

  /// Whether the ad is currently visible on screen.
  bool get isAdVisible;
  set isAdVisible(bool value);

  /// Checks if a cached ad is available (for native ads with cache management).
  bool checkCachedAd();

  /// Shows the cached ad (for native ads with cache management).
  Future<void> showCachedAd();

  /// Triggers preload for next cache (for native ads with cache management).
  Future<void> triggerPreloadForCache();

  /// Gets the load method name.
  String get loadMethodName;

  /// Gets the reload method name.
  String get reloadMethodName;

  /// Gets the dispose method name.
  String get disposeMethodName;

  /// Gets the runtime type for logging.
  Type get controllerType;

  /// Sets up the method channel for receiving callbacks.
  void setupChannel() {
    channel.setMethodCallHandler(handleMethodCall);
  }

  /// Initializes smart preload services when enableSmartPreload is true.
  void initializeSmartPreload() {
    // Create managers
    lifecycleManager = AppLifecycleManager();
    networkManager = NetworkConnectivityManager();

    // Initialize lifecycle manager
    lifecycleManager!.initialize();

    // Initialize network manager asynchronously
    networkManager!.initialize().then((_) {
      // Create scheduler after network check completes
      final scheduler = PreloadScheduler(
        lifecycleManager: lifecycleManager!,
        networkManager: networkManager!,
        loadAdCallback: () => performLoad(),
        enableDebugLogs: enableDebugLogs,
      );
      preloadScheduler = scheduler;
      scheduler.initialize();

      if (enableDebugLogs) {
        debugPrint('[$controllerType] Smart preload initialized for $id');
      }

      // Trigger initial evaluation
      scheduler.evaluateAndLoad();
    });
  }

  /// Initializes smart reload services when enableSmartReload is true.
  void initializeSmartReload() {
    // Reuse lifecycle manager from preload if available, otherwise create new
    lifecycleManager ??= AppLifecycleManager()..initialize();

    // Reuse network manager from preload if available, otherwise create new
    if (networkManager == null) {
      networkManager = NetworkConnectivityManager();
      networkManager!.initialize().then((_) {
        createReloadScheduler();
      });
    } else {
      createReloadScheduler();
    }
  }

  void createReloadScheduler() {
    final scheduler = ReloadScheduler(
      lifecycleManager: lifecycleManager!,
      networkManager: networkManager!,
      reloadCallback: () => performReload(),
      cacheCheckCallback: checkCachedAd,
      showCachedAdCallback: showCachedAd,
      preloadTriggerCallback: triggerPreloadForCache,
      reloadIntervalSeconds: optionsMap['reloadIntervalSeconds'] as int? ?? 30,
      retryDelaySeconds: optionsMap['retryDelaySeconds'] as int? ?? 12,
      enableDebugLogs: enableDebugLogs,
    );
    reloadScheduler = scheduler;
    scheduler.initialize();

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Smart reload initialized for $id');
    }
  }

  /// Updates the ad visibility state for reload logic.
  void updateVisibility(bool isVisible) {
    if (isDisposed) return;

    isAdVisible = isVisible;
    reloadScheduler?.updateAdVisibility(isVisible);

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Visibility updated: $isVisible');
    }
  }

  /// Updates the remote config reload interval.
  void updateReloadInterval(int? seconds) {
    reloadScheduler?.updateReloadInterval(seconds);
  }

  /// Triggers a smart reload (visibility-aware with cache check).
  void triggerSmartReload() {
    if (optionsMap['enableSmartReload'] != true || reloadScheduler == null) {
      if (enableDebugLogs) {
        debugPrint('[$controllerType] Smart reload not enabled, using direct reload');
      }
      reload();
      return;
    }

    reloadScheduler!.triggerReload();
  }

  /// Internal: Performs the actual reload.
  Future<void> performReload() async {
    if (isDisposed) return;

    state = stateFromIndex(1); // loading
    errorMessage = null;
    errorCode = null;
    stateController.add(state);

    // Notify schedulers of state change
    preloadScheduler?.updateAdState(stateIndex);

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Performing reload: $id');
    }

    try {
      await channel.invokeMethod(reloadMethodName, {
        'controllerId': id,
        ...optionsMap,
      });
    } on PlatformException catch (e) {
      _handleReloadFailed(e.message ?? 'Platform error', -1);
    }
  }

  void _handleReloadFailed(String error, int code) {
    state = stateFromIndex(3); // error
    errorMessage = error;
    errorCode = code;
    stateController.add(state);

    reloadScheduler?.onReloadFailed();
    onAdFailedCallback(error, code);

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Reload failed: $error (code: $code)');
    }
  }

  /// Handles method calls from the native platform.
  Future<dynamic> handleMethodCall(MethodCall call) async {
    // Check if this call is for this controller
    final String? controllerId = call.arguments?['controllerId'];
    if (controllerId != null && controllerId != id) {
      return;
    }

    if (isDisposed) return;

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
      case 'onAdPaid':
        // Banner ads only - subclass should override if needed
        final value = call.arguments?['value'] as num? ?? 0;
        final currency = call.arguments?['currencyCode'] as String? ?? 'USD';
        handleAdPaid(value.toDouble(), currency);
        break;
    }
  }

  /// Handles successful ad load.
  void _handleAdLoaded() {
    state = stateFromIndex(2); // loaded
    errorMessage = null;
    errorCode = null;
    stateController.add(state);

    // Notify schedulers
    preloadScheduler?.onAdLoaded();
    preloadScheduler?.updateAdState(stateIndex);
    reloadScheduler?.onReloadSuccess();

    onAdLoadedCallback();

    // Complete preload if pending
    if (preloadCompleter != null && !preloadCompleter!.isCompleted) {
      isPreloaded = true;
      preloadCompleter!.complete(true);
      preloadCompleter = null;
    }

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Ad loaded: $id');
    }
  }

  /// Handles ad load failure.
  void _handleAdFailed(String error, int code) {
    state = stateFromIndex(3); // error
    errorMessage = error;
    errorCode = code;
    stateController.add(state);

    // Notify schedulers to trigger backoff retry
    preloadScheduler?.onAdFailed();
    preloadScheduler?.updateAdState(stateIndex);
    reloadScheduler?.onReloadFailed();

    onAdFailedCallback(error, code);

    // Complete preload with failure if pending
    if (preloadCompleter != null && !preloadCompleter!.isCompleted) {
      preloadCompleter!.complete(false);
      preloadCompleter = null;
    }

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Ad failed: $error (code: $code)');
    }
  }

  /// Handles ad click.
  void _handleAdClicked() {
    onAdClickedCallback();
    if (enableDebugLogs) {
      debugPrint('[$controllerType] Ad clicked: $id');
    }
  }

  /// Handles ad impression.
  void _handleAdImpression() {
    // Notify scheduler to start cooldown if smart preload enabled
    preloadScheduler?.onAdImpression();

    onAdImpressionCallback();
    if (enableDebugLogs) {
      debugPrint('[$controllerType] Ad impression: $id');
    }
  }

  /// Handles ad opened.
  void _handleAdOpened() {
    onAdOpenedCallback();
    if (enableDebugLogs) {
      debugPrint('[$controllerType] Ad opened: $id');
    }
  }

  /// Handles ad closed.
  void _handleAdClosed() {
    onAdClosedCallback();
    if (enableDebugLogs) {
      debugPrint('[$controllerType] Ad closed: $id');
    }
  }

  /// Handles ad paid event (banner ads only).
  void handleAdPaid(double value, String currency) {
    // Default implementation does nothing
    // Subclass can override if needed
  }

  /// Internal method that actually performs the ad load.
  Future<void> performLoad() async {
    if (isDisposed) return;

    state = stateFromIndex(1); // loading
    errorMessage = null;
    errorCode = null;
    stateController.add(state);

    // Notify scheduler of state change
    preloadScheduler?.updateAdState(stateIndex);

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Loading ad: $id');
    }

    try {
      await channel.invokeMethod(loadMethodName, {
        'controllerId': id,
        ...optionsMap,
      });
    } on PlatformException catch (e) {
      _handleAdFailed(e.message ?? 'Platform error', -1);
    }
  }

  /// Loads the ad.
  Future<void> loadAd() async {
    if (isDisposed) {
      throw StateError('Cannot load ad: controller has been disposed');
    }

    // If smart preload enabled, let scheduler decide
    if (optionsMap['enableSmartPreload'] == true && preloadScheduler != null) {
      if (enableDebugLogs) {
        debugPrint('[$controllerType] Smart preload enabled, evaluating...');
      }
      preloadScheduler!.evaluateAndLoad();
      return;
    }

    // Otherwise use direct load (existing behavior)
    await performLoad();
  }

  /// Preloads the ad and waits for completion.
  Future<bool> preload() async {
    if (isDisposed) {
      throw StateError('Cannot preload: controller has been disposed');
    }

    // Already preloaded or loaded
    if (isPreloaded || stateFromIndex(2) == state) {
      return true;
    }

    // Create completer for this preload operation
    preloadCompleter = Completer<bool>();

    // Trigger load
    await loadAd();

    // Return the completer's future
    return preloadCompleter!.future;
  }

  /// Reloads the ad.
  Future<void> reload() async {
    if (isDisposed) {
      throw StateError('Cannot reload ad: controller has been disposed');
    }

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Reloading ad: $id');
    }

    await performReload();
  }

  /// Disposes the controller and releases resources.
  Future<void> dispose() async {
    if (isDisposed) return;

    isDisposed = true;

    // Dispose smart preload and reload services
    preloadScheduler?.dispose();
    reloadScheduler?.dispose();
    lifecycleManager?.dispose();
    networkManager?.dispose();

    if (enableDebugLogs) {
      debugPrint('[$controllerType] Disposing: $id');
    }

    try {
      await channel.invokeMethod(disposeMethodName, {'controllerId': id});
    } on PlatformException catch (e) {
      if (enableDebugLogs) {
        debugPrint('[$controllerType] Dispose error: ${e.message}');
      }
    }

    await stateController.close();
  }
}
