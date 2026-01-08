import 'dart:async';
import 'package:flutter/foundation.dart';

import '../controllers/native_ad_controller.dart';
import 'app_lifecycle_manager.dart';
import 'network_connectivity_manager.dart';

/// Orchestrates intelligent ad preloading with 4-layer awareness system.
///
/// **Layer 1 - Awareness**: Checks app foreground, internet, cooldown, retry limit
/// **Layer 2 - Cache/Loading**: Avoids redundant requests if ad loading or cached
/// **Layer 3 - Request**: Single point for actual ad SDK calls
/// **Layer 4 - Backoff**: Exponential retry delays on failure (10s → 20s → 40s)
///
/// This scheduler implements the flowchart logic from new_logic_preload.md to:
/// - Only load ads when app is in foreground with internet
/// - Apply exponential backoff on failures
/// - Respect 90-second cooldown after impressions
/// - Stop after 3 failed attempts
/// - Reset retry counter when network restored
///
/// Example:
/// ```dart
/// final scheduler = PreloadScheduler(
///   lifecycleManager: lifecycleManager,
///   networkManager: networkManager,
///   loadAdCallback: () => _performLoadAd(),
///   enableDebugLogs: true,
/// );
/// scheduler.initialize();
///
/// // Scheduler automatically handles when to load
/// scheduler.evaluateAndLoad();
/// ```
class PreloadScheduler {
  PreloadScheduler({
    required this.lifecycleManager,
    required this.networkManager,
    required this.loadAdCallback,
    this.enableDebugLogs = false,
  });

  final AppLifecycleManager lifecycleManager;
  final NetworkConnectivityManager networkManager;
  final void Function() loadAdCallback;
  final bool enableDebugLogs;

  // State
  int _retryCount = 0;
  DateTime? _lastImpressionTime;
  NativeAdState _currentAdState = NativeAdState.initial;
  Timer? _retryTimer;
  StreamSubscription? _lifecycleSubscription;
  StreamSubscription? _networkSubscription;
  bool _isDisposed = false;

  // Constants (hardcoded per requirements)
  static const _maxRetries = 3;
  static const _cooldownDuration = Duration(seconds: 90);
  static const _backoffDelays = [
    Duration(seconds: 10),
    Duration(seconds: 20),
    Duration(seconds: 40),
  ];

  /// Initializes the scheduler and starts listening to lifecycle and network changes.
  void initialize() {
    // Listen to app foreground/background changes
    _lifecycleSubscription = lifecycleManager.foregroundStream.listen(
      (inForeground) {
        if (inForeground) {
          _log('📱 App entered foreground, re-evaluating...');
          evaluateAndLoad();
        } else {
          _log('📱 App entered background');
        }
      },
    );

    // Listen to network connectivity changes
    _networkSubscription = networkManager.connectivityStream.listen(
      (connected) {
        if (connected) {
          _log('🌐 Connection restored, resetting retry counter');
          _retryCount = 0; // Reset per requirements
          evaluateAndLoad();
        } else {
          _log('🌐 Connection lost');
        }
      },
    );
  }

  /// LAYER 1: Awareness checks
  ///
  /// Returns true only if all conditions are met:
  /// - App is in foreground
  /// - Internet is available
  /// - Cooldown is not active
  /// - Retry limit not reached
  bool get _canAttemptLoad {
    if (!lifecycleManager.isAppInForeground) {
      _log('❌ Cannot load: app in background');
      return false;
    }

    if (!networkManager.isConnected) {
      _log('❌ Cannot load: no internet connection');
      return false;
    }

    if (_isCooldownActive) {
      final remaining = _cooldownRemaining.inSeconds;
      _log('❌ Cannot load: cooldown active ($remaining seconds remaining)');
      return false;
    }

    if (_retryCount >= _maxRetries) {
      _log('❌ Cannot load: max retries reached ($_retryCount/$_maxRetries)');
      return false;
    }

    return true;
  }

  bool get _isCooldownActive {
    if (_lastImpressionTime == null) return false;
    return DateTime.now().difference(_lastImpressionTime!) < _cooldownDuration;
  }

