# Flutter AdMob Native Ads

Production-ready Flutter plugin for displaying Google AdMob Native Ads with 12 customizable layout forms and SwiftUI-style declarative styling. 100% native rendering via Platform Views with full Android/iOS parity.

[![Version](https://img.shields.io/badge/version-1.0.2-blue.svg)](https://github.com/tqc/flutter_admob_native_ads)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Tính năng nổi bật

- **12 diverse layout forms** - Từ ngang 80dp đến dọc 320dp, tối ưu cho nhiều use case
- **30+ customizable style properties** - SwiftUI-style declarative API
- **Preload ads** - Tải quảng cáo trước để hiển thị tức thì
- **Smart Reload** - Tự động tải lại khi người dùng scroll
- **Full event lifecycle callbacks** - Theo dõi mọi sự kiện quảng cáo
- **Built-in themes** - Light, Dark, Minimal themes
- **100% native rendering** - Hiệu suất cao qua Platform Views
- **Production-ready** - Đã test toàn diện trên cả Android & iOS

## Công nghệ sử dụng

### Flutter Side
- **Widget**: `NativeAdWidget` (Stateful widget với lifecycle management)
- **Controller**: `NativeAdController` (Stream-based state management)
- **Models**: `NativeAdOptions`, `NativeAdStyle`, `NativeAdEvents`, `NativeAdLayoutType`

### Native Side

**Android:**
- Kotlin 1.9.22
- Google Mobile Ads SDK 23.0.0
- Min SDK 21, Compile SDK 34, Target SDK 34
- Platform Views (AndroidView) với 12 layout builders

**iOS:**
- Swift 5.0+
- Google Mobile Ads SDK 11.0
- iOS 13.0+ deployment target
- Platform Views (UIKitView) với 12 layout builders

### Architecture

```
┌─────────────────────────────────────┐
│   Flutter Layer (Dart)              │
│   - NativeAdWidget (stateful)       │
│   - NativeAdController (state mgmt) │
│   - Models: Options/Style/Events    │
└──────────────┬──────────────────────┘
               │ MethodChannel
               │ "flutter_admob_native_ads"
               ▼
┌─────────────────────────────────────┐
│   Platform Layer                    │
│   Android: Kotlin + GMA SDK 23.0.0  │
│   iOS: Swift + GMA SDK 11.0         │
│   - AdLoader (load ads)             │
│   - LayoutBuilders (12 forms)       │
│   - PlatformViews (rendering)       │
│   - StyleManager (apply styles)     │
└─────────────────────────────────────┘
```

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

## Cài đặt

### 1. Thêm dependency

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  flutter_admob_native_ads: ^1.0.2
```

Sau đó chạy:

```bash
flutter pub get
```

### 2. Android Setup

1. **Thêm AdMob App ID** vào `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

2. **Cấu hình Gradle** - Đảm bảo `minSdkVersion >= 21`:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### 3. iOS Setup

1. **Thêm AdMob App ID** vào `ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

2. **Initialize SDK** trong `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMobileAds
import UIKit

@main
class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Google Mobile Ads SDK
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

3. **Cập nhật Podfile**:

```ruby
platform :ios, '13.0'
pod 'Google-Mobile-Ads-SDK', '~> 11.0'
```

4. **Cài đặt pods**:

```bash
cd ios && pod install
```

## Các Layout Forms

Plugin cung cấp 12 layout được thiết kế sẵn (`form1` đến `form12`), tối ưu cho các use case khác nhau:

| Form | Chiều cao | Style | Dùng cho |
|------|-----------|-------|----------|
| **form1** | 80dp | Ngang compact | List items |
| **form2** | 90dp | Ngang có media | List với preview |
| **form3** | 320dp | Dọc story lớn | Feed cards |
| **form4** | 300dp | Dọc media-first | Product cards |
| **form5** | 300dp | Article card | Blog posts |
| **form6** | 280dp | Feed tiêu chuẩn | Standard feeds |
| **form7** | 140dp | Ngang video | Video ads |
| **form8** | 100dp | Ngang compact | Compact cards |
| **form9** | 240dp | CTA-first | CTA focused |
| **form10** | 120dp | Text-only | Minimal design |
| **form11** | 280dp | Dọc sạch | Clean layout |
| **form12** | 280dp | Dọc alternative | Alt layout |

### Ví dụ sử dụng các form

```dart
// Form 1 - Ngang compact (80dp)
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form1,
  ),
  height: NativeAdLayoutType.form1.recommendedHeight, // 80
)

// Form 6 - Feed tiêu chuẩn (280dp)
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
    style: NativeAdStyle.light(),
  ),
  height: NativeAdLayoutType.form6.recommendedHeight, // 280
)

// Form 3 - Full media (320dp)
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form3,
  ),
  height: NativeAdLayoutType.form3.recommendedHeight, // 320
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

### Các thuộc tính có thể tùy chỉnh

**CTA Button:** background, text color, font size/weight, corner radius, padding, border, elevation

**Container:** background, corner radius, padding, margin, border, shadow

**Text:** headline, body, price, store, advertiser (color, size, weight, font family, max lines)

**Media:** height, corner radius, aspect ratio, background

**Icon:** size, corner radius, border

**Star Rating:** size, active/inactive colors

**Ad Label:** visibility, text, colors, corner radius, padding

**Layout:** item spacing, section spacing

## Preload Ads

Tải quảng cáo trước khi hiển thị để người dùng thấy quảng cáo ngay lập tức mà không cần chờ loading spinner.

### Cách sử dụng Preload

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
    // Tạo controller với options
    _adController = NativeAdController(
      options: NativeAdOptions(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/2247696110'  // Test Android
            : 'ca-app-pub-3940256099942544/3986624511', // Test iOS
        layoutType: NativeAdLayoutType.form6,
        style: NativeAdStyle.light(),
      ),
    );

    // Preload ad và chờ kết quả
    final success = await _adController!.preload();

    if (mounted) {
      setState(() => _isAdReady = success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Nội dung khác của app...
          if (_isAdReady && _adController != null)
            NativeAdWidget(
              options: _adController!.options,
              controller: _adController,
              autoLoad: false,  // Quan trọng: không reload lại
              height: NativeAdLayoutType.form6.recommendedHeight,
            ),
        ],
      ),
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

| Tính năng | Preload (`preload()`) | Auto-load (`autoLoad: true`) |
|-----------|----------------------|------------------------------|
| Thời điểm tải | Khi gọi `preload()` | Khi widget được tạo |
| Chờ tải xong | ✅ Có (`await`) | ❌ Không (fire-and-forget) |
| Hiển thị | Ngay lập tức | Hiện loading spinner |
| Use case | UX tốt hơn, feeds | Nhanh & đơn giản |

### Khi nào nên dùng Preload?

- ✅ Khi muốn quảng cáo hiển thị ngay lập tức khi user scroll đến
- ✅ Trong list feeds, preload vài quảng cáo trước
- ✅ Khi cần kiểm tra quảng cáo load được trước khi hiển thị
- ✅ Để tránh flicker khi quảng cáo load

## Reload Native Ads

Tải lại quảng cáo mới để thay thế quảng cáo cũ hoặc khi load fail.

### Cách 1: Sử dụng Controller

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
      ),
      events: NativeAdEvents(
        onAdLoaded: () => print('Ad loaded'),
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
    return Column(
      children: [
        NativeAdWidget(
          options: _controller.options,
          controller: _controller,
        ),
        ElevatedButton(
          onPressed: () => _controller.reload(),
          child: Text('Reload Ad'),
        ),
      ],
    );
  }
}
```

### Cách 2: Smart Reload với Visibility

Tự động reload khi quảng cáo visible:

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
    enableSmartReload: true,  // Bật smart reload
  ),
  controller: _controller,
  visibilityThreshold: 0.5,  // Reload khi 50% visible
)
```

### Các phương thức của Controller

```dart
// Preload - Tải trước và chờ
final success = await controller.preload();

