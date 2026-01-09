import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/banner_ad_controller.dart';
import '../models/banner_ad_events.dart';
import '../models/banner_ad_options.dart';
import '../widgets/native_ad_widget.dart' show AdGestureRecognizer;
import '../widgets/banner_shimmer_placeholder.dart';

/// A widget that displays a banner ad.
///
/// This widget wraps the native platform view and handles:
/// - Ad loading and lifecycle
/// - Loading and error states
/// - Platform-specific rendering
///
/// Example:
/// ```dart
/// BannerAdWidget(
///   options: BannerAdOptions(
///     adUnitId: 'ca-app-pub-xxx/xxx',
///     size: BannerAdSize.adaptiveBanner,
///   ),
///   onAdLoaded: () => print('Ad loaded'),
///   onAdFailed: (error) => print('Ad failed: $error'),
/// )
/// ```
class BannerAdWidget extends StatefulWidget {
  /// Creates a [BannerAdWidget].
  ///
  /// [options] is required and contains the ad configuration.
  /// [height] is optional; if not provided, uses the recommended height
  /// for the banner size.
  const BannerAdWidget({
    super.key,
    required this.options,
    this.controller,
    this.height,
    this.width,
    this.loadingWidget,
    this.errorWidget,
    this.onAdLoaded,
    this.onAdFailed,
    this.onAdClicked,
    this.onAdImpression,
    this.onAdPaid,
    this.autoLoad = true,
    this.visibilityThreshold = 0.5,
  });

  /// Configuration options for the ad.
  final BannerAdOptions options;

  /// Optional external controller for managing the ad.
  ///
  /// If not provided, an internal controller will be created.
  final BannerAdController? controller;

  /// Height of the ad widget.
  ///
  /// If not specified, uses the recommended height for the banner size.
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

  /// Callback when a paid event is recorded.
  final void Function(double value, String currency)? onAdPaid;

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
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAdController _controller;
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
      _controller = BannerAdController(
        options: widget.options,
        events: BannerAdEvents(
          onAdLoaded: _handleAdLoaded,
          onAdFailed: _handleAdFailed,
          onAdClicked: widget.onAdClicked,
          onAdImpression: widget.onAdImpression,
          onAdPaid: widget.onAdPaid,
        ),
      );
      _ownsController = true;
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
          '[BannerAdWidget] State changed: ${state.name}, '
          'isPreloaded: ${_controller.isPreloaded}, '
          'isLoaded: ${_controller.isLoaded}',
        );
      }

      setState(() {
        _isLoading = state == BannerAdState.loading;
        _hasError = state == BannerAdState.error;
        if (_hasError) {
          _errorMessage = _controller.errorMessage ?? 'Unknown error';
        }
      });
    });

    // Update events if using external controller
    if (!_ownsController) {
      _controller.updateEvents(BannerAdEvents(
        onAdLoaded: _handleAdLoaded,
        onAdFailed: _handleAdFailed,
        onAdClicked: widget.onAdClicked,
        onAdImpression: widget.onAdImpression,
        onAdPaid: widget.onAdPaid,
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

  void _handleVisibilityChanged(VisibilityInfo info) {
    final isNowVisible = info.visibleFraction >= widget.visibilityThreshold;

    if (_isVisible != isNowVisible) {
      _isVisible = isNowVisible;

      // Update controller visibility state for reload logic
      _controller.updateVisibility(isNowVisible);

      if (widget.options.enableDebugLogs) {
        debugPrint(
          '[BannerAdWidget] Visibility changed: $isNowVisible '
          '(${(info.visibleFraction * 100).toStringAsFixed(0)}%)',
        );
      }
    }
  }

  @override
  void didUpdateWidget(BannerAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

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
    final height = widget.height ?? widget.options.size.recommendedHeight;
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
        '[BannerAdWidget] Building content: isLoading=$_isLoading, '
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
      debugPrint('[BannerAdWidget] Building loading state (shimmer)');
    }

    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    // Use shimmer loading placeholder for smoother UX (same as native ads)
    return BannerShimmerPlaceholder(
      size: widget.options.size,
    );
  }

  Widget _buildErrorState(String error) {
    if (widget.errorWidget != null) {
      return widget.errorWidget!(error);
    }

    // Default error state - empty container
    return SizedBox.shrink();
  }

  Widget _buildPlatformView() {
    if (widget.options.enableDebugLogs) {
      debugPrint(
        '[BannerAdWidget] Building platform view: controllerId=${_controller.id}, '
        'isPreloaded=${_controller.isPreloaded}, isLoaded=${_controller.isLoaded}',
      );
    }

    final viewType = widget.options.size.viewType;
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
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => AdGestureRecognizer(),
          ),
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => AdGestureRecognizer(),
          ),
        },
      );
    }

    return const Center(
      child: Text('Platform not supported'),
    );
  }
}

