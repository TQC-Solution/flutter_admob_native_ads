import 'package:flutter/widgets.dart';

import '../utils/color_extension.dart';
import '../utils/edge_insets_extension.dart';

/// Comprehensive styling configuration for native ads.
///
/// This class provides SwiftUI-style declarative styling options for
/// all components of a native ad including:
/// - CTA button styling
/// - Container/card styling
/// - Text styling for headlines, body, price, store, advertiser
/// - Media view styling
/// - Icon styling
/// - Star rating styling
/// - Layout spacing
///
/// Example:
/// ```dart
/// NativeAdStyle(
///   ctaBackgroundColor: Colors.blue,
///   ctaTextColor: Colors.white,
///   ctaCornerRadius: 8,
///   containerBackgroundColor: Colors.white,
///   headlineTextColor: Colors.black,
/// )
/// ```
class NativeAdStyle {
  /// Creates a custom [NativeAdStyle] with specified values.
  const NativeAdStyle({
    // CTA Button Styling
    this.ctaBackgroundColor = const Color(0xFF4285F4),
    this.ctaTextColor = const Color(0xFFFFFFFF),
    this.ctaFontSize = 14,
    this.ctaFontWeight = FontWeight.w600,
    this.ctaCornerRadius = 99,
    this.ctaPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.ctaBorderColor,
    this.ctaBorderWidth,
    this.ctaElevation,
    // Container Styling
    this.containerBackgroundColor = const Color(0xFFFFFFFF),
    this.containerCornerRadius = 8,
    this.containerPadding = const EdgeInsets.all(8),
    this.containerMargin = EdgeInsets.zero,
    this.containerBorderColor = const Color(0x63C1B5B5),
    this.containerBorderWidth = 1,
    this.containerShadowColor,
    this.containerShadowRadius,
    this.containerShadowOffset,
    // Headline Text Styling
    this.headlineTextColor = const Color(0xFF202124),
    this.headlineFontSize = 14,
    this.headlineFontWeight = FontWeight.w600,
    this.headlineFontFamily,
    this.headlineMaxLines = 2,
    // Body Text Styling
    this.bodyTextColor = const Color(0xFF5F6368),
    this.bodyFontSize = 10,
    this.bodyFontWeight = FontWeight.w400,
    this.bodyFontFamily,
    this.bodyMaxLines = 3,
    // Price Text Styling
    this.priceTextColor = const Color(0xFF34A853),
    this.priceFontSize = 12,
    // Store Text Styling
    this.storeTextColor = const Color(0xFF5F6368),
    this.storeFontSize = 12,
    // Advertiser Text Styling
    this.advertiserTextColor = const Color(0xFF9AA0A6),
    this.advertiserFontSize = 11,
    // Media View Styling
    this.mediaViewHeight = 180,
    this.mediaViewCornerRadius = 8,
    this.mediaViewAspectRatio,
    this.mediaViewBackgroundColor,
    // Icon Styling
    this.iconSize = 42,
    this.iconCornerRadius = 8,
    this.iconBorderColor,
    this.iconBorderWidth,
    // Star Rating Styling
    this.starRatingSize = 16,
    this.starRatingActiveColor = const Color(0xFFFBBC04),
    this.starRatingInactiveColor = const Color(0xFFDADCE0),
    // Layout Spacing
    this.itemSpacing = 8,
    this.sectionSpacing = 12,
    // Ad Label
    this.showAdLabel = true,
    this.adLabelText = 'Ad',
    this.adLabelBackgroundColor = const Color(0xFFFBBC04),
    this.adLabelTextColor = const Color(0xFFFFFFFF),
    this.adLabelFontSize = 10,
    this.adLabelCornerRadius = 4,
    this.adLabelPadding =
        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  });

  // ============== CTA Button Styling ==============

  /// Background color of the Call-to-Action button.
  final Color ctaBackgroundColor;

  /// Text color of the CTA button.
  final Color ctaTextColor;

  /// Font size of the CTA button text in logical pixels.
  final double ctaFontSize;

  /// Font weight of the CTA button text.
  final FontWeight ctaFontWeight;

  /// Corner radius of the CTA button.
  final double ctaCornerRadius;

  /// Padding inside the CTA button.
  final EdgeInsets ctaPadding;

  /// Border color of the CTA button. Null means no border.
  final Color? ctaBorderColor;

