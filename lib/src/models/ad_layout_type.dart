/// Enum representing different native ad layout types.
///
/// Each layout type corresponds to a different visual presentation:
/// - [compact]: Minimal layout, ideal for lists (120-150dp height)
/// - [standard]: Balanced layout with media view (250-300dp height)
/// - [fullMedia]: Rich media-focused layout (350-400dp height)
enum NativeAdLayoutType {
  /// Compact layout - horizontal icon + text + CTA button.
  /// Height: 120-150dp. Best for: Feed integration, minimal footprint.
  compact,

  /// Standard layout - icon header, media view, body text, CTA.
  /// Height: 250-300dp. Best for: Most use cases, balanced presentation.
  standard,

  /// Full media layout - large media view, prominent CTA.
  /// Height: 350-400dp. Best for: Premium placements, high engagement.
  fullMedia;

  /// Converts the layout type to an integer for native communication.
  int toInt() {
    switch (this) {
      case NativeAdLayoutType.compact:
        return 1;
      case NativeAdLayoutType.standard:
        return 2;
      case NativeAdLayoutType.fullMedia:
        return 3;
    }
  }

  /// Creates a [NativeAdLayoutType] from an integer value.
  ///
  /// Returns [standard] as default for unknown values.
  static NativeAdLayoutType fromInt(int value) {
    switch (value) {
      case 1:
        return NativeAdLayoutType.compact;
      case 2:
        return NativeAdLayoutType.standard;
      case 3:
        return NativeAdLayoutType.fullMedia;
      default:
        return NativeAdLayoutType.standard;
    }
  }

  /// Returns the recommended height for this layout type in logical pixels.
  double get recommendedHeight {
    switch (this) {
      case NativeAdLayoutType.compact:
        return 135;
      case NativeAdLayoutType.standard:
        return 275;
      case NativeAdLayoutType.fullMedia:
        return 375;
    }
  }

  /// Returns the view type identifier used for platform view registration.
  String get viewType => 'flutter_admob_native_ads_$name';
}
