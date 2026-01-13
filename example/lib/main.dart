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

  // Multiple Ads Test (same ad unit ID)
  static const int _multipleAdsCount = 3;
  final List<NativeAdController?> _multipleAdControllers = List.filled(
    _multipleAdsCount,
    null,
  );
  bool _showMultipleAds = false;

  @override
  void dispose() {
    _preloadedController?.dispose();
    _smartReloadController?.dispose();
    _bannerController?.dispose();
    for (var controller in _multipleAdControllers) {
      controller?.dispose();
    }
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

  // ============================================================================
  // MULTIPLE ADS TEST METHODS (Same Ad Unit ID)
  // ============================================================================

  /// Initialize multiple ads with the same ad unit ID
  Future<void> _initMultipleAds() async {
    // Dispose old controllers
    for (var i = 0; i < _multipleAdsCount; i++) {
      _multipleAdControllers[i]?.dispose();
    }

    // Create new controllers with the same ad unit ID
    for (var i = 0; i < _multipleAdsCount; i++) {
      final index = i;
      _multipleAdControllers[i] = NativeAdController(
        options: NativeAdOptions(
          adUnitId: AdConstants.testAdUnitId, // Same ad unit ID for all ads
          layoutType: _selectedLayout,
          style: NativeAdStyle(
            ctaBackgroundColor: const Color(AdConstants.defaultCtaColor),
          ),
          enableSmartReload: true,
          enableDebugLogs: true,
        ),
        events: NativeAdEvents(
          onAdLoaded: () {
            debugPrint('[Multiple Ads Test] Ad #$index loaded successfully!');
          },
          onAdFailed: (error, code) {
            debugPrint('[Multiple Ads Test] Ad #$index failed: $error');
          },
          onAdClicked: () {
            debugPrint('[Multiple Ads Test] Ad #$index clicked!');
          },
          onAdImpression: () {
            debugPrint('[Multiple Ads Test] Ad #$index impression!');
          },
        ),
      );
    }

    setState(() {
      _showMultipleAds = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_multipleAdsCount ads initialized with same ad unit ID. '
          'All callbacks should work independently.',
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }

  /// Clear multiple ads
  void _clearMultipleAds() {
    for (var i = 0; i < _multipleAdsCount; i++) {
      _multipleAdControllers[i]?.dispose();
      _multipleAdControllers[i] = null;
    }

    setState(() {
      _showMultipleAds = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: _isDarkTheme
            ? ColorScheme.dark(
                primary: Colors.blue,
                secondary: Colors.blueAccent,
                surface: Colors.grey[900]!,
              )
            : ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.blueAccent,
                surface: Colors.white,
              ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _isDarkTheme ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: _isDarkTheme ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.ad_units,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Native Ads Demo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '12 Layout Forms',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: _isDarkTheme ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isDarkTheme ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: IconButton(
                icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
                onPressed: _toggleTheme,
                tooltip: _isDarkTheme ? 'Light Mode' : 'Dark Mode',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Layout selector with enhanced styling
            Container(
              decoration: BoxDecoration(
                color: _isDarkTheme ? Colors.grey[850] : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: LayoutSelector(
                layouts: AdConstants.layouts,
                selectedLayout: _selectedLayout,
                onLayoutSelected: _selectLayout,
              ),
            ),

            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Layout preview header with gradient
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isDarkTheme
                              ? [Colors.grey[850]!, Colors.grey[800]!]
                              : [Colors.blue[50]!, Colors.blue[100]!],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isDarkTheme
                              ? Colors.grey[700]!
                              : Colors.blue[200]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.preview,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _selectedLayout.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkTheme
                                      ? Colors.white
                                      : Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            LayoutDescriptions.getDescription(_selectedLayout),
                            style: TextStyle(
                              fontSize: 14,
                              color: _isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Preload section
                    PreloadDemoSection(
                      preloadedController: _preloadedController,
                      isPreloading: _isPreloading,
                      onPreload: _preloadAd,
                      onShowPreloaded: _showPreloaded,
                      onShowInNewScreen: _showPreloadedInNewScreen,
                    ),
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 12),

                    // Info card
                    LayoutInfoCard(layoutType: _selectedLayout),

                    const SizedBox(height: 20),

                    // Multiple Ads Test Section (Same Ad Unit ID)
                    _buildMultipleAdsTestSection(),
                    const SizedBox(height: 20),

                    // Banner Ad Section
                    _buildBannerAdSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the banner ad section
  Widget _buildBannerAdSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkTheme
              ? [Colors.grey[850]!, Colors.grey[800]!]
              : [Colors.orange[50]!, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDarkTheme ? Colors.grey[700]! : Colors.orange[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[400]!,
                                Colors.orange[600]!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_active,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Banner Ads',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isDarkTheme
                                ? Colors.white
                                : Colors.orange[900],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange[400]!, Colors.orange[600]!],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _openBannerAdsPage,
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Full Demo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Banner size selector
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: BannerAdSize.values.map((size) {
                    final isSelected = _selectedBannerSize == size;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  Colors.orange[400]!,
                                  Colors.orange[600]!,
                                ],
                              )
                            : null,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : (_isDarkTheme
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!),
                        ),
                      ),
                      child: FilterChip(
                        label: Text(size.name),
                        selected: isSelected,
                        onSelected: (_) => _selectBannerSize(size),
                        backgroundColor: Colors.transparent,
                        selectedColor: Colors.transparent,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (_isDarkTheme ? Colors.white : Colors.black87),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
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

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Build the smart reload ad widget
  Widget _buildSmartReloadAd() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkTheme
              ? [Colors.grey[850]!, Colors.grey[800]!]
              : [Colors.green[50]!, Colors.green[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDarkTheme ? Colors.grey[700]! : Colors.green[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.green[600]!],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.refresh, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Smart Reload Ad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkTheme ? Colors.white : Colors.green[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NativeAdWidget(
            // Use controller ID as key - DO NOT include reload count
            // Smart reload happens transparently via state stream
            key: ValueKey('smart-reload-${_smartReloadController!.id}'),
            options: _smartReloadController!.options,
            controller: _smartReloadController,
            autoLoad: true, // Load ad when widget is created
            height: _selectedLayout.recommendedHeight,
          ),
        ],
      ),
    );
  }

  /// Build the multiple ads test section
  Widget _buildMultipleAdsTestSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isDarkTheme
              ? [Colors.grey[850]!, Colors.grey[800]!]
              : [Colors.purple[50]!, Colors.purple[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDarkTheme ? Colors.grey[700]! : Colors.purple[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple[400]!, Colors.purple[600]!],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.copy_all,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Multiple Ads Test',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkTheme
                                    ? Colors.white
                                    : Colors.purple[900],
                              ),
                            ),
                            Text(
                              'Same Ad Unit ID • $_multipleAdsCount ads',
                              style: TextStyle(
                                fontSize: 13,
                                color: _isDarkTheme
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Control buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: _showMultipleAds
                        ? null
                        : LinearGradient(
                            colors: [Colors.purple[400]!, Colors.purple[600]!],
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _showMultipleAds ? null : _initMultipleAds,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Load Multiple Ads'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showMultipleAds
                          ? Colors.grey[400]
                          : Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: _showMultipleAds
                        ? LinearGradient(
                            colors: [Colors.red[400]!, Colors.red[600]!],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _showMultipleAds ? _clearMultipleAds : null,
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showMultipleAds
                          ? Colors.transparent
                          : Colors.grey[400],
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Multiple ads display
            if (_showMultipleAds)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: _isDarkTheme ? Colors.grey[700] : Colors.purple[200],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple[400]!, Colors.purple[600]!],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_multipleAdsCount ads loaded',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Same ad unit ID',
                        style: TextStyle(
                          fontSize: 13,
                          color: _isDarkTheme
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Display all ads
                  ...List.generate(_multipleAdsCount, (index) {
                    final controller = _multipleAdControllers[index];
                    if (controller == null) return const SizedBox.shrink();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isDarkTheme ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isDarkTheme
                              ? Colors.grey[700]!
                              : Colors.purple[200]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _isDarkTheme
                                  ? Colors.grey[800]
                                  : Colors.purple[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Ad #${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isDarkTheme
                                    ? Colors.purple[300]
                                    : Colors.purple[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          NativeAdWidget(
                            key: ValueKey('multi-ad-$index-${controller.id}'),
                            options: controller.options,
                            controller: controller,
                            autoLoad: true,
                            height: _selectedLayout.recommendedHeight,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isDarkTheme
                          ? Colors.purple[900]!.withValues(alpha: 0.3)
                          : Colors.purple[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isDarkTheme
                            ? Colors.purple[700]!
                            : Colors.purple[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: _isDarkTheme
                              ? Colors.purple[300]
                              : Colors.purple[900],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Check console logs to verify each ad triggers independent callbacks.',
                            style: TextStyle(
                              fontSize: 13,
                              color: _isDarkTheme
                                  ? Colors.purple[200]
                                  : Colors.purple[900],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