  /// Border width of the CTA button. Null means no border.
  final double? ctaBorderWidth;

  /// Elevation/shadow of the CTA button (Android only).
  final double? ctaElevation;

  // ============== Container Styling ==============

  /// Background color of the ad container.
  final Color containerBackgroundColor;

  /// Corner radius of the ad container.
  final double containerCornerRadius;

  /// Padding inside the ad container.
  final EdgeInsets containerPadding;

  /// Margin outside the ad container.
  final EdgeInsets containerMargin;

  /// Border color of the container. Null means no border.
  final Color? containerBorderColor;

  /// Border width of the container. Null means no border.
  final double? containerBorderWidth;

  /// Shadow color of the container.
  final Color? containerShadowColor;

  /// Shadow blur radius of the container.
  final double? containerShadowRadius;

  /// Shadow offset of the container.
  final Offset? containerShadowOffset;

  // ============== Headline Text Styling ==============

  /// Color of the headline text.
  final Color headlineTextColor;

  /// Font size of the headline text.
  final double headlineFontSize;

  /// Font weight of the headline text.
  final FontWeight headlineFontWeight;

  /// Font family of the headline text. Null uses system default.
  final String? headlineFontFamily;

  /// Maximum lines for headline text before truncation.
  final int headlineMaxLines;

  // ============== Body Text Styling ==============

  /// Color of the body text.
  final Color bodyTextColor;

  /// Font size of the body text.
  final double bodyFontSize;

  /// Font weight of the body text.
  final FontWeight bodyFontWeight;

  /// Font family of the body text. Null uses system default.
  final String? bodyFontFamily;

  /// Maximum lines for body text before truncation.
  final int bodyMaxLines;

  // ============== Price Text Styling ==============

  /// Color of the price text.
  final Color priceTextColor;

  /// Font size of the price text.
  final double priceFontSize;

  // ============== Store Text Styling ==============

  /// Color of the store text.
  final Color storeTextColor;

  /// Font size of the store text.
  final double storeFontSize;

  // ============== Advertiser Text Styling ==============

  /// Color of the advertiser text.
  final Color advertiserTextColor;

  /// Font size of the advertiser text.
  final double advertiserFontSize;

  // ============== Media View Styling ==============

  /// Height of the media view in logical pixels.
  final double mediaViewHeight;

  /// Corner radius of the media view.
  final double mediaViewCornerRadius;

  /// Aspect ratio of the media view. Null means flexible.
  final double? mediaViewAspectRatio;

  /// Background color of the media view placeholder.
  final Color? mediaViewBackgroundColor;

  // ============== Icon Styling ==============

  /// Size (width and height) of the app icon.
  final double iconSize;

  /// Corner radius of the app icon.
  final double iconCornerRadius;

  /// Border color of the icon. Null means no border.
  final Color? iconBorderColor;

  /// Border width of the icon. Null means no border.
  final double? iconBorderWidth;

  // ============== Star Rating Styling ==============

  /// Size of each star in the rating bar.
  final double starRatingSize;

  /// Color of filled stars.
  final Color starRatingActiveColor;

  /// Color of empty stars.
  final Color starRatingInactiveColor;

  // ============== Layout Spacing ==============

  /// Vertical spacing between elements within a section.
  final double itemSpacing;

  /// Spacing between major sections of the ad.
  final double sectionSpacing;

  // ============== Ad Label ==============

  /// Whether to show the "Ad" label.
  final bool showAdLabel;

  /// Text for the ad label.
  final String adLabelText;

  /// Background color of the ad label.
  final Color adLabelBackgroundColor;

  /// Text color of the ad label.
  final Color adLabelTextColor;

  /// Font size of the ad label text.
  final double adLabelFontSize;

  /// Corner radius of the ad label.
  final double adLabelCornerRadius;

  /// Padding inside the ad label.
  final EdgeInsets adLabelPadding;

  /// Creates a light theme style suitable for light backgrounds.
  factory NativeAdStyle.light() {
    return const NativeAdStyle(
      ctaBackgroundColor: Color(0xFF4285F4),
      ctaTextColor: Color(0xFFFFFFFF),
      containerBackgroundColor: Color(0xFFFFFFFF),
      containerShadowColor: Color(0x1A000000),
      containerShadowRadius: 8,
      containerShadowOffset: Offset(0, 2),
      headlineTextColor: Color(0xFF202124),
      bodyTextColor: Color(0xFF5F6368),
      priceTextColor: Color(0xFF34A853),
      storeTextColor: Color(0xFF5F6368),
      advertiserTextColor: Color(0xFF9AA0A6),
    );
  }

