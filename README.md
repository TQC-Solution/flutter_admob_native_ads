# Flutter AdMob Native Ads

Production-ready Flutter plugin for displaying Google AdMob Native Ads with 12 customizable layout forms and SwiftUI-style declarative styling. 100% native rendering via Platform Views with full Android/iOS parity.

[![Version](https://img.shields.io/badge/version-1.0.4-blue.svg)](https://github.com/TQC-Solution/flutter_admob_native_ads)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Features

- **12 layout forms** (80dp - 320dp) optimized for various use cases
- **30+ style properties** with SwiftUI-style declarative API
- **Preload & Smart Reload** for better UX and automatic ad refresh
- **Full event callbacks** tracking (loaded, failed, clicked, impression, opened, closed, paid)
- **Built-in themes** (Light, Dark, Minimal)
- **100% native rendering** via Platform Views for high performance
- **Banner Ads support** with all 7 AdMob sizes
- **Smart scheduling** with app lifecycle and network awareness

## Quick Start

```dart
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

// Native Ad - Simple usage
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'ca-app-pub-xxx/xxx',
    layoutType: NativeAdLayoutType.form1,
    style: NativeAdStyle.light(),
  ),
  height: 80,
)

// Banner Ad - Simple usage
BannerAdWidget(
  options: BannerAdOptions(
    adUnitId: 'ca-app-pub-xxx/xxx',
    size: BannerAdSize.adaptiveBanner,
    adaptiveBannerHeight: 60,
  ),
  height: 60,
)
```

## Installation

### 1. Add dependency

```yaml
# pubspec.yaml
dependencies:
  flutter_admob_native_ads: ^1.0.4
```

Run `flutter pub get`

### 2. Android Setup

**Add AdMob App ID** to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

**Configure Gradle** - Ensure `minSdkVersion >= 21` in `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 3. iOS Setup

**Add AdMob App ID** to `ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

**Initialize SDK** in `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMobileAds
import UIKit

@main
class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

**Update Podfile** (`ios/Podfile`):

```ruby
platform :ios, '13.0'
pod 'Google-Mobile-Ads-SDK', '~> 11.0'
```

Run `cd ios && pod install`

## Native Ads

### Layout Forms

The plugin provides 12 pre-designed layouts optimized for different use cases:

| Form | Height | Style | Best For |
|------|--------|-------|----------|
| **form1** | 80dp | Horizontal compact | List items, in-feed ads |
| **form2** | 90dp | Horizontal with media | List with image preview |
| **form3** | 320dp | Vertical large media | Full-screen feeds |
| **form4** | 300dp | Vertical media-first | Product cards |
| **form5** | 300dp | Article card | Blog posts, articles |
| **form6** | 280dp | Standard feed | Social feeds (most popular) |
| **form7** | 140dp | Horizontal video | Video ads |
| **form8** | 100dp | Horizontal compact | Compact cards |
| **form9** | 280dp | CTA-first | Conversion-focused |
| **form10** | 120dp | Text-only | Minimal design |
| **form11** | 280dp | Vertical clean | Clean layout |
| **form12** | 280dp | Vertical alternative | Alternative layout |

### Basic Usage with Controller

For better control and lifecycle management, use `NativeAdController`:

```dart
class _MyWidgetState extends State<MyWidget> {
  late NativeAdController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NativeAdController(
      options: NativeAdOptions(
        adUnitId: 'your-ad-unit-id',
        layoutType: NativeAdLayoutType.form6,
        style: NativeAdStyle.light(),
      ),
      events: NativeAdEvents(
        onAdLoaded: () => print('Ad loaded'),
        onAdFailed: (error, code) => print('Failed: $error (code: $code)'),
        onAdClicked: () => analytics.logEvent('ad_clicked'),
        onAdImpression: () => analytics.logEvent('ad_impression'),
      ),
    );
    _controller.loadAd();
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NativeAdWidget(
            controller: _controller,
            height: NativeAdLayoutType.form6.recommendedHeight,
          ),
          // Your content...
        ],
      ),
    );
  }
}
```

### Preload for Instant Display

Preload ads before showing them to eliminate loading spinners:

```dart
class _MyScreenState extends State<MyScreen> {
  NativeAdController? _adController;
  bool _isAdReady = false;