// LoadAd - Bắt đầu tải (không chờ)
controller.loadAd();

// Reload - Hủy quảng cáo cũ và tải mới
controller.reload();

// State getters
controller.isLoading;     // Đang tải
controller.isLoaded;      // Đã load thành công
controller.isPreloaded;   // Đã preload
controller.hasError;      // Có lỗi
controller.errorMessage;  // Thông báo lỗi
```

## Event Callbacks

Theo dõi toàn bộ lifecycle của quảng cáo:

```dart
NativeAdWidget(
  options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
  onAdLoaded: () => print('Ad loaded successfully'),
  onAdFailed: (error, code) => print('Error: $error ($code)'),
  onAdClicked: () => print('User clicked ad'),
  onAdImpression: () => print('Impression recorded'),
  onAdOpened: () => print('Ad opened overlay'),
  onAdClosed: () => print('User returned to app'),
)
```

Hoặc sử dụng với `NativeAdEvents`:

```dart
NativeAdController(
  options: NativeAdOptions(...),
  events: NativeAdEvents(
    onAdLoaded: () => debugPrint('Loaded'),
    onAdFailed: (error, code) => debugPrint('Failed: $error'),
    onAdClicked: () => analytics.logEvent('ad_clicked'),
    onAdImpression: () => analytics.logEvent('ad_impression'),
  ),
)
```

## Advanced Usage

### Custom Loading & Error Widgets

```dart
NativeAdWidget(
  options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
  loadingWidget: Center(
    child: Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 8),
        Text('Loading ad...'),
      ],
    ),
  ),
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

### Sử dụng với ListView/ScrollView