  /// Creates a dark theme style suitable for dark backgrounds.
  factory NativeAdStyle.dark() {
    return const NativeAdStyle(
      ctaBackgroundColor: Color(0xFF8AB4F8),
      ctaTextColor: Color(0xFF202124),
      containerBackgroundColor: Color(0xFF303134),
      containerShadowColor: Color(0x4D000000),
      containerShadowRadius: 8,
      containerShadowOffset: Offset(0, 2),
      headlineTextColor: Color(0xFFE8EAED),
      bodyTextColor: Color(0xFF9AA0A6),
      priceTextColor: Color(0xFF81C995),
      storeTextColor: Color(0xFF9AA0A6),
      advertiserTextColor: Color(0xFF5F6368),
      starRatingActiveColor: Color(0xFFFDD663),
      starRatingInactiveColor: Color(0xFF5F6368),
      adLabelBackgroundColor: Color(0xFFFDD663),
      adLabelTextColor: Color(0xFF202124),
    );
  }

  /// Creates a minimal style with reduced visual elements.
  factory NativeAdStyle.minimal() {
    return const NativeAdStyle(
      ctaBackgroundColor: Color(0xFF202124),
      ctaTextColor: Color(0xFFFFFFFF),
      ctaCornerRadius: 4,
      ctaElevation: 0,
      containerBackgroundColor: Color(0xFFF8F9FA),
      containerCornerRadius: 8,
      containerPadding: EdgeInsets.all(8),
      headlineFontSize: 14,
      bodyFontSize: 12,
      iconSize: 40,
      itemSpacing: 6,
      sectionSpacing: 8,
    );
  }

  /// Converts this style to a Map for platform channel communication.
  Map<String, dynamic> toMap() {
    return {
      // CTA Button
      'ctaBackgroundColor': ctaBackgroundColor.toHexWithAlpha(),
      'ctaTextColor': ctaTextColor.toHexWithAlpha(),
      'ctaFontSize': ctaFontSize,
      'ctaFontWeight': _fontWeightToInt(ctaFontWeight),
      'ctaCornerRadius': ctaCornerRadius,
      'ctaPadding': ctaPadding.toMap(),
      'ctaBorderColor': ctaBorderColor?.toHexWithAlpha(),
      'ctaBorderWidth': ctaBorderWidth,
      'ctaElevation': ctaElevation,
      // Container
      'containerBackgroundColor': containerBackgroundColor.toHexWithAlpha(),
      'containerCornerRadius': containerCornerRadius,
      'containerPadding': containerPadding.toMap(),
      'containerMargin': containerMargin.toMap(),
      'containerBorderColor': containerBorderColor?.toHexWithAlpha(),
      'containerBorderWidth': containerBorderWidth,
      'containerShadowColor': containerShadowColor?.toHexWithAlpha(),
      'containerShadowRadius': containerShadowRadius,
      'containerShadowOffsetX': containerShadowOffset?.dx,
      'containerShadowOffsetY': containerShadowOffset?.dy,
      // Headline
      'headlineTextColor': headlineTextColor.toHexWithAlpha(),
      'headlineFontSize': headlineFontSize,
      'headlineFontWeight': _fontWeightToInt(headlineFontWeight),
      'headlineFontFamily': headlineFontFamily,
      'headlineMaxLines': headlineMaxLines,
      // Body
      'bodyTextColor': bodyTextColor.toHexWithAlpha(),
      'bodyFontSize': bodyFontSize,
      'bodyFontWeight': _fontWeightToInt(bodyFontWeight),
      'bodyFontFamily': bodyFontFamily,
      'bodyMaxLines': bodyMaxLines,
      // Price
      'priceTextColor': priceTextColor.toHexWithAlpha(),
      'priceFontSize': priceFontSize,
      // Store
      'storeTextColor': storeTextColor.toHexWithAlpha(),
      'storeFontSize': storeFontSize,
      // Advertiser
      'advertiserTextColor': advertiserTextColor.toHexWithAlpha(),
      'advertiserFontSize': advertiserFontSize,
      // Media View
      'mediaViewHeight': mediaViewHeight,
      'mediaViewCornerRadius': mediaViewCornerRadius,
      'mediaViewAspectRatio': mediaViewAspectRatio,
      'mediaViewBackgroundColor': mediaViewBackgroundColor?.toHexWithAlpha(),
      // Icon
      'iconSize': iconSize,
      'iconCornerRadius': iconCornerRadius,
      'iconBorderColor': iconBorderColor?.toHexWithAlpha(),
      'iconBorderWidth': iconBorderWidth,
      // Star Rating
      'starRatingSize': starRatingSize,
      'starRatingActiveColor': starRatingActiveColor.toHexWithAlpha(),
      'starRatingInactiveColor': starRatingInactiveColor.toHexWithAlpha(),
      // Layout Spacing
      'itemSpacing': itemSpacing,
      'sectionSpacing': sectionSpacing,
      // Ad Label
      'showAdLabel': showAdLabel,
      'adLabelText': adLabelText,
      'adLabelBackgroundColor': adLabelBackgroundColor.toHexWithAlpha(),
      'adLabelTextColor': adLabelTextColor.toHexWithAlpha(),
      'adLabelFontSize': adLabelFontSize,
      'adLabelCornerRadius': adLabelCornerRadius,
      'adLabelPadding': adLabelPadding.toMap(),
    };
  }