  @override
  void initState() {
    super.initState();
    _preloadAd();
  }

  Future<void> _preloadAd() async {
    _adController = NativeAdController(
      options: NativeAdOptions(
        adUnitId: 'your-ad-unit-id',
        layoutType: NativeAdLayoutType.form6,
      ),
    );

    // Preload and wait for completion
    final success = await _adController!.preload();

    if (mounted) {
      setState(() => _isAdReady = success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Your content...
        Text('Content here...'),

        // Show ad instantly when ready
        if (_isAdReady && _adController != null)
          NativeAdWidget(
            controller: _adController,
            autoLoad: false,  // Important: don't reload
            height: 280,
          ),
      ],
    );
  }

  @override
  void dispose() {
    _adController?.dispose();
    super.dispose();
  }
}
```

**Benefits of Preload:**
- ✅ Instant display when user scrolls to ad
- ✅ No loading spinner flicker
- ✅ Better user experience
- ✅ Can verify ad loads before showing

### Smart Reload with Visibility

Enable automatic reload when ads become visible:

```dart
NativeAdController _controller = NativeAdController(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
    enableSmartReload: true,      // Enable smart reload
    reloadIntervalSeconds: 60,    // Reload every 60 seconds
    retryDelaySeconds: 12,        // Retry after 12 seconds if failed
  ),
);

// Widget automatically tracks visibility
NativeAdWidget(
  controller: _controller,
  height: 280,
  visibilityThreshold: 0.5,  // Trigger reload when 50% visible
)
```

**Smart Reload Features:**
- Only reloads when app is in foreground
- Only reloads when device has internet connection
- Respects visibility threshold
- Automatic retry with exponential backoff on failure
- Manual trigger: `controller.triggerSmartReload()`

### Custom Styling

Customize every aspect of your native ads:

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
    style: NativeAdStyle(
      // CTA Button
      ctaBackgroundColor: Colors.blue,
      ctaTextColor: Colors.white,
      ctaFontSize: 14,
      ctaFontWeight: FontWeight.w600,
      ctaCornerRadius: 8,
      ctaPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ctaElevation: 2,

      // Container
      containerBackgroundColor: Colors.white,
      containerCornerRadius: 12,
      containerPadding: EdgeInsets.all(12),
      containerMargin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      containerBorderColor: Colors.blue[200],
      containerBorderWidth: 2,
      containerShadowColor: Colors.black26,
      containerShadowRadius: 8,

      // Headline Text
      headlineTextColor: Colors.black,
      headlineFontSize: 16,
      headlineFontWeight: FontWeight.w600,
      headlineMaxLines: 2,

      // Body Text
      bodyTextColor: Colors.grey[600],
      bodyFontSize: 14,
      bodyFontWeight: FontWeight.w400,
      bodyMaxLines: 3,

      // Media View
      mediaViewHeight: 200,
      mediaViewCornerRadius: 8,
      mediaViewBackgroundColor: Colors.grey[200],

      // Icon
      iconSize: 48,
      iconCornerRadius: 8,
      iconBorderColor: Colors.grey[300],
      iconBorderWidth: 1,

      // Star Rating
      starRatingSize: 16,
      starRatingActiveColor: Colors.amber,
      starRatingInactiveColor: Colors.grey[300],

      // Ad Label
      showAdLabel: true,
      adLabelText: 'Ad',
      adLabelBackgroundColor: Colors.grey[300],
      adLabelTextColor: Colors.grey[700],
      adLabelCornerRadius: 4,
      adLabelPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),

      // Spacing
      itemSpacing: 8,
      sectionSpacing: 12,
    ),
  ),
)
```

### Built-in Themes

```dart
// Light theme (default)
NativeAdStyle.light()

// Dark theme
NativeAdStyle.dark()

// Minimal theme
NativeAdStyle.minimal()
```

### Using with ListView

Best practice for showing ads in feeds:

