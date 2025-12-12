import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/native_ad_events.dart';
import '../models/native_ad_options.dart';

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

  /// Stream controller for state changes.
  final StreamController<NativeAdState> _stateController =
      StreamController<NativeAdState>.broadcast();

  /// Current state of the ad.
  NativeAdState _state = NativeAdState.initial;

  /// Error message if loading failed.
  String? _errorMessage;

  /// Error code if loading failed.
  int? _errorCode;

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

  /// Generates a unique ID for the controller.
  static String _generateId() {
    _idCounter++;
    return 'native_ad_${DateTime.now().millisecondsSinceEpoch}_$_idCounter';
  }

  /// Sets up the method channel for receiving callbacks.
  void _setupChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
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
    events.onAdLoaded?.call();

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
    events.onAdFailed?.call(error, code);

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

  /// Loads the native ad.
  ///
  /// This triggers the native platform to load an ad with the
  /// configured options. The result is communicated through
  /// the [events] callbacks or [stateStream].
  ///
  /// Returns a Future that completes when the load request is sent.
  /// Note: This does not wait for the ad to actually load.
  Future<void> loadAd() async {
    if (_isDisposed) {
      throw StateError('Cannot load ad: controller has been disposed');
    }

    _state = NativeAdState.loading;
    _errorMessage = null;
    _errorCode = null;
    _stateController.add(_state);

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

    try {
      await _channel.invokeMethod('reloadAd', {
        'controllerId': _id,
        ...options.toMap(),
      });
      _state = NativeAdState.loading;
      _stateController.add(_state);
    } on PlatformException catch (e) {
      _handleAdFailed(e.message ?? 'Platform error', -1);
    }
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