  /// Converts FontWeight to integer (100-900).
  static int _fontWeightToInt(FontWeight weight) {
    return weight.value;
  }

  /// Creates a copy of this style with the given fields replaced.
  NativeAdStyle copyWith({
    // CTA Button
    Color? ctaBackgroundColor,
    Color? ctaTextColor,
    double? ctaFontSize,
    FontWeight? ctaFontWeight,
    double? ctaCornerRadius,
    EdgeInsets? ctaPadding,
    Color? ctaBorderColor,
    double? ctaBorderWidth,
    double? ctaElevation,
    // Container
    Color? containerBackgroundColor,
    double? containerCornerRadius,
    EdgeInsets? containerPadding,
    EdgeInsets? containerMargin,
    Color? containerBorderColor,
    double? containerBorderWidth,
    Color? containerShadowColor,
    double? containerShadowRadius,
    Offset? containerShadowOffset,
    // Headline
    Color? headlineTextColor,
    double? headlineFontSize,
    FontWeight? headlineFontWeight,
    String? headlineFontFamily,
    int? headlineMaxLines,
    // Body
    Color? bodyTextColor,
    double? bodyFontSize,
    FontWeight? bodyFontWeight,
    String? bodyFontFamily,
    int? bodyMaxLines,
    // Price
    Color? priceTextColor,
    double? priceFontSize,
    // Store
    Color? storeTextColor,
    double? storeFontSize,
    // Advertiser
    Color? advertiserTextColor,
    double? advertiserFontSize,
    // Media View
    double? mediaViewHeight,
    double? mediaViewCornerRadius,
    double? mediaViewAspectRatio,
    Color? mediaViewBackgroundColor,
    // Icon
    double? iconSize,
    double? iconCornerRadius,
    Color? iconBorderColor,
    double? iconBorderWidth,
    // Star Rating
    double? starRatingSize,
    Color? starRatingActiveColor,
    Color? starRatingInactiveColor,
    // Layout Spacing
    double? itemSpacing,
    double? sectionSpacing,
    // Ad Label
    bool? showAdLabel,
    String? adLabelText,
    Color? adLabelBackgroundColor,
    Color? adLabelTextColor,
    double? adLabelFontSize,
    double? adLabelCornerRadius,
    EdgeInsets? adLabelPadding,
  }) {
    return NativeAdStyle(
      // CTA Button
      ctaBackgroundColor: ctaBackgroundColor ?? this.ctaBackgroundColor,
      ctaTextColor: ctaTextColor ?? this.ctaTextColor,
      ctaFontSize: ctaFontSize ?? this.ctaFontSize,
      ctaFontWeight: ctaFontWeight ?? this.ctaFontWeight,
      ctaCornerRadius: ctaCornerRadius ?? this.ctaCornerRadius,
      ctaPadding: ctaPadding ?? this.ctaPadding,
      ctaBorderColor: ctaBorderColor ?? this.ctaBorderColor,
      ctaBorderWidth: ctaBorderWidth ?? this.ctaBorderWidth,
      ctaElevation: ctaElevation ?? this.ctaElevation,
      // Container
      containerBackgroundColor:
          containerBackgroundColor ?? this.containerBackgroundColor,
      containerCornerRadius:
          containerCornerRadius ?? this.containerCornerRadius,
      containerPadding: containerPadding ?? this.containerPadding,
      containerMargin: containerMargin ?? this.containerMargin,
      containerBorderColor: containerBorderColor ?? this.containerBorderColor,
      containerBorderWidth: containerBorderWidth ?? this.containerBorderWidth,
      containerShadowColor: containerShadowColor ?? this.containerShadowColor,
      containerShadowRadius:
          containerShadowRadius ?? this.containerShadowRadius,
      containerShadowOffset:
          containerShadowOffset ?? this.containerShadowOffset,
      // Headline
      headlineTextColor: headlineTextColor ?? this.headlineTextColor,
      headlineFontSize: headlineFontSize ?? this.headlineFontSize,
      headlineFontWeight: headlineFontWeight ?? this.headlineFontWeight,
      headlineFontFamily: headlineFontFamily ?? this.headlineFontFamily,
      headlineMaxLines: headlineMaxLines ?? this.headlineMaxLines,
      // Body
      bodyTextColor: bodyTextColor ?? this.bodyTextColor,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      bodyFontWeight: bodyFontWeight ?? this.bodyFontWeight,
      bodyFontFamily: bodyFontFamily ?? this.bodyFontFamily,
      bodyMaxLines: bodyMaxLines ?? this.bodyMaxLines,
      // Price
      priceTextColor: priceTextColor ?? this.priceTextColor,
      priceFontSize: priceFontSize ?? this.priceFontSize,
      // Store
      storeTextColor: storeTextColor ?? this.storeTextColor,
      storeFontSize: storeFontSize ?? this.storeFontSize,
      // Advertiser
      advertiserTextColor: advertiserTextColor ?? this.advertiserTextColor,
      advertiserFontSize: advertiserFontSize ?? this.advertiserFontSize,
      // Media View
      mediaViewHeight: mediaViewHeight ?? this.mediaViewHeight,
      mediaViewCornerRadius:
          mediaViewCornerRadius ?? this.mediaViewCornerRadius,
      mediaViewAspectRatio: mediaViewAspectRatio ?? this.mediaViewAspectRatio,
      mediaViewBackgroundColor:
          mediaViewBackgroundColor ?? this.mediaViewBackgroundColor,
      // Icon
      iconSize: iconSize ?? this.iconSize,
      iconCornerRadius: iconCornerRadius ?? this.iconCornerRadius,
      iconBorderColor: iconBorderColor ?? this.iconBorderColor,
      iconBorderWidth: iconBorderWidth ?? this.iconBorderWidth,
      // Star Rating
      starRatingSize: starRatingSize ?? this.starRatingSize,
      starRatingActiveColor:
          starRatingActiveColor ?? this.starRatingActiveColor,
      starRatingInactiveColor:
          starRatingInactiveColor ?? this.starRatingInactiveColor,
      // Layout Spacing
      itemSpacing: itemSpacing ?? this.itemSpacing,
      sectionSpacing: sectionSpacing ?? this.sectionSpacing,
      // Ad Label
      showAdLabel: showAdLabel ?? this.showAdLabel,
      adLabelText: adLabelText ?? this.adLabelText,
      adLabelBackgroundColor:
          adLabelBackgroundColor ?? this.adLabelBackgroundColor,
      adLabelTextColor: adLabelTextColor ?? this.adLabelTextColor,
      adLabelFontSize: adLabelFontSize ?? this.adLabelFontSize,
      adLabelCornerRadius: adLabelCornerRadius ?? this.adLabelCornerRadius,
      adLabelPadding: adLabelPadding ?? this.adLabelPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NativeAdStyle &&
        other.ctaBackgroundColor == ctaBackgroundColor &&
        other.ctaTextColor == ctaTextColor &&
        other.containerBackgroundColor == containerBackgroundColor;
  }

  @override
  int get hashCode =>
      ctaBackgroundColor.hashCode ^
      ctaTextColor.hashCode ^
      containerBackgroundColor.hashCode;
}
