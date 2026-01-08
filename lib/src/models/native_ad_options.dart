import 'ad_layout_type.dart';
import 'native_ad_style.dart';

/// Configuration options for a native ad.
///
/// This class contains all the settings needed to load and display
/// a native ad, including the ad unit ID, layout type, and styling.
///
/// Example:
/// ```dart
/// NativeAdOptions(
///   adUnitId: 'ca-app-pub-xxx/xxx',
///   layoutType: NativeAdLayoutType.form1,
///   style: NativeAdStyle.light(),
/// )
/// ```
class NativeAdOptions {
  /// Creates a [NativeAdOptions] instance.
  ///
  /// [adUnitId] is required and must be a valid AdMob ad unit ID.
  /// [layoutType] determines the visual layout of the ad.
  /// [style] provides styling customization for the ad components.
  NativeAdOptions({
    required this.adUnitId,
    this.layoutType = NativeAdLayoutType.form1,
    NativeAdStyle? style,
    this.enableDebugLogs = false,
    this.enableSmartPreload = false,
    this.enableSmartReload = false,
    this.reloadIntervalSeconds,
    this.retryDelaySeconds = 12,
    this.requestTimeout,
    this.customExtras,
    this.testDeviceIds,
  }) : style = style ?? NativeAdStyle();

  /// The AdMob ad unit ID.
  ///
  /// For testing, use Google's test ad unit IDs:
  /// - Android: `ca-app-pub-3940256099942544/2247696110`
  /// - iOS: `ca-app-pub-3940256099942544/3986624511`
  final String adUnitId;

  /// The layout type determining the visual structure of the ad.
  final NativeAdLayoutType layoutType;

  /// Styling options for the ad components.
  final NativeAdStyle style;

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
  /// Defaults to false for backward compatibility with existing code.
  /// Enable this to implement the intelligent preload flowchart from new_logic_preload.md.
  final bool enableSmartPreload;

  /// Enable intelligent reload logic with visibility-aware cache management.
  ///
  /// When enabled:
  /// - Reload only triggers when app is in foreground AND ad is visible
  /// - Checks for cached/preloaded ads before requesting new ones
  /// - If cache exists: show cached ad immediately, then preload next
  /// - If no cache: request new ad directly
  /// - On failure: retry after [retryDelaySeconds] delay
  /// - Supports remote config interval via [reloadIntervalSeconds]
  ///
  /// Defaults to false for backward compatibility.
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

  /// Optional timeout for ad requests.
  ///
  /// If null, the SDK default timeout is used.
  final Duration? requestTimeout;

  /// Custom extras to pass to the ad request.
  ///
  /// These are passed as key-value pairs to the native SDK.
  final Map<String, dynamic>? customExtras;

  /// List of test device IDs for testing ads.
  ///
  /// Ads on these devices will show test ads even in production.
  final List<String>? testDeviceIds;

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

  /// Converts this options instance to a Map for platform channel communication.
  Map<String, dynamic> toMap() {
    return {
      'adUnitId': adUnitId,
      'layoutType': layoutType.toInt(),
      'layoutTypeName': layoutType.name,
      'style': style.toMap(),
      'enableDebugLogs': enableDebugLogs,
      'enableSmartPreload': enableSmartPreload,
      'enableSmartReload': enableSmartReload,
      'reloadIntervalSeconds': reloadIntervalSeconds,
      'retryDelaySeconds': retryDelaySeconds,
      'requestTimeoutMs': requestTimeout?.inMilliseconds,
      'customExtras': customExtras,
      'testDeviceIds': testDeviceIds,
    };
  }

  /// Creates a copy of this options with the given fields replaced.
  NativeAdOptions copyWith({
    String? adUnitId,
    NativeAdLayoutType? layoutType,
    NativeAdStyle? style,
    bool? enableDebugLogs,
    bool? enableSmartPreload,
    bool? enableSmartReload,
    int? reloadIntervalSeconds,
    int? retryDelaySeconds,
    Duration? requestTimeout,
    Map<String, dynamic>? customExtras,
    List<String>? testDeviceIds,
  }) {
    return NativeAdOptions(
      adUnitId: adUnitId ?? this.adUnitId,
      layoutType: layoutType ?? this.layoutType,
      style: style ?? this.style,
      enableDebugLogs: enableDebugLogs ?? this.enableDebugLogs,
      enableSmartPreload: enableSmartPreload ?? this.enableSmartPreload,
      enableSmartReload: enableSmartReload ?? this.enableSmartReload,
      reloadIntervalSeconds:
          reloadIntervalSeconds ?? this.reloadIntervalSeconds,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      requestTimeout: requestTimeout ?? this.requestTimeout,
      customExtras: customExtras ?? this.customExtras,
      testDeviceIds: testDeviceIds ?? this.testDeviceIds,
    );
  }

  /// Creates options for Android test ads.
  factory NativeAdOptions.testAndroid({
    NativeAdLayoutType layoutType = NativeAdLayoutType.form1,
    NativeAdStyle? style,
  }) {
    return NativeAdOptions(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      layoutType: layoutType,
      style: style,
      enableDebugLogs: true,
    );
  }

  /// Creates options for iOS test ads.
  factory NativeAdOptions.testIOS({
    NativeAdLayoutType layoutType = NativeAdLayoutType.form1,
    NativeAdStyle? style,
  }) {
    return NativeAdOptions(
      adUnitId: 'ca-app-pub-3940256099942544/3986624511',
      layoutType: layoutType,
      style: style,
      enableDebugLogs: true,
    );
  }

  @override
  String toString() {
    return 'NativeAdOptions('
        'adUnitId: $adUnitId, '
        'layoutType: ${layoutType.name}, '
        'enableDebugLogs: $enableDebugLogs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NativeAdOptions &&
        other.adUnitId == adUnitId &&
        other.layoutType == layoutType &&
        other.style == style &&
        other.enableSmartPreload == enableSmartPreload &&
        other.enableSmartReload == enableSmartReload &&
        other.reloadIntervalSeconds == reloadIntervalSeconds;
  }

  @override
  int get hashCode =>
      adUnitId.hashCode ^
      layoutType.hashCode ^
      style.hashCode ^
      enableSmartPreload.hashCode ^
      enableSmartReload.hashCode ^
      reloadIntervalSeconds.hashCode;
}