```dart
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<NativeAdController> _adControllers = [];
  static const int _adInterval = 5; // Show ad every 5 items

  @override
  void initState() {
    super.initState();
    _preloadAds();
  }

  Future<void> _preloadAds() async {
    // Preload first 3 ads
    for (int i = 0; i < 3; i++) {
      final controller = NativeAdController(
        options: NativeAdOptions(
          adUnitId: 'your-ad-unit-id',
          layoutType: NativeAdLayoutType.form6,
        ),
      );
      await controller.preload();
      _adControllers.add(controller);
    }
  }

  @override
  void dispose() {
    _adControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        // Show ad every 5 items
        if (index > 0 && index % _adInterval == 0) {
          final adIndex = (index / _adInterval).floor() - 1;
          if (adIndex < _adControllers.length) {
            return NativeAdWidget(
              controller: _adControllers[adIndex],
              autoLoad: false,
              height: 280,
            );
          }
        }
        return ContentItem(item: items[index]);
      },
    );
  }
}
```

### Custom Loading & Error Widgets

```dart
NativeAdWidget(
  options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
  controller: _controller,
  height: 280,

  // Custom loading widget
  loadingWidget: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 8),
        Text('Loading ad...'),
      ],
    ),
  ),

  // Custom error widget
  errorWidget: (error) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.grey),
        SizedBox(height: 8),
        Text(
          'Ad not available',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  ),
)
```

## Banner Ads

### Supported Sizes

| Size | Height | Dimensions | Description |
|------|--------|------------|-------------|
| **banner** | 50dp | 320x50 | Standard banner |
| **fullBanner** | 60dp | 468x60 | Full banner |
| **leaderboard** | 90dp | 728x90 | Leaderboard |
| **mediumRectangle** | 250dp | 300x250 | Medium rectangle (high CTR) |
| **smartBanner** | Adaptive | Screen width | Auto-adjust to screen |
| **adaptiveBanner** | Custom | Adaptive width | Custom height |
| **inlineAdaptive** | Auto | Varies | Inline adaptive |

### Basic Banner Usage

```dart
class _MyWidgetState extends State<MyWidget> {
  late BannerAdController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BannerAdController(
      options: BannerAdOptions(
        adUnitId: 'your-ad-unit-id',
        size: BannerAdSize.adaptiveBanner,
        adaptiveBannerHeight: 60,
        enableSmartReload: true,
        reloadIntervalSeconds: 30,
      ),
      events: BannerAdEvents(
        onAdLoaded: () => print('Banner loaded'),
        onAdFailed: (error, code) => print('Failed: $error'),
        onAdPaid: (value, currency) => print('Revenue: \$value $currency'),
      ),
    );
    _controller.loadAd();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banner Example')),
      body: Column(
        children: [
          // Banner at top
          BannerAdWidget(
            controller: _controller,
            height: 60,
          ),

          // Your content...
          Expanded(
            child: YourContent(),
          ),
        ],
      ),
    );
  }
}
```

### Banner at Bottom

```dart
Scaffold(
  body: YourContent(),
  bottomNavigationBar: BannerAdWidget(
    controller: _controller,
    height: 60,
  ),
)
```

### Preload Banner

```dart
class _MyScreenState extends State<MyScreen> {
  BannerAdController? _bannerController;
  bool _isBannerReady = false;

  @override
  void initState() {
    super.initState();
    _preloadBanner();
  }

  Future<void> _preloadBanner() async {
    _bannerController = BannerAdController(
      options: BannerAdOptions(
        adUnitId: 'your-ad-unit-id',
        size: BannerAdSize.adaptiveBanner,
        adaptiveBannerHeight: 60,
      ),
    );

    final success = await _bannerController!.preload();

    if (mounted) {
      setState(() => _isBannerReady = success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banner Example')),
      body: Column(
        children: [
          YourContent(),
          if (_isBannerReady && _bannerController != null)
            BannerAdWidget(
              controller: _bannerController,
              autoLoad: false,
              height: 60,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bannerController?.dispose();
    super.dispose();
  }
}
```

### Banner Size Examples

