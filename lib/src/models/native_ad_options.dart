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
///   layoutType: NativeAdLayoutType.formExample,
///   style: NativeAdStyle.light(),
/// )
/// ```
class NativeAdOptions {
  /// Creates a [NativeAdOptions] instance.
  ///
  /// [adUnitId] is required and must be a valid AdMob ad unit ID.
  /// [layoutType] determines the visual layout of the ad.
  /// [style] provides styling customization for the ad components.
  const NativeAdOptions({
    required this.adUnitId,
    this.layoutType = NativeAdLayoutType.formExample,
    this.style = const NativeAdStyle(),
    this.enableDebugLogs = false,
    this.requestTimeout,
    this.customExtras,
    this.testDeviceIds,
  });

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
    Duration? requestTimeout,
    Map<String, dynamic>? customExtras,
    List<String>? testDeviceIds,
  }) {
    return NativeAdOptions(
      adUnitId: adUnitId ?? this.adUnitId,
      layoutType: layoutType ?? this.layoutType,
      style: style ?? this.style,
      enableDebugLogs: enableDebugLogs ?? this.enableDebugLogs,
      requestTimeout: requestTimeout ?? this.requestTimeout,
      customExtras: customExtras ?? this.customExtras,
      testDeviceIds: testDeviceIds ?? this.testDeviceIds,
    );
  }

  /// Creates options for Android test ads.
  factory NativeAdOptions.testAndroid({
    NativeAdLayoutType layoutType = NativeAdLayoutType.formExample,
    NativeAdStyle style = const NativeAdStyle(),
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
    NativeAdLayoutType layoutType = NativeAdLayoutType.formExample,
    NativeAdStyle style = const NativeAdStyle(),
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
        other.style == style;
  }

  @override
  int get hashCode => adUnitId.hashCode ^ layoutType.hashCode ^ style.hashCode;
}
