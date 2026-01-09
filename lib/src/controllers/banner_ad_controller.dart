import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/ad_state_base.dart';
import '../models/banner_ad_events.dart';
import '../models/banner_ad_options.dart';
import '../services/app_lifecycle_manager.dart';
import '../services/network_connectivity_manager.dart';
import '../services/preload_scheduler.dart';
import '../services/reload_scheduler.dart';
import 'ad_controller_mixin.dart';

export 'banner_ad_controller.dart' show BannerAdState;

/// Controller for managing banner ad lifecycle and state.
///
/// This controller handles communication with the native platform,
/// manages ad loading state, and routes callbacks from the native SDK
/// to Flutter.
///
/// Example:
/// ```dart
/// final controller = BannerAdController(
///   options: BannerAdOptions(adUnitId: 'xxx'),
///   events: BannerAdEvents(
///     onAdLoaded: () => print('Loaded'),
///     onAdFailed: (error, code) => print('Failed: $error'),
///   ),
/// );
///
/// await controller.loadAd();
/// // ... use controller
/// controller.dispose();
/// ```
class BannerAdController extends Object with AdControllerMixin<BannerAdState> {
  /// Creates a [BannerAdController] with the given options and events.
  BannerAdController({
    required this.options,
    this.events = const BannerAdEvents(),
  }) : _id = _generateId(),
       _state = BannerAdState.initial {
    setupChannel();

    // Initialize smart preload if enabled
    if (options.enableSmartPreload) {
      initializeSmartPreload();
    }

    // Initialize smart reload if enabled
    if (options.enableSmartReload) {
      initializeSmartReload();
    }
  }

  /// Unique identifier for this controller instance.
  final String _id;

  /// Configuration options for the ad.
  final BannerAdOptions options;

  /// Event callbacks for ad lifecycle events.
  BannerAdEvents events;

  /// Method channel for platform communication.
  @override
  final MethodChannel channel = const MethodChannel('flutter_admob_banner_ads');

  /// Current state of the ad.
  BannerAdState _state;

  /// Stream controller for state changes.
  @override
  final StreamController<BannerAdState> stateController =
      StreamController<BannerAdState>.broadcast();

  /// Completer for preload operation (null if not preloading).
  @override
  Completer<bool>? preloadCompleter;

  /// Error message if loading failed.
  @override
  String? errorMessage;

  /// Error code if loading failed.
  @override
  int? errorCode;

  /// Smart preload services (lazy initialized when enableSmartPreload is true).
  @override
  AppLifecycleManager? lifecycleManager;

  @override
  NetworkConnectivityManager? networkManager;

  @override
  PreloadScheduler? preloadScheduler;

  /// Reload scheduler (lazy initialized when enableSmartReload is true).
  @override
  ReloadScheduler? reloadScheduler;

  /// Whether the controller has been disposed.
  @override
  bool isDisposed = false;

  /// Whether the ad has been preloaded.
  @override
  bool isPreloaded = false;

  /// Whether the ad is currently visible on screen.
  @override
  bool isAdVisible = false;

  /// Counter for generating unique IDs.
  static int _idCounter = 0;

  /// Generates a unique ID for the controller.
  static String _generateId() {
    _idCounter++;
    return 'banner_ad_${DateTime.now().millisecondsSinceEpoch}_$_idCounter';
  }

  @override
  Type get controllerType => BannerAdController;

  // AdControllerMixin implementation

  @override
  Map<String, dynamic> get optionsMap => options.toMap();

  @override
  bool get enableDebugLogs => options.enableDebugLogs;

  @override
  String get id => _id;

  @override
  BannerAdState get state => _state;

  @override
  set state(BannerAdState newState) => _state = newState;

  @override
  BannerAdState stateFromIndex(int index) => BannerAdState.values[index];

  @override
  int get stateIndex => _state.index;

  @override
  String get loadMethodName => 'loadBannerAd';

  @override
  String get reloadMethodName => 'reloadBannerAd';

  @override
  String get disposeMethodName => 'disposeBannerAd';

  @override
  void Function() get onAdLoadedCallback => () => events.onAdLoaded?.call();

  @override
  void Function(String error, int code) get onAdFailedCallback =>
      (error, code) => events.onAdFailed?.call(error, code);

  @override
  void Function() get onAdClickedCallback => () => events.onAdClicked?.call();

  @override
  void Function() get onAdImpressionCallback => () => events.onAdImpression?.call();

  @override
  void Function() get onAdOpenedCallback => () => events.onAdOpened?.call();

  @override
  void Function() get onAdClosedCallback => () => events.onAdClosed?.call();

  @override
  void handleAdPaid(double value, String currency) {
    events.onAdPaid?.call(value, currency);
    if (enableDebugLogs) {
      debugPrint('[BannerAdController] Ad paid: \$$value $currency');
    }
  }

  @override
  bool checkCachedAd() => false; // Banner ads don't use cache

  @override
  Future<void> showCachedAd() async {} // Banner ads don't use cache

  @override
  Future<void> triggerPreloadForCache() async {} // Banner ads don't use cache

  // Public API

  /// Gets the unique identifier for this controller.
  String get controllerId => _id;

  /// Stream of state changes.
  Stream<BannerAdState> get stateStream => stateController.stream;

  /// Whether the ad is currently loading.
  bool get isLoading => state == BannerAdState.loading;

  /// Whether the ad has been loaded successfully.
  bool get isLoaded => state == BannerAdState.loaded;

  /// Whether the ad failed to load.
  bool get hasError => state == BannerAdState.error;

  /// Updates the event callbacks.
  void updateEvents(BannerAdEvents newEvents) {
    events = newEvents;
  }
}

/// Represents the state of a banner ad.
enum BannerAdState implements AdStateBase {
  /// Initial state, ad has not been loaded yet.
  initial,

  /// Ad is currently being loaded.
  loading,

  /// Ad has been loaded successfully.
  loaded,

  /// Ad failed to load.
  error;

  @override
  bool get isLoading => this == BannerAdState.loading;

  @override
  bool get isLoaded => this == BannerAdState.loaded;

  @override
  bool get hasError => this == BannerAdState.error;
}
