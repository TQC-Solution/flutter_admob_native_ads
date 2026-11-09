import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admob_native_ads_example/template_gallery.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('form6 themes and form10 loading fit without layout errors', (
    tester,
  ) async {
    Future<void> waitForAd() async {
      final deadline = DateTime.now().add(const Duration(seconds: 45));
      while (find.text('Loaded').evaluate().isEmpty &&
          DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 250));
        expect(find.textContaining('Failed:'), findsNothing);
      }
      expect(find.text('Loaded'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(UiKitView), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const TemplateGallery(forms: [6], initialForm: 6));
    await waitForAd();

    await tester.tap(find.byTooltip('Toggle theme'));
    await tester.pump();
    await waitForAd();

    await tester.pumpWidget(
      const TemplateGallery(
        key: ValueKey('form10-loading'),
        forms: [10],
        initialForm: 10,
      ),
    );
    await tester.tap(find.byTooltip('Preview loading'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Loading'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