```dart
class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<NativeAdController> _adControllers = [];
  static const int _adInterval = 5; // Quảng cáo mỗi 5 items

  @override
  void initState() {
    super.initState();
    _preloadAds();
  }

  Future<void> _preloadAds() async {
    // Preload 3 quảng cáo đầu
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
      itemCount: 20, // Tổng items
      itemBuilder: (context, index) {
        // Hiển thị quảng cáo mỗi 5 items
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

## Test Ad Unit IDs

Sử dụng test ad units của Google trong quá trình development:

- **Android:** `ca-app-pub-3940256099942544/2247696110`
- **iOS:** `ca-app-pub-3940256099942544/3986624511`

Hoặc dùng helper constructors:

```dart
// Test Android
NativeAdOptions.testAndroid()

// Test iOS
NativeAdOptions.testIOS()

// Hoặc tự động
NativeAdOptions(
  adUnitId: Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511',
)
```

## Debugging

Bật debug logs:

```dart
NativeAdOptions(
  adUnitId: '...',
  enableDebugLogs: true,
)
```

Kiểm tra logs trên platform:

- **Android:** `adb logcat | grep -i ads`
- **iOS:** Xcode Console, filter "GMA"

## API Reference

### NativeAdOptions

Configuration class cho ad loading:

```dart
NativeAdOptions({
  required String adUnitId,        // Required
  NativeAdLayoutType layoutType,   // Default: form1
  NativeAdStyle style,             // Optional
  bool enableDebugLogs,            // Default: false
  Duration requestTimeout,         // Optional
  Map<String, String> customExtras, // Custom targeting
  List<String> testDeviceIds,      // Test devices
  bool enableSmartReload,          // Enable smart reload
})
```

### NativeAdController

State management cho ad lifecycle:

**Properties:**
- `id`: Unique controller ID
- `state`: Current ad state (initial, loading, loaded, error)
- `stateStream`: Stream of state changes
- `isLoading`, `isLoaded`, `isPreloaded`, `hasError`: State getters
- `errorMessage`, `errorCode`: Error information

**Methods:**
- `preload()`: Preload ad và chờ (returns `Future<bool>`)
- `loadAd()`: Trigger ad load (fire-and-forget)
- `reload()`: Reload current ad
- `dispose()`: Clean up resources

### NativeAdWidget

Main widget hiển thị ads:

```dart
NativeAdWidget({
  required NativeAdOptions options,  // Required
  NativeAdController controller,     // Optional
  double height,                    // Optional
  double width,                     // Optional
  Widget loadingWidget,             // Custom loading UI
  Widget Function(String) errorWidget, // Custom error UI
  bool autoLoad,                    // Default: true
  VoidCallback onAdLoaded,
  void Function(String, int) onAdFailed,
  VoidCallback onAdClicked,
  VoidCallback onAdImpression,
  VoidCallback onAdOpened,
  VoidCallback onAdClosed,
  double visibilityThreshold,        // For smart reload
})
```

## Requirements

- **Flutter SDK:** >=3.3.0
- **Dart SDK:** >=3.0.0 <4.0.0
- **Android:** minSdk 21, compileSdk 34, targetSdk 34
- **iOS:** 13.0+ deployment target
- **Google Mobile Ads SDK:**
  - Android: 23.0.0
  - iOS: 11.0

## Troubleshooting

### Quảng cáo không hiển thị

1. Kiểm tra AdMob configuration (app ID, ad unit ID format)
2. Kiểm tra kết nối internet
3. Bật debug logs: `enableDebugLogs: true`
4. Sử dụng test ad unit IDs
5. Kiểm tra platform logs (logcat/Xcode)

### Build Errors

**Android:**
- Đảm bảo `minSdkVersion >= 21`
- Chạy `flutter clean && flutter pub get`
- Kiểm tra Kotlin version (1.9.22)

**iOS:**
- Đảm bảo deployment target >= 13.0
- Chạy `pod update` nếu cần
- Kiểm tra Swift version (5.0+)
- Xóa `Pods` folder và `Podfile.lock`, chạy `pod install` lại

### Common Issues

- **No internet:** Đảm bảo device/emulator có kết nối
- **Wrong ad unit:** Kiểm tra format `ca-app-pub-...`
- **Not approved:** Dùng test IDs trong development
- **Emulator:** Thêm vào test devices list

## Architecture

**Three-Layer Architecture:**

```
┌─────────────────────────────────────┐
│   Flutter Layer (Dart)              │
│   - NativeAdWidget (stateful)       │
│   - NativeAdController (state mgmt) │
│   - Models: Options/Style/Events    │
└──────────────┬──────────────────────┘
               │ MethodChannel
               │ "flutter_admob_native_ads"
               ▼
┌─────────────────────────────────────┐
│   Platform Layer                    │
│   Android: Kotlin + GMA SDK 23.0.0  │
│   iOS: Swift + GMA SDK 11.0         │
│   - AdLoader (load ads)             │
│   - LayoutBuilders (12 forms)       │
│   - PlatformViews (rendering)       │
│   - StyleManager (apply styles)     │
└─────────────────────────────────────┘
```

**Key Points:**
- 100% native rendering via Platform Views
- Full parity giữa Android và iOS
- All styling applied natively (no Flutter wrappers)
- Method channel communication cho ad loading/events

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
