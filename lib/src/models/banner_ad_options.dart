import 'banner_ad_size.dart';

/// Configuration options for banner ads.
class BannerAdOptions {
  /// Creates a [BannerAdOptions] instance.
  const BannerAdOptions({
    required this.adUnitId,
    this.size = BannerAdSize.adaptiveBanner,
    this.enableDebugLogs = false,
    this.enableSmartPreload = false,
    this.enableSmartReload = false,
    this.reloadIntervalSeconds,
    this.retryDelaySeconds = 12,
    this.adaptiveBannerHeight,
  });

  /// The AdMob ad unit ID.
  ///
  /// For testing, use Google's test ad unit IDs:
  /// - Android: `ca-app-pub-3940256099942544/6300978111`
  /// - iOS: `ca-app-pub-3940256099942544/2934735716`
  final String adUnitId;

  /// The banner size to display.
  final BannerAdSize size;

  /// Whether to enable debug logging from the native side.
  final bool enableDebugLogs;

  /// Enable intelligent preload logic with retry, backoff, and awareness checks.
  ///
  /// When enabled:
  /// - Ads only load when app is in foreground with internet connection
  /// - Automatic retry with exponential backoff (10s → 20s → 40s)
  /// - 90-second cooldown after ad impression
  /// - Maximum 3 retry attempts before stopping
  /// - Retry counter resets when network connectivity is restored
  ///
  /// Defaults to false.
  final bool enableSmartPreload;

  /// Enable intelligent reload logic with visibility-aware management.
  ///
  /// When enabled:
  /// - Reload only triggers when app is in foreground AND ad is visible
  /// - On failure: retry after [retryDelaySeconds] delay
  /// - Supports remote config interval via [reloadIntervalSeconds]
  ///
  /// Defaults to false.
  final bool enableSmartReload;

  /// Remote config interval in seconds for automatic reloads.
  ///
  /// If set, the ad will automatically reload at this interval
  /// (only when visibility check passes).
  /// Set to null to disable automatic reload timer.
  final int? reloadIntervalSeconds;

  /// Delay in seconds before retry on reload failure.
  ///
  /// Recommended range is 10-15 seconds. Defaults to 12 seconds.
  final int retryDelaySeconds;

  /// Custom height for adaptive banners (in DP).
  ///
  /// If null, uses SDK default height calculation.
  final int? adaptiveBannerHeight;

  /// Converts this options instance to a Map for platform channel communication.
  Map<String, dynamic> toMap() {
    return {
      'adUnitId': adUnitId,
      'size': size.toInt(),
      'sizeName': size.name,
      'enableDebugLogs': enableDebugLogs,
      'enableSmartPreload': enableSmartPreload,
      'enableSmartReload': enableSmartReload,
      'reloadIntervalSeconds': reloadIntervalSeconds,
      'retryDelaySeconds': retryDelaySeconds,
      'adaptiveBannerHeight': adaptiveBannerHeight,
    };
  }

  /// Creates a copy of this options with the given fields replaced.
  BannerAdOptions copyWith({
    String? adUnitId,
    BannerAdSize? size,
    bool? enableDebugLogs,
    bool? enableSmartPreload,
    bool? enableSmartReload,
    int? reloadIntervalSeconds,
    int? retryDelaySeconds,
    int? adaptiveBannerHeight,
  }) {
    return BannerAdOptions(
      adUnitId: adUnitId ?? this.adUnitId,
      size: size ?? this.size,
      enableDebugLogs: enableDebugLogs ?? this.enableDebugLogs,
      enableSmartPreload: enableSmartPreload ?? this.enableSmartPreload,
      enableSmartReload: enableSmartReload ?? this.enableSmartReload,
      reloadIntervalSeconds:
          reloadIntervalSeconds ?? this.reloadIntervalSeconds,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      adaptiveBannerHeight: adaptiveBannerHeight ?? this.adaptiveBannerHeight,
    );
  }

  /// Creates options for Android test ads.
  factory BannerAdOptions.testAndroid({
    BannerAdSize size = BannerAdSize.adaptiveBanner,
  }) {
    return BannerAdOptions(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: size,
      enableDebugLogs: true,
    );
  }

  /// Creates options for iOS test ads.
  factory BannerAdOptions.testIOS({
    BannerAdSize size = BannerAdSize.adaptiveBanner,
  }) {
    return BannerAdOptions(
      adUnitId: 'ca-app-pub-3940256099942544/2934735716',
      size: size,
      enableDebugLogs: true,
    );
  }

  /// Validates the ad unit ID format.
  ///
  /// Returns true if the ad unit ID appears to be valid.
  bool get isValidAdUnitId {
    // Basic validation: should start with 'ca-app-pub-' and contain '/'
    if (adUnitId.isEmpty) return false;
    if (adUnitId.startsWith('ca-app-pub-') && adUnitId.contains('/')) {
      return true;
    }
    // Allow test ad unit IDs and custom formats
    return adUnitId.length > 10;
  }

  @override
  String toString() {
    return 'BannerAdOptions('
        'adUnitId: $adUnitId, '
        'size: ${size.name}, '
        'enableDebugLogs: $enableDebugLogs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BannerAdOptions &&
        other.adUnitId == adUnitId &&
        other.size == size &&
        other.enableSmartPreload == enableSmartPreload &&
        other.enableSmartReload == enableSmartReload &&
        other.reloadIntervalSeconds == reloadIntervalSeconds;
  }

  @override
  int get hashCode =>
      adUnitId.hashCode ^
      size.hashCode ^
      enableSmartPreload.hashCode ^
      enableSmartReload.hashCode ^
      reloadIntervalSeconds.hashCode;
}
