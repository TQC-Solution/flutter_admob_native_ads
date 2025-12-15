import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Ads Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NativeAdsDemo(),
    );
  }
}

class NativeAdsDemo extends StatefulWidget {
  const NativeAdsDemo({super.key});

  @override
  State<NativeAdsDemo> createState() => _NativeAdsDemoState();
}

class _NativeAdsDemoState extends State<NativeAdsDemo> {
  bool _isDarkTheme = false;
  NativeAdLayoutType _selectedLayout = NativeAdLayoutType.form1;

  // Test ad unit IDs from Google
  String get _testAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  // All available layout types
  final List<NativeAdLayoutType> _layouts = [
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

  String _getLayoutDescription(NativeAdLayoutType layout) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Ads Demo - 12 Forms'),
        actions: [
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _isDarkTheme = !_isDarkTheme;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Layout selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Layout Type:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _layouts.length,
                    itemBuilder: (context, index) {
                      final layout = _layouts[index];
                      final isSelected = layout == _selectedLayout;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text('Form${index + 1}'),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedLayout = layout;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Ad preview area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview: ${_selectedLayout.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getLayoutDescription(_selectedLayout),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  _buildAdWidget(),
                  const SizedBox(height: 24),
                  // Info card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Layout Info',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Layout: ${_selectedLayout.name}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Recommended Height: ${_selectedLayout.recommendedHeight}dp',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Description: ${_getLayoutDescription(_selectedLayout)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdWidget() {
    String hexColor = '0E4DD0';
    // Rebuild widget when layout or theme changes
    return NativeAdWidget(
      key: ValueKey('${_selectedLayout.name}-$_isDarkTheme'),
      options: NativeAdOptions(
        adUnitId: _testAdUnitId,
        layoutType: _selectedLayout,
        // style: _isDarkTheme ? NativeAdStyle.dark() : NativeAdStyle.light(),
        style: NativeAdStyle(
          ctaBackgroundColor: Color(int.parse('0xFF$hexColor')),
        ),
        enableDebugLogs: true,
      ),
      height: _selectedLayout.recommendedHeight,
      onAdLoaded: () {
        debugPrint('Ad loaded successfully!');
      },
      onAdFailed: (error) {
        debugPrint('Ad failed to load: $error');
      },
      onAdClicked: () {
        debugPrint('Ad clicked!');
      },
      loadingWidget: Container(
        decoration: BoxDecoration(
          color: _isDarkTheme ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: _isDarkTheme ? Colors.white : Colors.blue,
              ),
              const SizedBox(height: 8),
              Text(
                'Loading ad...',
                style: TextStyle(
                  color: _isDarkTheme ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
      errorWidget: (error) => Container(
        decoration: BoxDecoration(
          color: _isDarkTheme ? Colors.grey[800] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: _isDarkTheme ? Colors.white54 : Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Ad not available',
                style: TextStyle(
                  color: _isDarkTheme ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
