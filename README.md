# Flutter AdMob Native Ads

Production-ready Flutter plugin for displaying Google AdMob Native Ads with 12 customizable layout forms and SwiftUI-style declarative styling. 100% native rendering via Platform Views with full Android/iOS parity.

[![Version](https://img.shields.io/badge/version-1.0.2-blue.svg)](https://github.com/tqc/flutter_admob_native_ads)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**Key Features:**
- 🎨 12 diverse layout forms (80dp-320dp)
- 🎯 30+ customizable style properties
- ⚡ Preload ads for instant display
- 🔄 Full event lifecycle callbacks
- 🌓 Built-in themes (light, dark, minimal)
- 📱 100% native rendering
- ✅ Production-ready with comprehensive tests

## Quick Start

```dart
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'ca-app-pub-xxx/xxx',
    layoutType: NativeAdLayoutType.form1,
    style: NativeAdStyle.light(),
  ),
  onAdLoaded: () => print('Ad loaded'),
  onAdFailed: (error) => print('Error: $error'),
)
```

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_admob_native_ads: ^1.0.2
```

### Android Setup

1. Add AdMob App ID to `AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

### iOS Setup

1. Add AdMob App ID to `Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

2. Initialize SDK in `AppDelegate.swift`:

```swift
import GoogleMobileAds

@main
@objc class AppDelegate: FlutterAppDelegate {
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

3. Add to `Podfile`:

```ruby
platform :ios, '13.0'
pod 'Google-Mobile-Ads-SDK', '~> 11.0'
```

## Layout Forms

12 pre-designed layouts optimized for different use cases:

| Form | Height | Style | Best For |
|------|--------|-------|----------|
| form1 | 80dp | Horizontal compact | List items |
| form2 | 90dp | Horizontal media | List with media preview |
| form3 | 320dp | Vertical story | Feed cards |
| form4 | 300dp | Media-first vertical | Product cards |
| form5 | 300dp | Article card | Blog posts |
| form6 | 280dp | Standard feed | Standard feeds |
| form7 | 140dp | Horizontal video | Video ads |
| form8 | 100dp | Compact horizontal | Compact cards |
| form9 | 280dp | Action-first | CTA focused |
| form10 | 120dp | Text-only | Minimal design |
| form11 | 280dp | Clean vertical | Clean layout |
| form12 | 280dp | Alternative vertical | Alt layout |

> **Visual Reference:** See [ads_template_native/](ads_template_native/) for design templates

### Usage Examples

```dart
// Compact horizontal (80dp)
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form1,
  ),
  height: 80,
)

// Standard feed card (280dp)
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
  ),
  height: 280,
)

// Full media vertical (320dp)
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form3,
  ),
  height: 320,
)
```

## Styling

### Built-in Themes

```dart
// Light theme
NativeAdStyle.light()

// Dark theme
NativeAdStyle.dark()

// Minimal theme
NativeAdStyle.minimal()
```

### Custom Styling

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
    style: NativeAdStyle(
      // CTA Button
      ctaBackgroundColor: Colors.blue,
      ctaTextColor: Colors.white,
      ctaCornerRadius: 8,
      ctaPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      // Container
      containerBackgroundColor: Colors.white,
      containerCornerRadius: 12,
      containerPadding: EdgeInsets.all(12),
      containerBorderColor: Colors.blue[200],
      containerBorderWidth: 2,

      // Text
      headlineTextColor: Colors.black,
      headlineFontSize: 16,
      headlineFontWeight: FontWeight.w600,
      bodyTextColor: Colors.grey[600]!,

      // Media
      mediaViewHeight: 200,
      mediaViewCornerRadius: 8,

      // Icon
      iconSize: 48,
      iconCornerRadius: 8,
    ),
  ),
)
```

### Available Style Properties

**CTA Button:** background, text color, font size/weight, corner radius, padding, border, elevation

**Container:** background, corner radius, padding, margin, border, shadow

**Text:** headline, body, price, store, advertiser (color, size, weight, font family, max lines)

**Media:** height, corner radius, aspect ratio, background

**Icon:** size, corner radius, border

**Star Rating:** size, active/inactive colors

**Ad Label:** visibility, text, colors, corner radius, padding

**Layout:** item spacing, section spacing

## Preload Ads (NEW in v1.0.2)

Load ads before displaying for instant appearance - eliminates loading spinners!

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
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/2247696110'
            : 'ca-app-pub-3940256099942544/3986624511',
        layoutType: NativeAdLayoutType.form6,
      ),
    );

    final success = await _adController!.preload();

    if (mounted) {
      setState(() => _isAdReady = success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isAdReady && _adController != null)
          NativeAdWidget(
            options: _adController!.options,
            controller: _adController,
            autoLoad: false,  // Important: don't reload
            height: NativeAdLayoutType.form6.recommendedHeight,
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

### Preload vs Auto-load

| Feature | Preload (`preload()`) | Auto-load (`autoLoad: true`) |
|---------|----------------------|------------------------------|
| Load timing | When calling `preload()` | When widget created |
| Wait for load | ✅ Yes (`await`) | ❌ No (fire-and-forget) |
| Display | Instant | Shows loading spinner |
| Use case | Better UX, feeds | Quick & simple |

## Event Callbacks

```dart
NativeAdWidget(
  options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
  onAdLoaded: () => print('Ad loaded'),
  onAdFailed: (error, code) => print('Error: $error ($code)'),
  onAdClicked: () => print('Ad clicked'),
  onAdImpression: () => print('Impression recorded'),
)
```

## Advanced Usage with Controller

```dart
class _MyWidgetState extends State<MyWidget> {
  late NativeAdController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NativeAdController(
      options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
      events: NativeAdEvents(
        onAdLoaded: () => print('Loaded'),
        onAdFailed: (error, code) => print('Failed: $error'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NativeAdWidget(
      options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
      controller: _controller,
    );
  }

  void reloadAd() {
    _controller.reload();
  }
}
```

**Controller Features:**
- State management with `Stream<NativeAdState>`
- Getters: `isLoading`, `isLoaded`, `isPreloaded`, `hasError`, `errorMessage`, `errorCode`
- Methods: `preload()`, `loadAd()`, `reload()`, `dispose()`

## Custom Loading & Error Widgets

```dart
NativeAdWidget(
  options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
  loadingWidget: Center(
    child: CircularProgressIndicator(),
  ),
  errorWidget: (error) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline),
        Text('Ad not available'),
      ],
    ),
  ),
)
```

## Test Ad Unit IDs

Use Google's test ad units during development:

- **Android:** `ca-app-pub-3940256099942544/2247696110`
- **iOS:** `ca-app-pub-3940256099942544/3986624511`

Or use helper constructors:

```dart
NativeAdOptions.testAndroid()
NativeAdOptions.testIOS()
```

## Debugging

Enable debug logs:

```dart
NativeAdOptions(
  adUnitId: '...',
  enableDebugLogs: true,
)
```

Check platform logs:
- **Android:** `adb logcat | grep -i ads`
- **iOS:** Xcode Console, filter "GMA"

## API Reference

### NativeAdLayoutType

Enum with 12 layout options (form1-form12). Each has:
- `recommendedHeight`: Suggested height in logical pixels
- `viewType`: Platform view identifier
- `toInt()` / `fromInt()`: Convert to/from integer

### NativeAdOptions

Configuration class for ad loading:
- `adUnitId`: AdMob ad unit ID (required)
- `layoutType`: Layout form (default: form1)
- `style`: Style configuration (optional)
- `enableDebugLogs`: Enable verbose logging (default: false)
- `requestTimeout`: Ad load timeout (optional)
- `customExtras`: Custom targeting parameters (optional)
- `testDeviceIds`: Test device IDs (optional)

**Factory Constructors:**
- `NativeAdOptions.testAndroid()`: Google test unit for Android
- `NativeAdOptions.testIOS()`: Google test unit for iOS

### NativeAdStyle

30+ style properties with SwiftUI-style API:
- CTA button properties
- Container properties
- Text styling (headline, body, price, store, advertiser)
- Media view configuration
- Icon styling
- Star rating colors
- Ad label customization
- Layout spacing

**Theme Presets:**
- `NativeAdStyle.light()`: Clean light theme
- `NativeAdStyle.dark()`: Dark mode theme
- `NativeAdStyle.minimal()`: Minimal design

### NativeAdController

State management for ad lifecycle:
- `id`: Unique controller ID
- `state`: Current ad state (initial, loading, loaded, error)
- `stateStream`: Stream of state changes
- `isLoading`, `isLoaded`, `isPreloaded`, `hasError`: State getters
- `errorMessage`, `errorCode`: Error information
- `preload()`: Preload ad and wait (returns bool)
- `loadAd()`: Trigger ad load
- `reload()`: Reload current ad
- `dispose()`: Clean up resources

### NativeAdWidget

Main widget for displaying ads:
- `options`: Ad configuration (required)
- `height`, `width`: Widget dimensions (optional)
- `loadingWidget`: Custom loading UI (optional)
- `errorWidget`: Custom error UI (optional)
- `controller`: External controller (optional)
- `onAdLoaded`, `onAdFailed`, `onAdClicked`, `onAdImpression`: Callbacks
- `autoLoad`: Auto-load on init (default: true)

## Requirements

- Flutter SDK: >=3.3.0
- Dart SDK: >=3.0.0 <4.0.0
- Android: minSdk 21, compileSdk 34
- iOS: 13.0+
- Google Mobile Ads SDK: 23.0.0 (Android), 11.0 (iOS)

## Troubleshooting

### Ads Not Showing

1. Verify AdMob configuration (app ID, ad unit ID format)
2. Check internet connection
3. Enable debug logs: `enableDebugLogs: true`
4. Use test ad unit IDs
5. Check platform logs (logcat/Xcode)

### Build Errors

**Android:**
- Ensure `minSdkVersion >= 21`
- Run `flutter clean && flutter pub get`

**iOS:**
- Ensure deployment target >= 13.0
- Run `pod update` if needed
- Check Swift version (5.0+)

### Common Issues

- **No internet:** Ensure device/emulator has connectivity
- **Wrong ad unit:** Verify format `ca-app-pub-...`
- **Not approved:** Use test IDs during development
- **Emulator:** Add to test devices list

## Architecture

```
Flutter Layer (Dart)
├── NativeAdWidget (stateful widget)
├── NativeAdController (state management)
└── Models (Options, Style, Events)
         ↓ MethodChannel
Native Layer (Kotlin/Swift)
├── AdLoader (load ads from Google)
├── LayoutBuilders (12 forms)
├── PlatformViews (rendering)
└── StyleManager (apply styles)
```

**Key Points:**
- 100% native rendering via Platform Views
- Full parity between Android and iOS
- All styling applied natively (no Flutter wrappers)
- Method channel communication for ad loading/events

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- **Repository:** https://github.com/tqc/flutter_admob_native_ads
- **Issues:** Report via GitHub Issues
- **Pull Requests:** Welcome with detailed descriptions

---

Made with ❤️ by [TQC Solution](https://github.com/TQC-Solution)
