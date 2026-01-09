import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/banner_ad_size.dart';

/// Shimmer loading placeholder for banner ads.
///
/// Displays a skeleton loading animation while the banner ad is loading,
/// providing better UX than a blank space or simple indicator.
class BannerShimmerPlaceholder extends StatelessWidget {
  const BannerShimmerPlaceholder({
    super.key,
    required this.size,
    this.baseColor,
    this.highlightColor,
  });

  final BannerAdSize size;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final height = size.recommendedHeight;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBaseColor =
        baseColor ?? (isDark ? Colors.grey[700]! : Colors.grey[300]!);
    final effectiveHighlightColor =
        highlightColor ?? (isDark ? Colors.grey[500]! : Colors.grey[50]!);

    return Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      child: Container(
        height: height,
        color: Colors.white,
        child: _buildShimmerContent(),
      ),
    );
  }

  Widget _buildShimmerContent() {
    // Different shimmer layouts based on banner size
    switch (size) {
      case BannerAdSize.banner:
      case BannerAdSize.fullBanner:
      case BannerAdSize.leaderboard:
        return _buildHorizontalBannerShimmer();
      case BannerAdSize.mediumRectangle:
        return _buildMediumRectangleShimmer();
      case BannerAdSize.smartBanner:
      case BannerAdSize.adaptiveBanner:
      case BannerAdSize.inlineAdaptiveBanner:
        return _buildAdaptiveBannerShimmer();
    }
  }

  // Horizontal banner shimmer (standard banners)
  Widget _buildHorizontalBannerShimmer() {
    return Row(
      children: [
        // Ad indicator/icon placeholder
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(left: 8),
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        // Text content placeholder
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 14,
                width: 120,
                color: Colors.white,
              ),
              if (size == BannerAdSize.leaderboard) ...[
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        // CTA button placeholder
        Container(
          width: 70,
          height: 28,
          margin: const EdgeInsets.only(right: 8),
          color: Colors.white,
        ),
      ],
    );
  }

  // Medium rectangle shimmer (larger, more prominent)
  Widget _buildMediumRectangleShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.all(8),
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 16,
                width: 100,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Main content
        Container(
          height: 60,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        // Body text
        Container(
          height: 14,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
        ),
        const SizedBox(height: 4),
        Container(
          height: 14,
          width: 180,
          margin: const EdgeInsets.only(left: 8),
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        // CTA button
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 100,
            height: 36,
            margin: const EdgeInsets.only(right: 8),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Adaptive banner shimmer (responsive layout)
  Widget _buildAdaptiveBannerShimmer() {
    return Row(
      children: [
        // Ad indicator
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(left: 8),
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        // Flexible content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 14,
                width: 150,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 12,
                width: 100,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // CTA button
        Container(
          width: 70,
          height: 28,
          margin: const EdgeInsets.only(right: 8),
          color: Colors.white,
        ),
      ],
    );
  }
}
