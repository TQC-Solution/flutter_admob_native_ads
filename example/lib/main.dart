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

  // Preload controller
  NativeAdController? _preloadedController;
  bool _isPreloading = false;
  bool _showPreloadedAd = false;

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
  void dispose() {
    _preloadedController?.dispose();
    super.dispose();
  }

  /// Preload an ad before showing it
  Future<void> _preloadAd() async {
    if (_isPreloading) return;

    setState(() {
      _isPreloading = true;
      _showPreloadedAd = false;
    });

    // Dispose old controller if exists
    _preloadedController?.dispose();

    // Create new controller and preload
    _preloadedController = NativeAdController(
      options: NativeAdOptions(
        adUnitId: _testAdUnitId,
        layoutType: _selectedLayout,
        style: NativeAdStyle(ctaBackgroundColor: const Color(0xFF0E4DD0)),
        enableDebugLogs: true,
      ),
    );

    final success = await _preloadedController!.preload();

    if (!mounted) return;

    setState(() {
      _isPreloading = false;
    });

    if (success) {
      debugPrint('Ad preloaded successfully! Ready to show instantly.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ad preloaded! Tap "Show Preloaded Ad" to display instantly.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      debugPrint('Ad preload failed.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preload failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show the preloaded ad
  void _showPreloaded() {
    if (_preloadedController?.isLoaded == true) {
      setState(() {
        _showPreloadedAd = true;
      });
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

                  // Preload section
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preload Demo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Preload ads before showing them for instant display.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _isPreloading ? null : _preloadAd,
                                icon: _isPreloading
                                    ? const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.download),
                                label: Text(
                                  _isPreloading
                                      ? 'Preloading...'
                                      : 'Preload Ad',
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      (_preloadedController?.isLoaded == true &&
                                          !_showPreloadedAd)
                                      ? _showPreloaded
                                      : null,
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('Show Preloaded'),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWidget(
                                    preloadedController: _preloadedController!,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text(
                              'Show Preloaded Ad in New Screen',
                            ),
                          ),
                          if (_preloadedController?.isLoaded == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Ad is preloaded and ready!',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Show preloaded ad if available
                  if (_showPreloadedAd && _preloadedController != null) ...[
                    const Text(
                      'Preloaded Ad (Instant Display):',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    NativeAdWidget(
                      key: const ValueKey('preloaded-ad'),
                      options: _preloadedController!.options,
                      controller: _preloadedController,
                      autoLoad: false, // Don't reload - use preloaded ad
                      height: _preloadedController!
                          .options
                          .layoutType
                          .recommendedHeight,
                    ),
                    const SizedBox(height: 8),
                  ],

                  const Text(
                    'Regular Ad (Auto-Load):',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildAdWidget(),
                  const SizedBox(height: 8),
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

class MyWidget extends StatelessWidget {
  final NativeAdController preloadedController;
  const MyWidget({super.key, required this.preloadedController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preloaded Ad')),
      body: Expanded(
        child: Center(
          child: NativeAdWidget(
            key: const ValueKey('preloaded-ad'),
            options: preloadedController.options,
            controller: preloadedController,
            autoLoad: false, // Don't reload - use preloaded ad
            height: preloadedController.options.layoutType.recommendedHeight,
          ),
        ),
      ),
    );
  }
}
