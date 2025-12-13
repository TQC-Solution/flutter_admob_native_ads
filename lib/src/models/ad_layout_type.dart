/// Enum representing native ad layout types.
///
/// Currently only supports:
/// - [formExample]: Custom native ad layout with full control
enum NativeAdLayoutType {
  /// FormExample layout - Custom native ad with full styling control.
  /// Height: 300dp. Best for: All use cases with customizable presentation.
  formExample;

  /// Converts the layout type to an integer for native communication.
  int toInt() {
    return 1; // All layouts now use FormExample (value 1)
  }

  /// Creates a [NativeAdLayoutType] from an integer value.
  ///
  /// Returns [formExample] for all values.
  static NativeAdLayoutType fromInt(int value) {
    return NativeAdLayoutType.formExample;
  }

  /// Returns the recommended height for this layout type in logical pixels.
  double get recommendedHeight {
    return 300; // FormExample default height
  }

  /// Returns the view type identifier used for platform view registration.
  String get viewType => 'flutter_admob_native_ads_$name';
}
