/// Enum representing native ad layout types.
///
/// Supports 12 different layout forms based on design templates:
/// - [form1] to [form12]: Various native ad layouts with different styles
enum NativeAdLayoutType {
  /// Form1 - Compact horizontal: Icon + Title + Description + CTA (Right)
  /// Height: 80dp. Best for: List items, compact placements
  form1,

  /// Form2 - Compact horizontal: Large Media + Title + Description + CTA (Right)
  /// Height: 90dp. Best for: List items with media preview
  form2,

  /// Form3 - Vertical card: Title + Description + Large Media + CTA (Bottom)
  /// Height: 320dp. Best for: Feed cards, story-like layout
  form3,

  /// Form4 - Vertical card: Large Media + Icon + Title + Description + CTA (Bottom)
  /// Height: 300dp. Best for: Product cards, media-first layout
  form4,

  /// Form5 - Vertical card: Icon + Title + Description + Large Media + CTA (Bottom)
  /// Height: 300dp. Best for: Article cards
  form5,

  /// Form6 - Vertical card: Icon + Title + Description + Media + CTA (Bottom)
  /// Height: 280dp. Best for: Standard feed cards
  form6,

  /// Form7 - Horizontal card: Video/Media (Left) + Title + Description + CTA (Right)
  /// Height: 140dp. Best for: Video ads, horizontal scrolling
  form7,

  /// Form8 - Horizontal card: Media (Left) + Title + Description + CTA (Right)
  /// Height: 100dp. Best for: Compact horizontal cards
  form8,

  /// Form9 - Vertical card: CTA (Top) + Icon + Title + Description + Media
  /// Height: 280dp. Best for: Action-first layout
  form9,

  /// Form10 - Minimal vertical: Title + Description + CTA
  /// Height: 120dp. Best for: Text-only ads, minimal design
  form10,

  /// Form11 - Vertical card: Ad Label (Top) + Title + Media + CTA (Bottom)
  /// Height: 280dp. Best for: Clean vertical layout
  form11,

  /// Form12 - Vertical card: Ad Label (Top) + Title + Media + CTA (Bottom) - Alt style
  /// Height: 280dp. Best for: Alternative vertical layout
  form12;

  /// Converts the layout type to an integer for native communication.
  int toInt() {
    switch (this) {
      case NativeAdLayoutType.form1:
        return 1;
      case NativeAdLayoutType.form2:
        return 2;
      case NativeAdLayoutType.form3:
        return 3;
      case NativeAdLayoutType.form4:
        return 4;
      case NativeAdLayoutType.form5:
        return 5;
      case NativeAdLayoutType.form6:
        return 6;
      case NativeAdLayoutType.form7:
        return 7;
      case NativeAdLayoutType.form8:
        return 8;
      case NativeAdLayoutType.form9:
        return 9;
      case NativeAdLayoutType.form10:
        return 10;
      case NativeAdLayoutType.form11:
        return 11;
      case NativeAdLayoutType.form12:
        return 12;
    }
  }

  /// Creates a [NativeAdLayoutType] from an integer value.
  static NativeAdLayoutType fromInt(int value) {
    switch (value) {
      case 1:
        return NativeAdLayoutType.form1;
      case 2:
        return NativeAdLayoutType.form2;
      case 3:
        return NativeAdLayoutType.form3;
      case 4:
        return NativeAdLayoutType.form4;
      case 5:
        return NativeAdLayoutType.form5;
      case 6:
        return NativeAdLayoutType.form6;
      case 7:
        return NativeAdLayoutType.form7;
      case 8:
        return NativeAdLayoutType.form8;
      case 9:
        return NativeAdLayoutType.form9;
      case 10:
        return NativeAdLayoutType.form10;
      case 11:
        return NativeAdLayoutType.form11;
      case 12:
        return NativeAdLayoutType.form12;
      default:
        return NativeAdLayoutType.form1;
    }
  }

  /// Returns the recommended height for this layout type in logical pixels.
  double get recommendedHeight {
    switch (this) {
      case NativeAdLayoutType.form1:
        return 65;
      case NativeAdLayoutType.form2:
        return 90;
      case NativeAdLayoutType.form3:
        return 320;
      case NativeAdLayoutType.form4:
        return 300;
      case NativeAdLayoutType.form5:
        return 300;
      case NativeAdLayoutType.form6:
        return 280;
      case NativeAdLayoutType.form7:
        return 140;
      case NativeAdLayoutType.form8:
        return 100;
      case NativeAdLayoutType.form9:
        return 280;
      case NativeAdLayoutType.form10:
        return 120;
      case NativeAdLayoutType.form11:
        return 280;
      case NativeAdLayoutType.form12:
        return 280;
    }
  }

  /// Returns the view type identifier used for platform view registration.
  String get viewType => 'flutter_admob_native_ads_$name';
}
