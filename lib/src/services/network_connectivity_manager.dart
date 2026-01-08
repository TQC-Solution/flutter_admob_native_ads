import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Manages network connectivity state using the connectivity_plus package.
///
/// This service monitors internet availability and provides:
/// - Current connectivity status via [isConnected]
/// - Stream of connectivity changes via [connectivityStream]
///
/// Used by the smart preload system to prevent ad loading when offline and
/// to reset retry counters when connectivity is restored.
///
/// Example:
/// ```dart
/// final manager = NetworkConnectivityManager();
/// await manager.initialize();
///
/// if (manager.isConnected) {
///   // Load ads
/// }
///
/// manager.connectivityStream.listen((connected) {
///   if (connected) {
///     // Connection restored, can retry ad loading
///   }
/// });
/// ```
class NetworkConnectivityManager {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isConnected = true;
  final _connectivityController = StreamController<bool>.broadcast();

  /// Whether the device currently has internet connectivity.
  ///
  /// Returns `true` if connected via WiFi or mobile data.
  /// Returns `false` if no connection available.
  bool get isConnected => _isConnected;

  /// Stream that emits `true` when connectivity is restored, `false` when lost.
  ///
  /// Only emits when state actually changes. Emits immediately on restore
  /// to trigger retry counter reset in smart preload logic.
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Initializes the connectivity manager and starts monitoring network state.
  ///
  /// Must be called before using this manager. Returns a Future that completes
  /// when initial connectivity check is done.
  Future<void> initialize() async {
    try {
      // Check initial connectivity state
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);

      // Listen for connectivity changes
      _subscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          // Handle connectivity check errors (e.g., permission denied)
          debugPrint(
            '[NetworkConnectivityManager] Connectivity check error: $error',
          );
          // Assume connected on error to avoid blocking ad loads
          if (!_isConnected) {
            _isConnected = true;
            _connectivityController.add(true);
          }
        },
      );
    } catch (e) {
      // Platform doesn't support connectivity checks, assume always connected
      debugPrint(
        '[NetworkConnectivityManager] Platform does not support connectivity checks, assuming connected: $e',
      );
      _isConnected = true;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;

    // Consider connected if any connection type is available (WiFi or mobile)
    _isConnected = results.any(
      (r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet,
    );

    // Only emit when state changes from disconnected → connected
    // This triggers retry counter reset in smart preload
    if (!wasConnected && _isConnected) {
      _connectivityController.add(true);
    } else if (wasConnected && !_isConnected) {
      _connectivityController.add(false);
    }
  }

  /// Disposes the connectivity manager and cleans up resources.
  ///
  /// Cancels subscription and closes streams. After calling dispose, this
  /// manager should not be used again.
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}
