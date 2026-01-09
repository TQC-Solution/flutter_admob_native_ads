import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

// Constants
import 'constants/ad_constants.dart';

// Utils
import 'utils/layout_descriptions.dart';

// Widgets
import 'widgets/layout_selector.dart';
import 'widgets/preload_demo_section.dart';
import 'widgets/smart_reload_demo_section.dart';
import 'widgets/ad_display_section.dart';
import 'widgets/layout_info_card.dart';
import 'widgets/preloaded_ad_display.dart';

// Pages
import 'pages/preloaded_ad_page.dart';
import 'pages/banner_ads_page.dart';

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
  // Theme
  bool _isDarkTheme = false;

  // Layout selection
  NativeAdLayoutType _selectedLayout = NativeAdLayoutType.form1;

  // Preload controller
  NativeAdController? _preloadedController;
  bool _isPreloading = false;
  bool _showPreloadedAd = false;

  // Smart Reload Demo
  NativeAdController? _smartReloadController;
  bool _isSmartReloadEnabled = false;
  int _reloadIntervalSeconds = 30;
  String _reloadStatus = 'Not started';

  // Banner Ad Demo
  BannerAdController? _bannerController;
  BannerAdSize _selectedBannerSize = BannerAdSize.adaptiveBanner;

  @override
  void dispose() {
    _preloadedController?.dispose();
    _smartReloadController?.dispose();
    _bannerController?.dispose();
    super.dispose();
  }

  // ============================================================================
  // PRELOAD METHODS
  // ============================================================================

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
        adUnitId: AdConstants.testAdUnitId,
        layoutType: _selectedLayout,
        style: NativeAdStyle(
          ctaBackgroundColor: const Color(AdConstants.defaultCtaColor),
        ),
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

  /// Navigate to page showing preloaded ad
  void _showPreloadedInNewScreen() {
    if (_preloadedController == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreloadedAdPage(preloadedController: _preloadedController!),
      ),
    );
  }

  // ============================================================================
  // SMART RELOAD METHODS
  // ============================================================================

  /// Initialize Smart Reload Demo
  Future<void> _initSmartReload() async {
    setState(() {
      _reloadStatus = 'Initializing...';
    });

    // Dispose old controller
    _smartReloadController?.dispose();

    // Create main controller with smart reload
    _smartReloadController = NativeAdController(
      options: NativeAdOptions(
        adUnitId: AdConstants.testAdUnitId,
        layoutType: _selectedLayout,
        style: NativeAdStyle(
          ctaBackgroundColor: const Color(AdConstants.defaultCtaColor),
        ),
        enableDebugLogs: true,
        enableSmartReload: true,
        reloadIntervalSeconds: _reloadIntervalSeconds,
        retryDelaySeconds: 12,
      ),
      events: NativeAdEvents(
        onAdLoaded: () {
          if (mounted) {
            setState(() {
              _reloadStatus = 'Ad loaded!';
            });
          }
          debugPrint('[SmartReload Demo] Ad loaded!');
        },
        onAdFailed: (error, code) {
          if (mounted) {
            setState(() {
              _reloadStatus = 'Load failed: $error';
            });
          }
          debugPrint('[SmartReload Demo] Ad failed: $error');
        },
      ),
    );

    if (!mounted) return;

    setState(() {
      _isSmartReloadEnabled = true;
      _reloadStatus = 'Started - Timer: ${_reloadIntervalSeconds}s';
    });
  }

  /// Trigger manual reload
  void _triggerManualReload() {
    if (_smartReloadController == null) return;

    setState(() {
      _reloadStatus = 'Manual reload triggered...';
    });

    // Use smart reload (visibility-aware)
    _smartReloadController!.triggerSmartReload();
  }

  /// Update reload interval (simulating remote config)
  void _updateReloadInterval(int seconds) {
    setState(() {
      _reloadIntervalSeconds = seconds;
    });

    if (_smartReloadController != null) {
      _smartReloadController!.updateReloadInterval(seconds);
      setState(() {
        _reloadStatus = 'Interval updated: ${seconds}s';
      });
    }
  }

  /// Stop smart reload
  void _stopSmartReload() {
    _smartReloadController?.dispose();
    _smartReloadController = null;

    setState(() {
      _isSmartReloadEnabled = false;
      _reloadStatus = 'Stopped';
    });
  }

  // ============================================================================
  // THEME METHODS
  // ============================================================================

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  // ============================================================================
  // LAYOUT METHODS
  // ============================================================================

  void _selectLayout(NativeAdLayoutType layout) {
    setState(() {
      _selectedLayout = layout;
    });
  }

  // ============================================================================
  // BANNER AD METHODS
  // ============================================================================

  /// Navigate to Banner Ads page
  void _openBannerAdsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BannerAdsPage()),
    );
  }

  /// Select banner size
  void _selectBannerSize(BannerAdSize size) {
    setState(() {
      _selectedBannerSize = size;
      _bannerController?.dispose();
      _bannerController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Ads Demo - 12 Forms'),
        actions: [
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          // Layout selector
          LayoutSelector(
            layouts: AdConstants.layouts,
            selectedLayout: _selectedLayout,
            onLayoutSelected: _selectLayout,
          ),

          // Content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Layout preview header
                  Text(
                    'Preview: ${_selectedLayout.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LayoutDescriptions.getDescription(_selectedLayout),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Preload section
                  PreloadDemoSection(
                    preloadedController: _preloadedController,
                    isPreloading: _isPreloading,
                    onPreload: _preloadAd,
                    onShowPreloaded: _showPreloaded,
                    onShowInNewScreen: _showPreloadedInNewScreen,
                  ),
                  const SizedBox(height: 16),

                  // Smart Reload Demo Section
                  SmartReloadDemoSection(
                    isEnabled: _isSmartReloadEnabled,
                    status: _reloadStatus,
                    reloadIntervalSeconds: _reloadIntervalSeconds,
                    availableIntervals: AdConstants.reloadIntervals,
                    onStart: _initSmartReload,
                    onManualReload: _triggerManualReload,
                    onStop: _stopSmartReload,
                    onIntervalChanged: _updateReloadInterval,
                  ),
                  const SizedBox(height: 16),

                  // Smart Reload Ad Widget
                  if (_isSmartReloadEnabled && _smartReloadController != null)
                    _buildSmartReloadAd(),

                  // Preloaded Ad Widget
                  if (_showPreloadedAd && _preloadedController != null)
                    PreloadedAdDisplay(controller: _preloadedController!),

                  // Regular Auto-Load Ad
                  AdDisplaySection(
                    adUnitId: AdConstants.testAdUnitId,
                    layoutType: _selectedLayout,
                    isDarkTheme: _isDarkTheme,
                    enableDebugLogs: true,
                  ),
                  const SizedBox(height: 8),

                  // Info card
                  LayoutInfoCard(layoutType: _selectedLayout),

                  const SizedBox(height: 16),

                  // Banner Ad Section
                  _buildBannerAdSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the banner ad section
  Widget _buildBannerAdSection() {
    return Card(
      elevation: 2,
      color: _isDarkTheme ? Colors.grey[850] : Colors.orange[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Banner Ads',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: _openBannerAdsPage,
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Full Demo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Banner size selector
                Wrap(
                  spacing: 8,
                  children: BannerAdSize.values.map((size) {
                    final isSelected = _selectedBannerSize == size;
                    return FilterChip(
                      label: Text(size.name),
                      selected: isSelected,
                      onSelected: (_) => _selectBannerSize(size),
                      selectedColor: Colors.orange,
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Banner Ad Widget
          BannerAdWidget(
            key: ValueKey('banner-$_selectedBannerSize'),
            options: BannerAdOptions(
              adUnitId: AdConstants.testBannerAdUnitId,
              size: _selectedBannerSize,
              enableDebugLogs: true,
            ),
            height: _selectedBannerSize.recommendedHeight,
            onAdLoaded: () {
              debugPrint(
                '[Banner Demo] Banner loaded: ${_selectedBannerSize.name}',
              );
            },
            onAdFailed: (error) {
              debugPrint('[Banner Demo] Banner failed: $error');
            },
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Build the smart reload ad widget
  Widget _buildSmartReloadAd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Smart Reload Ad:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        NativeAdWidget(
          // Use controller ID as key - DO NOT include reload count
          // Smart reload happens transparently via state stream
          key: ValueKey('smart-reload-${_smartReloadController!.id}'),
          options: _smartReloadController!.options,
          controller: _smartReloadController,
          autoLoad: true, // Load ad when widget is created
          height: _selectedLayout.recommendedHeight,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
