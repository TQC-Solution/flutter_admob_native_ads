import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Widget for displaying regular ads with error handling
class AdDisplaySection extends StatelessWidget {
  final String adUnitId;
  final NativeAdLayoutType layoutType;
  final bool isDarkTheme;
  final bool enableDebugLogs;

  const AdDisplaySection({
    super.key,
    required this.adUnitId,
    required this.layoutType,
    required this.isDarkTheme,
    this.enableDebugLogs = true,
  });

  @override
  Widget build(BuildContext context) {
    const hexColor = '0E4DD0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Regular Ad (Auto-Load):',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        NativeAdWidget(
          key: ValueKey('${layoutType.name}-$isDarkTheme'),
          options: NativeAdOptions(
            adUnitId: adUnitId,
            layoutType: layoutType,
            style: NativeAdStyle(
              ctaBackgroundColor: Color(int.parse('0xFF$hexColor')),
            ),
            enableDebugLogs: enableDebugLogs,
          ),
          height: layoutType.recommendedHeight,
          onAdLoaded: () {
            debugPrint('Ad loaded successfully!');
          },
          onAdFailed: (error) {
            debugPrint('Ad failed to load: $error');
          },
          onAdClicked: () {
            debugPrint('Ad clicked!');
          },
          errorWidget: (error) => Container(
            decoration: BoxDecoration(
              color: isDarkTheme ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: isDarkTheme ? Colors.white54 : Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ad not available',
                    style: TextStyle(
                      color: isDarkTheme ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
