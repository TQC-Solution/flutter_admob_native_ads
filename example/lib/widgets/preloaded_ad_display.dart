import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Widget for displaying preloaded ad
class PreloadedAdDisplay extends StatelessWidget {
  final NativeAdController controller;

  const PreloadedAdDisplay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preloaded Ad (Instant Display):',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        NativeAdWidget(
          key: const ValueKey('preloaded-ad'),
          options: controller.options,
          controller: controller,
          autoLoad: false, // Don't reload - use preloaded ad
          height: controller.options.layoutType.recommendedHeight,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
