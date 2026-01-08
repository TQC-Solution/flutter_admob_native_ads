import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/native_ad_controller.dart';
import '../models/native_ad_events.dart';
import '../models/native_ad_options.dart';
import 'shimmer_ad_placeholder.dart';

/// A widget that displays a native ad.
///
/// This widget wraps the native platform view and handles:
/// - Ad loading and lifecycle
/// - Loading and error states
/// - Platform-specific rendering
///
/// Example:
/// ```dart
/// NativeAdWidget(
///   options: NativeAdOptions(
///     adUnitId: 'ca-app-pub-xxx/xxx',
///     layoutType: NativeAdLayoutType.standard,
///     style: NativeAdStyle.light(),
///   ),
///   height: 300,
///   onAdLoaded: () => print('Ad loaded'),
///   onAdFailed: (error) => print('Ad failed: $error'),
/// )
/// ```
class NativeAdWidget extends StatefulWidget {
  /// Creates a [NativeAdWidget].
  ///
  /// [options] is required and contains the ad configuration.
  /// [height] is optional; if not provided, uses the recommended height
  /// for the layout type.
  const NativeAdWidget({
    super.key,
    required this.options,
    this.controller,
    this.preloadedController,
    this.height,
    this.width,
    this.loadingWidget,
    this.errorWidget,
    this.onAdLoaded,
    this.onAdFailed,
    this.onAdClicked,
    this.onAdImpression,
    this.onCachedAdReady,
    this.autoLoad = true,
    this.visibilityThreshold = 0.5,
  });

  /// Configuration options for the ad.
  final NativeAdOptions options;

  /// Optional external controller for managing the ad.
  ///
  /// If not provided, an internal controller will be created.
  final NativeAdController? controller;

  /// Optional preloaded controller for cache-based reload.
  ///
  /// When smart reload is enabled and this controller has a loaded ad,
  /// it will be used immediately instead of requesting a new ad.
  final NativeAdController? preloadedController;

  /// Height of the ad widget.
  ///
  /// If not specified, uses the recommended height for the layout type.
  final double? height;

  /// Width of the ad widget.
  ///
  /// If not specified, takes the full available width.
  final double? width;

  /// Widget to show while the ad is loading.
  ///
  /// If not provided, shows a default loading indicator.
  final Widget? loadingWidget;

  /// Builder for the error widget.
  ///
  /// Receives the error message as a parameter.
  /// If not provided, shows a default error message.
  final Widget Function(String error)? errorWidget;

  /// Callback when the ad loads successfully.
  final VoidCallback? onAdLoaded;

  /// Callback when the ad fails to load.
  final void Function(String error)? onAdFailed;

  /// Callback when the ad is clicked.
  final VoidCallback? onAdClicked;

  /// Callback when an ad impression is recorded.
  final VoidCallback? onAdImpression;

  /// Callback when a cached ad is ready to be shown.
  ///
  /// Used by smart reload to notify when widget should swap to cached ad.
  final VoidCallback? onCachedAdReady;

  /// Whether to automatically load the ad when the widget is created.
  ///
  /// Defaults to true. Set to false if you want to manually control
  /// when the ad loads using the controller.
  final bool autoLoad;

  /// Visibility threshold for determining when ad is "visible".
  ///
  /// Value between 0.0 and 1.0. Default is 0.5 (50% visible).
  /// Used by smart reload to check if ad is visible before reloading.
  final double visibilityThreshold;

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  late NativeAdController _controller;
  bool _ownsController = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isVisible = false;

  /// Unique key for VisibilityDetector to avoid conflicts.
  late final Key _visibilityKey;

  @override
  void initState() {
    super.initState();
    _visibilityKey = UniqueKey();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = NativeAdController(
        options: widget.options,
        events: NativeAdEvents(
          onAdLoaded: _handleAdLoaded,
          onAdFailed: _handleAdFailed,
          onAdClicked: widget.onAdClicked,
          onAdImpression: widget.onAdImpression,
          onCachedAdReady: _handleCachedAdReady,
        ),
      );
      _ownsController = true;
    }

    // Set preloaded controller for cache-based reload
    if (widget.preloadedController != null) {
      _controller.setPreloadedAdController(widget.preloadedController);
    }

    // If controller is preloaded and loaded, skip loading state
    if (_controller.isPreloaded && _controller.isLoaded) {
      _isLoading = false;
      _hasError = false;
    }

