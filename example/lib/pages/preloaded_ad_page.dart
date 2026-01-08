import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Full-screen page displaying a preloaded ad
class PreloadedAdPage extends StatelessWidget {
  final NativeAdController preloadedController;

  const PreloadedAdPage({super.key, required this.preloadedController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preloaded Ad')),
      body: Center(
        child: NativeAdWidget(
          key: const ValueKey('preloaded-ad'),
          options: preloadedController.options,
          controller: preloadedController,
          autoLoad: false, // Don't reload - use preloaded ad
          height: preloadedController.options.layoutType.recommendedHeight,
        ),
      ),
    );
  }
}
