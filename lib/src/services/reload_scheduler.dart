import 'dart:async';
import 'package:flutter/foundation.dart';

import 'app_lifecycle_manager.dart';
import 'network_connectivity_manager.dart';

/// Callback signature for reload operations.
typedef ReloadCallback = Future<void> Function();

/// Callback signature for checking if cached ad is available.
typedef CacheCheckCallback = bool Function();

/// Callback signature for showing cached ad.
typedef ShowCachedAdCallback = Future<void> Function();

/// Callback signature for preload trigger after showing cached ad.
typedef PreloadTriggerCallback = Future<void> Function();

/// Orchestrates intelligent ad reloading with visibility-aware logic.
///
/// **Reload Flow (from flowchart):**
/// 1. checkVisibility() - App must be in foreground AND ad must be visible
/// 2. Check cache - If preloaded ad exists, use it immediately
/// 3. If cache hit → Destroy old ad, show cached ad, trigger preload
/// 4. If no cache → Request new ad directly
/// 5. On success → Destroy old ad, show new ad
/// 6. On failure → Delay 10-15s, retry from start
/// 7. Remote config can trigger reload at intervals
///
/// Example:
/// ```dart
/// final scheduler = ReloadScheduler(
///   lifecycleManager: lifecycleManager,
///   networkManager: networkManager,
///   reloadCallback: () => controller.reload(),
///   cacheCheckCallback: () => preloadedAdController.isLoaded,
///   showCachedAdCallback: () => showPreloadedAd(),
///   preloadTriggerCallback: () => preloadedAdController.preload(),
///   enableDebugLogs: true,
/// );
/// scheduler.initialize();
/// ```
class ReloadScheduler {
  ReloadScheduler({
    required this.lifecycleManager,
    required this.networkManager,
    required this.reloadCallback,
    required this.cacheCheckCallback,
    required this.showCachedAdCallback,
    required this.preloadTriggerCallback,
    this.reloadIntervalSeconds,
    this.retryDelaySeconds = 12,
    this.enableDebugLogs = false,
  });

  final AppLifecycleManager lifecycleManager;
  final NetworkConnectivityManager networkManager;

  /// Callback to reload the current ad (destroy old + request new).
  final ReloadCallback reloadCallback;

  /// Callback to check if a cached/preloaded ad is available.
  final CacheCheckCallback cacheCheckCallback;

  /// Callback to show the cached ad (swap current with cached).
  final ShowCachedAdCallback showCachedAdCallback;

  /// Callback to trigger preload after showing cached ad.
  final PreloadTriggerCallback preloadTriggerCallback;

  /// Remote config interval in seconds. If set, reload triggers automatically.
  final int? reloadIntervalSeconds;

  /// Delay in seconds before retry on failure (10-15s range recommended).
  final int retryDelaySeconds;

  final bool enableDebugLogs;

  // State
  bool _isAdVisible = false;
  bool _isReloading = false;
  Timer? _retryTimer;
  Timer? _remoteConfigTimer;
  StreamSubscription? _lifecycleSubscription;
  StreamSubscription? _networkSubscription;
  bool _isDisposed = false;

  /// Whether the ad is currently visible on screen.
  bool get isAdVisible => _isAdVisible;

  /// Whether a reload operation is in progress.
  bool get isReloading => _isReloading;

  /// Initializes the scheduler and starts listening to lifecycle and network changes.
  void initialize() {
    // Listen to app foreground/background changes
    _lifecycleSubscription = lifecycleManager.foregroundStream.listen(
      (inForeground) {
        if (inForeground && _isAdVisible) {
          _log('📱 App resumed with visible ad, checking for reload...');
          // Don't auto-trigger reload on resume, wait for remote config or manual trigger
        } else if (!inForeground) {
          _log('📱 App entered background, pausing reload logic');
          _cancelPendingOperations();
        }
      },
    );

    // Listen to network connectivity changes
    _networkSubscription = networkManager.connectivityStream.listen(
      (connected) {
        if (connected && _isAdVisible) {
          _log('🌐 Connection restored with visible ad');
        } else if (!connected) {
          _log('🌐 Connection lost');
        }
      },
    );

    // Start remote config timer if interval is set
    _startRemoteConfigTimer();
  }

  /// Starts the remote config interval timer for automatic reloads.
  void _startRemoteConfigTimer() {
    if (reloadIntervalSeconds == null || reloadIntervalSeconds! <= 0) return;

    _remoteConfigTimer?.cancel();
    _remoteConfigTimer = Timer.periodic(
      Duration(seconds: reloadIntervalSeconds!),
      (_) {
        _log('⏰ Remote config timer triggered (${reloadIntervalSeconds}s)');
        triggerReload();
      },
    );
    _log('⏰ Remote config timer started: ${reloadIntervalSeconds}s interval');
  }

