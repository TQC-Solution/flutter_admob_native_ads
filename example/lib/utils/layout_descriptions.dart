import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Utility class for layout descriptions
class LayoutDescriptions {
  LayoutDescriptions._();

  static String getDescription(NativeAdLayoutType layout) {
    switch (layout) {
      case NativeAdLayoutType.form1:
        return 'Compact horizontal: Icon + Title + CTA';
      case NativeAdLayoutType.form2:
        return 'Compact: Large Media + Title + CTA';
      case NativeAdLayoutType.form3:
        return 'Vertical: Title + Media + CTA';
      case NativeAdLayoutType.form4:
        return 'Vertical: Media + Icon + Title + CTA';
      case NativeAdLayoutType.form5:
        return 'Vertical: Icon + Title + Media + CTA';
      case NativeAdLayoutType.form6:
        return 'Card: Icon + Title + Media + CTA';
      case NativeAdLayoutType.form7:
        return 'Horizontal: Video/Media + Title + CTA';
      case NativeAdLayoutType.form8:
        return 'Compact horizontal: Media + Title + CTA';
      case NativeAdLayoutType.form9:
        return 'Vertical: CTA + Icon + Title + Media';
      case NativeAdLayoutType.form10:
        return 'Minimal: Title + Description + CTA';
      case NativeAdLayoutType.form11:
        return 'Vertical: Ad Label + Title + Media + CTA';
      case NativeAdLayoutType.form12:
        return 'Vertical: Ad Label + Title + Media + CTA (Alt)';
    }
  }
}
