import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

void main() {
  group('NativeAdLayoutType', () {
    test('toInt returns correct value', () {
      expect(NativeAdLayoutType.formExample.toInt(), 1);
    });

    test('fromInt returns formExample for all values', () {
      expect(NativeAdLayoutType.fromInt(1), NativeAdLayoutType.formExample);
      expect(NativeAdLayoutType.fromInt(2), NativeAdLayoutType.formExample);
      expect(NativeAdLayoutType.fromInt(99), NativeAdLayoutType.formExample);
    });

    test('recommendedHeight returns expected value', () {
      expect(NativeAdLayoutType.formExample.recommendedHeight, 300);
    });

    test('viewType returns correct identifier', () {
      expect(
        NativeAdLayoutType.formExample.viewType,
        'flutter_admob_native_ads_formExample',
      );
    });
  });

  group('NativeAdOptions', () {
    test('creates with required parameters', () {
      const options = NativeAdOptions(
        adUnitId: 'ca-app-pub-xxx/xxx',
      );

      expect(options.adUnitId, 'ca-app-pub-xxx/xxx');
      expect(options.layoutType, NativeAdLayoutType.formExample);
      expect(options.enableDebugLogs, false);
    });

    test('validates ad unit ID format', () {
      const validOptions = NativeAdOptions(
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      );
      expect(validOptions.isValidAdUnitId, true);

      const invalidOptions = NativeAdOptions(
        adUnitId: '',
      );
      expect(invalidOptions.isValidAdUnitId, false);
    });

    test('toMap returns correct structure', () {
      const options = NativeAdOptions(
        adUnitId: 'test-ad-unit',
        layoutType: NativeAdLayoutType.formExample,
        enableDebugLogs: true,
      );

      final map = options.toMap();

      expect(map['adUnitId'], 'test-ad-unit');
      expect(map['layoutType'], 1);
      expect(map['layoutTypeName'], 'formExample');
      expect(map['enableDebugLogs'], true);
      expect(map['style'], isA<Map>());
    });

    test('copyWith creates new instance with updated values', () {
      const options = NativeAdOptions(
        adUnitId: 'original-ad-unit',
        layoutType: NativeAdLayoutType.formExample,
      );

      final copied = options.copyWith(
        enableDebugLogs: true,
      );

      expect(copied.adUnitId, 'original-ad-unit');
      expect(copied.layoutType, NativeAdLayoutType.formExample);
      expect(copied.enableDebugLogs, true);
    });

    test('testAndroid factory creates test options', () {
      final options = NativeAdOptions.testAndroid();

      expect(options.adUnitId, 'ca-app-pub-3940256099942544/2247696110');
      expect(options.enableDebugLogs, true);
    });

    test('testIOS factory creates test options', () {
      final options = NativeAdOptions.testIOS();

      expect(options.adUnitId, 'ca-app-pub-3940256099942544/3986624511');
      expect(options.enableDebugLogs, true);
    });
  });

  group('NativeAdStyle', () {
    test('default constructor has expected default values', () {
      const style = NativeAdStyle();

      expect(style.ctaCornerRadius, 8);
      expect(style.containerCornerRadius, 12);
      expect(style.headlineFontSize, 16);
      expect(style.bodyFontSize, 14);
      expect(style.iconSize, 48);
      expect(style.showAdLabel, true);
      expect(style.adLabelText, 'Ad');
    });

    test('light factory creates light theme style', () {
      final style = NativeAdStyle.light();

      expect(style.containerBackgroundColor, const Color(0xFFFFFFFF));
      expect(style.headlineTextColor, const Color(0xFF202124));
    });

    test('dark factory creates dark theme style', () {
      final style = NativeAdStyle.dark();

      expect(style.containerBackgroundColor, const Color(0xFF303134));
      expect(style.headlineTextColor, const Color(0xFFE8EAED));
    });

    test('minimal factory creates minimal style', () {
      final style = NativeAdStyle.minimal();

      expect(style.ctaCornerRadius, 4);
      expect(style.containerCornerRadius, 8);
      expect(style.iconSize, 40);
    });

    test('toMap serializes all properties', () {
      const style = NativeAdStyle();
      final map = style.toMap();

      expect(map.containsKey('ctaBackgroundColor'), true);
      expect(map.containsKey('ctaTextColor'), true);
      expect(map.containsKey('containerBackgroundColor'), true);
      expect(map.containsKey('headlineTextColor'), true);
      expect(map.containsKey('bodyTextColor'), true);
      expect(map.containsKey('mediaViewHeight'), true);
      expect(map.containsKey('iconSize'), true);
      expect(map.containsKey('showAdLabel'), true);
    });

    test('copyWith creates new instance with updated values', () {
      const style = NativeAdStyle();

      final copied = style.copyWith(
        ctaCornerRadius: 16,
        containerCornerRadius: 20,
      );

      expect(copied.ctaCornerRadius, 16);
      expect(copied.containerCornerRadius, 20);
      expect(copied.headlineFontSize, style.headlineFontSize);
    });
  });

  group('NativeAdEvents', () {
    test('creates with all callbacks', () {
      bool loaded = false;
      bool failed = false;
      bool clicked = false;

      final events = NativeAdEvents(
        onAdLoaded: () => loaded = true,
        onAdFailed: (_, __) => failed = true,
        onAdClicked: () => clicked = true,
      );

      events.onAdLoaded?.call();
      events.onAdFailed?.call('error', -1);
      events.onAdClicked?.call();

      expect(loaded, true);
      expect(failed, true);
      expect(clicked, true);
    });

    test('copyWith updates callbacks', () {
      bool originalLoaded = false;
      bool newLoaded = false;

      final original = NativeAdEvents(
        onAdLoaded: () => originalLoaded = true,
      );

      final copied = original.copyWith(
        onAdLoaded: () => newLoaded = true,
      );

      copied.onAdLoaded?.call();

      expect(originalLoaded, false);
      expect(newLoaded, true);
    });
  });

  group('ColorExtension', () {
    test('toHex returns correct format', () {
      expect(const Color(0xFFFF0000).toHex(), '#FF0000');
      expect(const Color(0xFF00FF00).toHex(), '#00FF00');
      expect(const Color(0xFF0000FF).toHex(), '#0000FF');
    });

    test('toHexWithAlpha includes alpha channel', () {
      expect(const Color(0x80FF0000).toHexWithAlpha(), '#80FF0000');
      expect(const Color(0xFFFF0000).toHexWithAlpha(), '#FFFF0000');
    });
  });

  group('HexColorParsing', () {
    test('parses 6-digit hex colors', () {
      final color = '#FF0000'.toColor();
      expect(color.r, closeTo(1.0, 0.01));
      expect(color.g, closeTo(0.0, 0.01));
      expect(color.b, closeTo(0.0, 0.01));
    });

    test('parses 8-digit hex colors with alpha', () {
      final color = '#80FF0000'.toColor();
      expect(color.a, closeTo(0.5, 0.01));
      expect(color.r, closeTo(1.0, 0.01));
    });

    test('parses 3-digit hex colors', () {
      final color = '#F00'.toColor();
      expect(color.r, closeTo(1.0, 0.01));
      expect(color.g, closeTo(0.0, 0.01));
      expect(color.b, closeTo(0.0, 0.01));
    });

    test('returns default color for invalid input', () {
      final color = 'invalid'.toColor();
      expect(color, const Color(0xFF000000));
    });
  });

  group('EdgeInsetsExtension', () {
    test('toMap returns correct structure', () {
      const insets = EdgeInsets.only(top: 1, left: 2, bottom: 3, right: 4);
      final map = insets.toMap();

      expect(map['top'], 1.0);
      expect(map['left'], 2.0);
      expect(map['bottom'], 3.0);
      expect(map['right'], 4.0);
    });

    test('toList returns correct order', () {
      const insets = EdgeInsets.only(top: 1, left: 2, bottom: 3, right: 4);
      final list = insets.toList();

      expect(list, [1.0, 2.0, 3.0, 4.0]);
    });
  });

  group('EdgeInsetsFromMap', () {
    test('creates EdgeInsets from map', () {
      final map = {'top': 1.0, 'left': 2.0, 'bottom': 3.0, 'right': 4.0};
      final insets = map.toEdgeInsets();

      expect(insets.top, 1.0);
      expect(insets.left, 2.0);
      expect(insets.bottom, 3.0);
      expect(insets.right, 4.0);
    });

    test('uses defaults for missing keys', () {
      final map = <String, dynamic>{'top': 5.0};
      final insets = map.toEdgeInsets();

      expect(insets.top, 5.0);
      expect(insets.left, 0.0);
      expect(insets.bottom, 0.0);
      expect(insets.right, 0.0);
    });
  });
}
