import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

import '../constants/ad_constants.dart';

/// Full page demo for Banner Ads with all sizes and features
class BannerAdsPage extends StatefulWidget {
  const BannerAdsPage({super.key});

  @override
  State<BannerAdsPage> createState() => _BannerAdsPageState();
}

class _BannerAdsPageState extends State<BannerAdsPage> {
  // Banner controllers for each size
  final Map<BannerAdSize, BannerAdController> _bannerControllers = {};

  // Smart reload controller
  BannerAdController? _smartReloadController;
  bool _isSmartReloadEnabled = false;
  final int _reloadIntervalSeconds = 30;

  // Preload controller
  BannerAdController? _preloadedController;
  bool _isPreloading = false;
  bool _isPreloaded = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    for (var controller in _bannerControllers.values) {
      controller.dispose();
    }
    _smartReloadController?.dispose();
    _preloadedController?.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    // Create controllers for each banner size
    for (final size in AdConstants.bannerSizes) {
      _bannerControllers[size] = BannerAdController(
        options: BannerAdOptions(
          adUnitId: AdConstants.testBannerAdUnitId,
          size: size,
          enableDebugLogs: true,
        ),
        events: BannerAdEvents(
          onAdLoaded: _refresh,
          onAdFailed: (error, code) => _refresh,
        ),
      );
    }
  }

  void _refresh() {
    setState(() {});
  }

  Future<void> _preloadBanner() async {
    if (_isPreloading) return;

    setState(() {
      _isPreloading = true;
      _isPreloaded = false;
    });

    _preloadedController?.dispose();

    final controller = BannerAdController(
      options: BannerAdOptions(
        adUnitId: AdConstants.testBannerAdUnitId,
        size: BannerAdSize.adaptiveBanner,
        enableDebugLogs: true,
      ),
    );

    final success = await controller.preload();

    if (!mounted) return;

    setState(() {
      _preloadedController = controller;
      _isPreloading = false;
      _isPreloaded = success;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Banner preloaded! Ready to show instantly.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preload failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startSmartReload() {
    _smartReloadController?.dispose();

    setState(() {
      _isSmartReloadEnabled = true;
    });

    _smartReloadController = BannerAdController(
      options: BannerAdOptions(
        adUnitId: AdConstants.testBannerAdUnitId,
        size: BannerAdSize.adaptiveBanner,
        enableDebugLogs: true,
        enableSmartReload: true,
        reloadIntervalSeconds: _reloadIntervalSeconds,
        retryDelaySeconds: 12,
      ),
      events: BannerAdEvents(
        onAdLoaded: () {
          log("Banner ads Loading");
        },
      ),
    );
  }

  void _stopSmartReload() {
    _smartReloadController?.dispose();
    _smartReloadController = null;

    setState(() {
      _isSmartReloadEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Ads Demo'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            _buildInfoCard(),

            const SizedBox(height: 24),

            // Preload Section
            _buildPreloadSection(),

            const SizedBox(height: 24),

            // Smart Reload Section
            _buildSmartReloadSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700]),
                const SizedBox(width: 8),
                const Text(
                  'About Banner Ads',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Banner ads are rectangular ads that occupy a spot within your app\'s layout. '
              'They stay on screen while users interact with the app, '
              'either anchored at the top or bottom of the screen or inline with content.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Available sizes: ${AdConstants.bannerSizes.map((s) => s.name).join(", ")}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreloadSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cached, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Preload Demo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Preload an ad before showing it for instant display.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isPreloading ? null : _preloadBanner,
                  icon: _isPreloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(_isPreloading ? 'Loading...' : 'Preload Banner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                if (_isPreloaded)
                  const Chip(
                    label: Text(
                      'Ready!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
              ],
            ),
            if (_isPreloaded && _preloadedController != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preloaded Banner:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BannerAdWidget(
                        options: BannerAdOptions(
                          adUnitId: AdConstants.testBannerAdUnitId,
                          size: BannerAdSize.adaptiveBanner,
                        ),
                        controller: _preloadedController,
                        autoLoad: false,
                        height: BannerAdSize.adaptiveBanner.recommendedHeight,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartReloadSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.autorenew, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Smart Reload Demo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Banner automatically reloads when visible. Only triggers when app is in foreground AND ad is on screen.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (!_isSmartReloadEnabled)
              ElevatedButton.icon(
                onPressed: _startSmartReload,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Smart Reload'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Chip(
                        label: Text(
                          'Active',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Interval: $_reloadIntervalSeconds seconds'),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _stopSmartReload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Stop'),
                      ),
                    ],
                  ),
                  if (_smartReloadController != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Smart Reload Banner:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BannerAdWidget(
                              options: _smartReloadController!.options,
                              controller: _smartReloadController,
                              autoLoad: true,
                              height:
                                  BannerAdSize.adaptiveBanner.recommendedHeight,
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