  /// Updates the remote config interval and restarts the timer.
  void updateReloadInterval(int? seconds) {
    _remoteConfigTimer?.cancel();
    if (seconds != null && seconds > 0) {
      _remoteConfigTimer = Timer.periodic(
        Duration(seconds: seconds),
        (_) {
          _log('⏰ Remote config timer triggered (${seconds}s)');
          triggerReload();
        },
      );
      _log('⏰ Remote config interval updated: ${seconds}s');
    }
  }

  /// Updates the ad visibility state.
  ///
  /// Call this when the ad widget becomes visible or hidden on screen.
  /// Reload logic only proceeds when ad is visible.
  void updateAdVisibility(bool isVisible) {
    if (_isDisposed) return;

    final wasVisible = _isAdVisible;
    _isAdVisible = isVisible;

    if (wasVisible != isVisible) {
      _log('👁️ Ad visibility changed: $isVisible');

      if (!isVisible) {
        // Ad hidden, cancel any pending reload operations
        _cancelPendingOperations();
      }
    }
  }

  /// LAYER 1: Visibility check (mandatory gate).
  ///
  /// Returns true only if:
  /// - App is in foreground
  /// - Ad is currently visible on screen
  /// - Network is available
  bool checkVisibility() {
    if (!lifecycleManager.isAppInForeground) {
      _log('❌ Visibility check failed: app in background');
      return false;
    }

    if (!_isAdVisible) {
      _log('❌ Visibility check failed: ad not visible');
      return false;
    }

    if (!networkManager.isConnected) {
      _log('❌ Visibility check failed: no internet connection');
      return false;
    }

    _log('✅ Visibility check passed');
    return true;
  }

  /// Main entry point to trigger a reload.
  ///
  /// This implements the flowchart logic:
  /// 1. Check visibility (mandatory gate)
  /// 2. Check cache
  /// 3. If cache → show cached, trigger preload
  /// 4. If no cache → request new ad
  void triggerReload() {
    if (_isDisposed) return;

    _log('🔄 Reload triggered');

    // LAYER 1: Visibility check (mandatory gate)
    if (!checkVisibility()) {
      _log('⏹️ Reload stopped: visibility check failed');
      return;
    }

    // Prevent concurrent reloads
    if (_isReloading) {
      _log('⏳ Reload already in progress, skipping...');
      return;
    }

    _isReloading = true;
    _executeReloadFlow();
  }

  /// Executes the reload flow based on cache availability.
  Future<void> _executeReloadFlow() async {
    if (_isDisposed) return;

    // LAYER 2: Check cache
    final hasCachedAd = cacheCheckCallback();
    _log('📦 Cache check: ${hasCachedAd ? "HIT" : "MISS"}');

    if (hasCachedAd) {
      // Cache HIT: Notify widget to swap to cached ad, then trigger preload
      _log('🚀 Cache available, notifying widget to swap...');

      try {
        // Notify widget that cached ad is ready - widget will handle the swap
        await showCachedAdCallback();
        _log('✅ Widget notified to swap to cached ad');

        // Trigger preload for next reload cycle
        _log('📥 Starting background preload for next cycle...');
        preloadTriggerCallback();

        _isReloading = false;
      } catch (e) {
        _log('❌ Error during cache swap: $e');
        _handleReloadFailure();
      }
    } else {
      // Cache MISS: Request new ad directly via native reload
      _log('📡 No cache, requesting new ad via native reload...');

      try {
        await reloadCallback();
        // Success/failure will be handled by onReloadSuccess/onReloadFailed
      } catch (e) {
        _log('❌ Error requesting new ad: $e');
        _handleReloadFailure();
      }
    }
  }

  /// Called when reload succeeds.
  ///
  /// Resets state and logs success.
  void onReloadSuccess() {
    if (_isDisposed) return;

    _log('✅ Reload completed successfully');
    _isReloading = false;
    _retryTimer?.cancel();
  }

  /// Called when reload fails.
  ///
  /// Schedules retry with delay (10-15s).
  void onReloadFailed() {
    if (_isDisposed) return;

    _log('❌ Reload failed');
    _handleReloadFailure();
  }

  void _handleReloadFailure() {
    _isReloading = false;

    // Schedule retry with delay
    _log('⏰ Scheduling retry in ${retryDelaySeconds}s...');
    _retryTimer?.cancel();
    _retryTimer = Timer(
      Duration(seconds: retryDelaySeconds),
      () {
        if (_isDisposed) return;
        _log('🔄 Retry after ${retryDelaySeconds}s delay');
        triggerReload();
      },
    );
  }

  void _cancelPendingOperations() {
    _retryTimer?.cancel();
    _isReloading = false;
  }

  /// Disposes the scheduler and cleans up resources.
  void dispose() {
    _isDisposed = true;
    _retryTimer?.cancel();
    _remoteConfigTimer?.cancel();
    _lifecycleSubscription?.cancel();
    _networkSubscription?.cancel();
  }

  void _log(String message) {
    if (enableDebugLogs) {
      debugPrint('[ReloadScheduler] $message');
    }
  }
}
