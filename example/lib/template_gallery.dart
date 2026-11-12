import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

import 'constants/ad_constants.dart';

/// Run with: flutter run -t lib/template_gallery.dart
/// Uses Google's test ads; it never substitutes a bitmap for a native ad view.
void main() => runApp(const TemplateGallery());

class TemplateGallery extends StatefulWidget {
  const TemplateGallery({
    super.key,
    this.forms = const [2, 3, 4, 5, 7, 11, 12],
    this.initialForm = 2,
  });

  final List<int> forms;
  final int initialForm;

  @override
  State<TemplateGallery> createState() => _TemplateGalleryState();
}

class _TemplateGalleryState extends State<TemplateGallery> {
  late int selected = widget.initialForm;
  bool dark = false;
  String status = 'Loading';
  bool previewLoading = false;
  int request = 0;
  late NativeAdOptions options = _options();

  NativeAdOptions _options() => NativeAdOptions(
    adUnitId: AdConstants.testAdUnitId,
    layoutType: NativeAdLayoutType.fromInt(selected),
    style: (dark ? NativeAdStyle.dark() : NativeAdStyle.light()).copyWith(
      ctaBackgroundColor: const Color(0xFF0E4DD0),
      ctaTextColor: Colors.white,
      containerCornerRadius: 12,
      containerShadowRadius: 0,
    ),
    enableDebugLogs: true,
  );

  void select(int form) => setState(() {
    selected = form;
    status = 'Loading';
    request++;
    options = _options();
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: dark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Native ad templates'),
        actions: [
          IconButton(
            tooltip: 'Preview loading',
            icon: Icon(
              previewLoading ? Icons.hourglass_full : Icons.hourglass_empty,
            ),
            onPressed: () {
              previewLoading = !previewLoading;
              select(selected);
            },
          ),
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              dark = !dark;
              select(selected);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  for (final form in widget.forms)
                    ChoiceChip(
                      label: Text('Form $form'),
                      selected: selected == form,
                      onSelected: (_) => select(form),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text('ad_$selected.png', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: selected == 2
                      ? 340
                      : (selected == 3 ? 328 : (selected == 11 ? 352 : 360)),
                  child: NativeAdWidget(
                    key: ValueKey('$selected-$request'),
                    options: options,
                    autoLoad: !previewLoading,
                    onAdLoaded: () => setState(() => status = 'Loaded'),
                    onAdFailed: (error) =>
                        setState(() => status = 'Failed: $error'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(status, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text(
                'Google test ad · native platform views\nPreview at the recommended layout height.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
