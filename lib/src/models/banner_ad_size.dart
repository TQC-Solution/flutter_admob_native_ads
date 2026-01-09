/// Enum representing all AdMob banner ad sizes.
enum BannerAdSize {
  /// Standard banner: 320x50
  banner,

  /// Full banner: 468x60
  fullBanner,

  /// Leaderboard: 728x90
  leaderboard,

  /// Medium rectangle: 300x250
  mediumRectangle,

  /// Smart banner - adapts to screen width (deprecated by Google, use adaptive)
  smartBanner,

  /// Adaptive banner - anchors to screen width with configurable height
  adaptiveBanner,

  /// Inline adaptive banner - can height-adjust based on content
  inlineAdaptiveBanner;

  /// Returns the width in pixels for this banner size.
  int get width {
    switch (this) {
      case BannerAdSize.banner:
        return 320;
      case BannerAdSize.fullBanner:
        return 468;
      case BannerAdSize.leaderboard:
        return 728;
      case BannerAdSize.mediumRectangle:
        return 300;
      case BannerAdSize.smartBanner:
      case BannerAdSize.adaptiveBanner:
      case BannerAdSize.inlineAdaptiveBanner:
        return -1; // Determined at runtime
    }
  }

  /// Returns the height in pixels for this banner size.
  int get height {
    switch (this) {
      case BannerAdSize.banner:
        return 50;
      case BannerAdSize.fullBanner:
        return 60;
      case BannerAdSize.leaderboard:
        return 90;
      case BannerAdSize.mediumRectangle:
        return 250;
      case BannerAdSize.smartBanner:
      case BannerAdSize.adaptiveBanner:
      case BannerAdSize.inlineAdaptiveBanner:
        return -1; // Determined at runtime
    }
  }

  /// Converts to int for method channel communication.
  int toInt() => index;

  /// Creates from int for method channel communication.
  static BannerAdSize fromInt(int value) {
    return values[value >= 0 && value < values.length ? value : 0];
  }

  /// String identifier for platform view type.
  /// All banner sizes use the same view type; size is passed via options.
  String get viewType => 'flutter_admob_banner_ads';

  /// Recommended height for Flutter widget (in dp).
  double get recommendedHeight {
    switch (this) {
      case BannerAdSize.banner:
        return 50.0;
      case BannerAdSize.fullBanner:
        return 60.0;
      case BannerAdSize.leaderboard:
        return 90.0;
      case BannerAdSize.mediumRectangle:
        return 250.0;
      case BannerAdSize.smartBanner:
      case BannerAdSize.adaptiveBanner:
        return 50.0; // Will be adjusted by platform
      case BannerAdSize.inlineAdaptiveBanner:
        return 50.0; // Will be adjusted by platform
    }
  }
}