    // Listen to state changes
    _controller.stateStream.listen((state) {
      if (!mounted) return;

      if (widget.options.enableDebugLogs) {
        debugPrint(
          '[NativeAdWidget] State changed: ${state.name}, '
          'isPreloaded: ${_controller.isPreloaded}, '
          'isLoaded: ${_controller.isLoaded}',
        );
      }

      setState(() {
        _isLoading = state == NativeAdState.loading;
        _hasError = state == NativeAdState.error;
        if (_hasError) {
          _errorMessage = _controller.errorMessage ?? 'Unknown error';
        }
      });
    });

    // Update events if using external controller
    if (!_ownsController) {
      _controller.updateEvents(NativeAdEvents(
        onAdLoaded: _handleAdLoaded,
        onAdFailed: _handleAdFailed,
        onAdClicked: widget.onAdClicked,
        onAdImpression: widget.onAdImpression,
        onCachedAdReady: _handleCachedAdReady,
      ));
    }

    // Auto load if enabled and not already loaded/preloaded
    if (widget.autoLoad && !_controller.isPreloaded && !_controller.isLoaded) {
      _controller.loadAd();
    }
  }

  void _handleAdLoaded() {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasError = false;
    });
    widget.onAdLoaded?.call();
  }

  void _handleAdFailed(String error, int errorCode) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _hasError = true;
      _errorMessage = error;
    });
    widget.onAdFailed?.call(error);
  }

  void _handleCachedAdReady() {
    if (!mounted) return;

    // Notify parent widget that cached ad is ready
    widget.onCachedAdReady?.call();

    if (widget.options.enableDebugLogs) {
      debugPrint('[NativeAdWidget] Cached ad ready, notifying parent');
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    final isNowVisible = info.visibleFraction >= widget.visibilityThreshold;

    if (_isVisible != isNowVisible) {
      _isVisible = isNowVisible;

      // Update controller visibility state for reload logic
      _controller.updateVisibility(isNowVisible);

      if (widget.options.enableDebugLogs) {
        debugPrint(
          '[NativeAdWidget] Visibility changed: $isNowVisible '
          '(${(info.visibleFraction * 100).toStringAsFixed(0)}%)',
        );
      }
    }
  }

  @override
  void didUpdateWidget(NativeAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update preloaded controller if changed
    if (oldWidget.preloadedController != widget.preloadedController) {
      _controller.setPreloadedAdController(widget.preloadedController);
    }

    // If options changed, reload the ad
    if (oldWidget.options != widget.options) {
      _controller.reload();
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? widget.options.layoutType.recommendedHeight;
    final width = widget.width;

    // Wrap in VisibilityDetector for smart reload visibility tracking
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _handleVisibilityChanged,
      child: SizedBox(
        height: height,
        width: width,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.options.enableDebugLogs) {
      debugPrint(
        '[NativeAdWidget] Building content: isLoading=$_isLoading, '
        'hasError=$_hasError, controllerState=${_controller.state.name}',
      );
    }

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState(_errorMessage);
    }

    return _buildPlatformView();
  }

  Widget _buildLoadingState() {
    if (widget.options.enableDebugLogs) {
      debugPrint('[NativeAdWidget] Building loading state (shimmer)');
    }

    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    // Use shimmer loading placeholder for smoother UX
    return ShimmerAdPlaceholder(
      layoutType: widget.options.layoutType,
    );
  }

  Widget _buildErrorState(String error) {
    if (widget.errorWidget != null) {
      return widget.errorWidget!(error);
    }

    return SizedBox.shrink();
  }

  Widget _buildPlatformView() {
    if (widget.options.enableDebugLogs) {
      debugPrint(
        '[NativeAdWidget] Building platform view: controllerId=${_controller.id}, '
        'isPreloaded=${_controller.isPreloaded}, isLoaded=${_controller.isLoaded}',
      );
    }

    final viewType = widget.options.layoutType.viewType;
    final creationParams = {
      'controllerId': _controller.id,
      'isPreloaded': _controller.isPreloaded,
      ...widget.options.toMap(),
    };

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
      );
    }

    return const Center(
      child: Text('Platform not supported'),
    );
  }

  void _onPlatformViewCreated(int id) {
    if (widget.options.enableDebugLogs) {
      debugPrint('[NativeAdWidget] Platform view created: $id');
    }
  }
}

/// A gesture recognizer that eagerly claims all pointer events.
///
/// This allows the native ad view to receive all touch events.
class EagerGestureRecognizer extends OneSequenceGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => 'eager';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {}
}