```dart
// Standard Banner (50dp)
BannerAdOptions(
  adUnitId: 'your-ad-unit-id',
  size: BannerAdSize.banner,
)
BannerAdWidget(height: 50)

// Full Banner (60dp)
BannerAdOptions(
  adUnitId: 'your-ad-unit-id',
  size: BannerAdSize.fullBanner,
)
BannerAdWidget(height: 60)

// Leaderboard (90dp)
BannerAdOptions(
  adUnitId: 'your-ad-unit-id',
  size: BannerAdSize.leaderboard,
)
BannerAdWidget(height: 90)

// Medium Rectangle (250dp) - High CTR
BannerAdOptions(
  adUnitId: 'your-ad-unit-id',
  size: BannerAdSize.mediumRectangle,
)
BannerAdWidget(height: 250)

// Adaptive Banner with custom height
BannerAdOptions(
  adUnitId: 'your-ad-unit-id',
  size: BannerAdSize.adaptiveBanner,
  adaptiveBannerHeight: 70, // Any height you want
)
BannerAdWidget(height: 70)

// Smart Banner (auto height)
BannerAdOptions(
  adUnitId: 'your-ad-unit-id',
  size: BannerAdSize.smartBanner,
)
BannerAdWidget(height: BannerAdSize.smartBanner.recommendedHeight)
```

## Controller API

Both `NativeAdController` and `BannerAdController` share the same API:

### Properties

```dart
// State
controller.id              // Unique controller ID
controller.state           // Current state (initial, loading, loaded, error)
controller.stateStream     // Stream of state changes
controller.isLoading       // Currently loading
controller.isLoaded        // Successfully loaded
controller.isPreloaded     // Preloaded
controller.hasError        // Has error
controller.errorMessage    // Error message
controller.errorCode       // Error code
```

### Methods

```dart
// Load ad
controller.loadAd()                    // Start loading (fire-and-forget)
await controller.preload()              // Load and wait for completion

// Reload ad
controller.reload()                     // Load new ad
controller.triggerSmartReload()         // Manually trigger smart reload

// Visibility (for smart reload)
controller.updateVisibility(true)       // Call when ad becomes visible
controller.updateVisibility(false)      // Call when ad becomes invisible

// Update configuration
controller.updateEvents(NativeAdEvents(...))  // Update event callbacks
controller.updateReloadInterval(60)          // Update reload interval

// Cleanup
controller.dispose()                    // Always call when done
```

## Test Ad Unit IDs

Use Google's test ad units during development:

### Native Ads
```dart
// Android
NativeAdOptions.testAndroid()  // Uses: ca-app-pub-3940256099942544/2247696110

// iOS
NativeAdOptions.testIOS()      // Uses: ca-app-pub-3940256099942544/3986624511

// Manual
NativeAdOptions(
  adUnitId: Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511',
)
```

### Banner Ads
```dart
// Android
BannerAdOptions.testBannerAndroid()  // Uses: ca-app-pub-3940256099942544/2934735716

// iOS
BannerAdOptions.testBannerIOS()      // Uses: ca-app-pub-3940256099942544/2934735716

// Manual
BannerAdOptions(
  adUnitId: Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2934735716'
      : 'ca-app-pub-3940256099942544/2934735716',
)
```

## Debugging

Enable debug logs to troubleshoot issues:

```dart
NativeAdOptions(
  adUnitId: 'your-ad-unit-id',
  enableDebugLogs: true,  // Enable detailed logging
)
```

Check platform logs:
- **Android:** `adb logcat | grep -i "ads"`
- **iOS:** Xcode Console, filter "GMA"

Common issues:
1. **Ads not showing** - Check AdMob App ID configuration
2. **Load failed** - Verify internet connection and ad unit ID format
3. **Test ads not loading** - Ensure test device ID is added
4. **Build errors** - Run `flutter clean && flutter pub get`

## Requirements

- **Flutter SDK:** >=3.3.0
- **Dart SDK:** >=3.0.0 <4.0.0
- **Android:** minSdk 21, compileSdk 34, targetSdk 34
- **iOS:** deployment target 13.0+
- **Google Mobile Ads SDK:** Android 23.0.0, iOS 11.0

