import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';
import 'package:flutter_admob_native_ads/src/widgets/shimmer_ad_placeholder.dart';

void main() {
  testWidgets('all loading layouts fit their recommended heights',
      (tester) async {
    for (final brightness in Brightness.values) {
      for (final width in [320.0, 360.0]) {
        for (final layout in NativeAdLayoutType.values) {
          await tester.pumpWidget(MaterialApp(
            theme: ThemeData(brightness: brightness),
            home: Center(
              child: SizedBox(
                width: width,
                height: layout.recommendedHeight,
                child: ShimmerAdPlaceholder(layoutType: layout),
              ),
            ),
          ));
          expect(tester.takeException(), isNull,
              reason: '$layout $brightness at width $width must not overflow');
        }
      }
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('form10 skeleton fits a shorter custom height', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Center(
        child: SizedBox(
          width: 280,
          height: 80,
          child: ShimmerAdPlaceholder(layoutType: NativeAdLayoutType.form10),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