  Duration get _cooldownRemaining {
    if (_lastImpressionTime == null) return Duration.zero;
    final elapsed = DateTime.now().difference(_lastImpressionTime!);
    final remaining = _cooldownDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// LAYER 2 & 3: Evaluate awareness + cache/loading checks and trigger load if ready
  ///
  /// This is the main entry point for ad loading logic. It checks:
  /// 1. Awareness layer (foreground, internet, cooldown, retry limit)
  /// 2. If ad is already loading → wait 25s
  /// 3. If ad is already cached → wait 10s
  /// 4. Otherwise → trigger actual ad request
  void evaluateAndLoad() {
    if (_isDisposed) return;

    // LAYER 1: Awareness checks
    if (!_canAttemptLoad) return;

    // LAYER 2: Cache/Loading checks
    if (_currentAdState == NativeAdState.loading) {
      _log('⏳ Ad is currently loading, waiting 25 seconds...');
      _scheduleWaitRetry(const Duration(seconds: 25));
      return;
    }

    if (_currentAdState == NativeAdState.loaded) {
      _log('✅ Ad already cached, waiting 10 seconds before refresh check...');
      _scheduleWaitRetry(const Duration(seconds: 10));
      return;
    }

    // LAYER 3: Request
    _log('🚀 All checks passed, requesting ad...');
    loadAdCallback(); // Trigger actual ad request
  }

  void _scheduleWaitRetry(Duration delay) {
    if (_isDisposed) return;

    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      if (_isDisposed) return;
      evaluateAndLoad();
    });
  }

  /// LAYER 4: Handle ad load failure with exponential backoff
  ///
  /// Called by controller when ad fails to load.
  /// Increments retry counter and schedules retry with exponential delay:
  /// - Retry 1: 10s
  /// - Retry 2: 20s
  /// - Retry 3: 40s
  /// - Retry 4+: Stop (max retries = 3)
  void onAdFailed() {
    if (_isDisposed) return;

    _retryCount++;
    _log('❌ Ad failed to load (retry $_retryCount/$_maxRetries)');

    if (_retryCount >= _maxRetries) {
      _log('🛑 Max retries reached, stopping');
      return;
    }

    final delay = _backoffDelays[_retryCount - 1];
    _log('⏰ Scheduling retry with ${delay.inSeconds}s backoff delay...');

    _retryTimer?.cancel();
    _retryTimer = Timer(delay, () {
      if (_isDisposed) return;
      _log('🔄 Retry attempt $_retryCount after backoff');
      evaluateAndLoad();
    });
  }

  /// Called by controller when ad successfully loads.
  ///
  /// Resets retry counter on success.
  void onAdLoaded() {
    if (_isDisposed) return;

    _retryCount = 0;
    _log('✅ Ad loaded successfully, retry counter reset');
  }

  /// Called by controller when ad impression is recorded.
  ///
  /// Starts 90-second cooldown and resets retry counter.
  void onAdImpression() {
    if (_isDisposed) return;

    _lastImpressionTime = DateTime.now();
    _retryCount = 0;
    _log('👁️ Impression recorded, 90s cooldown started, retry counter reset');
  }

  /// Updates the current ad state.
  ///
  /// Called by controller when ad state changes (initial, loading, loaded, error).
  /// Used by Layer 2 to avoid redundant requests.
  void updateAdState(NativeAdState state) {
    if (_isDisposed) return;

    _currentAdState = state;
    _log('📊 Ad state updated: ${state.name}');
  }

  /// Disposes the scheduler and cleans up resources.
  ///
  /// Cancels timers and subscriptions. After calling dispose, this scheduler
  /// should not be used again.
  void dispose() {
    _isDisposed = true;
    _retryTimer?.cancel();
    _lifecycleSubscription?.cancel();
    _networkSubscription?.cancel();
  }

  void _log(String message) {
    if (enableDebugLogs) {
      debugPrint('[PreloadScheduler] $message');
    }
  }
}
