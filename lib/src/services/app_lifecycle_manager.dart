import 'dart:async';
import 'package:flutter/widgets.dart';

/// Manages app lifecycle state (foreground/background) using [WidgetsBindingObserver].
///
/// This service monitors the app's lifecycle state and provides:
/// - Current foreground/background status via [isAppInForeground]
/// - Stream of state changes via [foregroundStream]
///
/// Used by the smart preload system to prevent ad loading when app is in background.
///
/// Example:
/// ```dart
/// final manager = AppLifecycleManager();
/// manager.initialize();
///
/// if (manager.isAppInForeground) {
///   // Load ads
/// }
///
/// manager.foregroundStream.listen((inForeground) {
///   if (inForeground) {
///     // App came to foreground, resume ad loading
///   }
/// });
/// ```
class AppLifecycleManager with WidgetsBindingObserver {
  bool _isInForeground = true;
  final _foregroundController = StreamController<bool>.broadcast();

  /// Whether the app is currently in foreground (resumed state).
  ///
  /// Returns `true` when app is active and visible to user.
  /// Returns `false` when app is paused, inactive, or in background.
  bool get isAppInForeground => _isInForeground;

  /// Stream that emits `true` when app enters foreground, `false` when backgrounded.
  ///
  /// Only emits when state actually changes (debounced).
  Stream<bool> get foregroundStream => _foregroundController.stream;

  /// Initializes the lifecycle manager and starts monitoring app state.
  ///
  /// Must be called before using this manager. Safe to call multiple times (idempotent).
  void initialize() {
    WidgetsBinding.instance.addObserver(this);

    // Detect initial state
    final currentState = WidgetsBinding.instance.lifecycleState;
    _isInForeground = currentState == AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final wasInForeground = _isInForeground;
    _isInForeground = state == AppLifecycleState.resumed;

    // Only emit when state actually changes
    if (wasInForeground != _isInForeground) {
      _foregroundController.add(_isInForeground);
    }
  }

  /// Disposes the lifecycle manager and cleans up resources.
  ///
  /// Removes observer and closes streams. After calling dispose, this manager
  /// should not be used again.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _foregroundController.close();
  }
}