## API Reference

### NativeAdOptions

```dart
NativeAdOptions({
  required String adUnitId,              // Required: Your ad unit ID
  NativeAdLayoutType layoutType,         // Default: form1
  NativeAdStyle style,                   // Optional: Custom style
  bool enableDebugLogs,                  // Default: false
  Duration requestTimeout,               // Optional: Request timeout
  Map<String, String> customExtras,      // Optional: Custom targeting
  List<String> testDeviceIds,            // Optional: Test devices
  bool enableSmartPreload,               // Enable smart preload
  bool enableSmartReload,                // Enable smart reload
  int reloadIntervalSeconds,             // Default: 30
  int retryDelaySeconds,                 // Default: 12
})
```

### BannerAdOptions

```dart
BannerAdOptions({
  required String adUnitId,              // Required: Your ad unit ID
  BannerAdSize size,                     // Default: adaptiveBanner
  int adaptiveBannerHeight,              // Custom height for adaptive
  bool enableDebugLogs,                  // Default: false
  bool enableSmartPreload,               // Enable smart preload
  bool enableSmartReload,                // Enable smart reload
  int reloadIntervalSeconds,             // Default: 30
  int retryDelaySeconds,                 // Default: 12
})
```

### NativeAdEvents

```dart
NativeAdEvents(
  VoidCallback? onAdLoaded,                    // Ad loaded successfully
  void Function(String error, int code)? onAdFailed,  // Ad failed to load
  VoidCallback? onAdClicked,                  // User clicked ad
  VoidCallback? onAdImpression,               // Impression recorded
  VoidCallback? onAdOpened,                   // Ad opened overlay
  VoidCallback? onAdClosed,                   // User returned to app
)
```

### BannerAdEvents

```dart
BannerAdEvents(
  VoidCallback? onAdLoaded,                    // Ad loaded successfully
  void Function(String error, int code)? onAdFailed,  // Ad failed to load
  VoidCallback? onAdClicked,                  // User clicked ad
  VoidCallback? onAdImpression,               // Impression recorded
  VoidCallback? onAdOpened,                   // Ad opened overlay
  VoidCallback? onAdClosed,                   // User returned to app
  void Function(double value, String currency)? onAdPaid,  // Revenue event
)
```

### NativeAdWidget

```dart
NativeAdWidget({
  required NativeAdOptions options,          // Required
  NativeAdController? controller,            // Optional: External controller
  double? height,                            // Required: Widget height
  double? width,                             // Optional: Widget width
  Widget? loadingWidget,                     // Custom loading UI
  Widget Function(String)? errorWidget,      // Custom error UI
  bool autoLoad = true,                      // Auto-load on init
  VoidCallback? onAdLoaded,
  void Function(String, int)? onAdFailed,
  VoidCallback? onAdClicked,
  VoidCallback? onAdImpression,
  VoidCallback? onAdOpened,
  VoidCallback? onAdClosed,
  double visibilityThreshold = 0.0,         // For smart reload (0.0-1.0)
})
```

### BannerAdWidget

```dart
BannerAdWidget({
  required BannerAdOptions options,          // Required
  BannerAdController? controller,            // Optional: External controller
  double? height,                            // Required: Widget height
  double? width,                             // Optional: Widget width
  Widget? loadingWidget,                     // Custom loading UI
  Widget Function(String)? errorWidget,      // Custom error UI
  bool autoLoad = true,                      // Auto-load on init
  VoidCallback? onAdLoaded,
  void Function(String, int)? onAdFailed,
  VoidCallback? onAdClicked,
  VoidCallback? onAdImpression,
  VoidCallback? onAdOpened,
  VoidCallback? onAdClosed,
  void Function(double, String)? onAdPaid,   // Revenue callback
  double visibilityThreshold = 0.0,         // For smart reload (0.0-1.0)
})
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- **Repository:** https://github.com/TQC-Solution/flutter_admob_native_ads
- **Issues:** Report via GitHub Issues
- **Pull Requests:** Welcome with detailed descriptions

---

Made with ❤️ by [TQC Solution](https://github.com/TQC-solution)
