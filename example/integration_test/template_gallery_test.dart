import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_admob_native_ads_example/template_gallery.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'all reference templates load native ads and survive theme changes',
    (tester) async {
      await tester.pumpWidget(const TemplateGallery());

      Future<void> waitForAd() async {
        final deadline = DateTime.now().add(const Duration(seconds: 45));
        while (find.text('Loaded').evaluate().isEmpty &&
            DateTime.now().isBefore(deadline)) {
          await tester.pump(const Duration(milliseconds: 250));
          expect(find.textContaining('Failed:'), findsNothing);
        }
        expect(
          find.text('Loaded'),
          findsOneWidget,
          reason:
              'A real Google test ad must load before checking the template.',
        );
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(UiKitView), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      for (final form in [2, 3, 4, 5, 7, 11, 12]) {
        if (form != 2) {
          await tester.tap(find.text('Form $form'));
          await tester.pump();
        }
        await waitForAd();
      }

      await tester.tap(find.byTooltip('Toggle theme'));
      await tester.pump();
      await waitForAd();
      expect(
        Theme.of(tester.element(find.byType(UiKitView))).brightness,
        Brightness.dark,
      );
      // The same platform channel remains usable after replacing every layout.
      expect(
        await const MethodChannel(
          'flutter_admob_native_ads',
        ).invokeMethod<String>('getPlatformVersion'),
        isNotEmpty,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    },
  );
}
