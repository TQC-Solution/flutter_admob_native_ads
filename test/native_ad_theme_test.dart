import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  test('default style follows brightness through copyWith', () {
    final options = NativeAdOptions(adUnitId: 'test-ad-unit');
    final copied = options.copyWith(enableDebugLogs: true);

    expect(copied.toMap(brightness: Brightness.dark)['style'],
        NativeAdStyle.dark().toMap());
    expect(copied.toMap(brightness: Brightness.light)['style'],
        options.style.toMap());
    expect(copied.toMap()['style'], options.style.toMap());
  });

  test('explicit style remains unchanged in either theme and after copyWith',
      () {
    final style = NativeAdStyle.dark().copyWith(
      headlineTextColor: Colors.pink,
      bodyTextColor: Colors.cyan,
    );
    final options = NativeAdOptions(adUnitId: 'test-ad-unit', style: style);
    for (final brightness in Brightness.values) {
      expect(options.toMap(brightness: brightness)['style'], style.toMap());
      expect(
        options
            .copyWith(enableDebugLogs: true)
            .toMap(brightness: brightness)['style'],
        style.toMap(),
      );
    }
    expect(
      options
          .copyWith(style: NativeAdStyle.light())
          .toMap(brightness: Brightness.dark)['style'],
      NativeAdStyle.light().toMap(),
    );
  });

  for (final layout in [NativeAdLayoutType.form1, NativeAdLayoutType.form8]) {
    testWidgets('$layout updates loaded ad when theme changes', (tester) async {
      final platform = defaultTargetPlatform;
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      final requests = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter_admob_native_ads'),
        (call) async {
          requests.add(call.method);
          return null;
        },
      );
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform_views,
        (call) async => call.method == 'create' ? 1 : null,
      );
      final controller = NativeAdController(
        options: NativeAdOptions(adUnitId: 'test-ad-unit', layoutType: layout),
      )..state = NativeAdState.loaded;
      addTearDown(() async {
        await controller.dispose();
        VisibilityDetectorController.instance.updateInterval =
            const Duration(milliseconds: 500);
      });

      Future<void> show(Brightness brightness) => tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(brightness: brightness),
              themeAnimationDuration: Duration.zero,
              home: NativeAdWidget(controller: controller, autoLoad: false),
            ),
          );

      Map<dynamic, dynamic> params() => platform == TargetPlatform.android
          ? tester.widget<AndroidView>(find.byType(AndroidView)).creationParams
              as Map
          : tester.widget<UiKitView>(find.byType(UiKitView)).creationParams
              as Map;
      Key? viewKey() => platform == TargetPlatform.android
          ? tester.widget<AndroidView>(find.byType(AndroidView)).key
          : tester.widget<UiKitView>(find.byType(UiKitView)).key;

      await show(Brightness.light);
      final lightKey = viewKey();
      expect(params()['style']['headlineTextColor'], '#FF202124');
      expect(params()['controllerId'], controller.id);

      await show(Brightness.dark);
      expect(params()['style'], NativeAdStyle.dark().toMap());
      expect(viewKey(), isNot(lightKey));
      expect(params()['controllerId'], controller.id);

      await show(Brightness.light);
      expect(viewKey(), lightKey);
      expect(params()['style']['headlineTextColor'], '#FF202124');
      expect(requests, isNot(contains('loadAd')));
      expect(requests, isNot(contains('reloadAd')));
      await tester.pumpWidget(const SizedBox.shrink());
    },
        variant: TargetPlatformVariant(
          {TargetPlatform.android, TargetPlatform.iOS},
        ));
  }
}
