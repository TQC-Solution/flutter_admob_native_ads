import 'dart:io';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Constants for AdMob Native Ads Demo App
class AdConstants {
  AdConstants._();

  // Test ad unit IDs from Google
  static String get testAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  // All available layout types
  static const List<NativeAdLayoutType> layouts = [
    NativeAdLayoutType.form1,
    NativeAdLayoutType.form2,
    NativeAdLayoutType.form3,
    NativeAdLayoutType.form4,
    NativeAdLayoutType.form5,
    NativeAdLayoutType.form6,
    NativeAdLayoutType.form7,
    NativeAdLayoutType.form8,
    NativeAdLayoutType.form9,
    NativeAdLayoutType.form10,
    NativeAdLayoutType.form11,
    NativeAdLayoutType.form12,
  ];

  // Default reload intervals in seconds
  static const List<int> reloadIntervals = [15, 30, 60];

  // Default CTA button color
  static const int defaultCtaColor = 0xFF0E4DD0;
}
