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
  NativeAdLayoutType _selectedLayout = NativeAdLayoutType.standard;
  bool _isDarkTheme = false;

  // Test ad unit IDs from Google
  String get _testAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Ads Demo'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Layout selector
            const Text(
              'Select Layout Type:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<NativeAdLayoutType>(
              segments: const [
                ButtonSegment(
                  value: NativeAdLayoutType.compact,
                  label: Text('Compact'),
                ),
                ButtonSegment(
                  value: NativeAdLayoutType.standard,
                  label: Text('Standard'),
                ),
                ButtonSegment(
                  value: NativeAdLayoutType.fullMedia,
                  label: Text('Full Media'),
                ),
              ],
              selected: {_selectedLayout},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedLayout = selection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Ad preview
            const Text(
              'Ad Preview:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
                      'About this demo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This demo uses Google\'s test ad unit IDs. '
                      'In production, replace with your actual ad unit IDs.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Layout: ${_selectedLayout.name}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Recommended Height: ${_selectedLayout.recommendedHeight}dp',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdWidget() {
    // Rebuild widget when layout or theme changes
    return NativeAdWidget(
      key: ValueKey('$_selectedLayout-$_isDarkTheme'),
      options: NativeAdOptions(
        adUnitId: _testAdUnitId,
        layoutType: _selectedLayout,
        style: _isDarkTheme ? NativeAdStyle.dark() : NativeAdStyle.light(),
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
