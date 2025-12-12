# Flutter AdMob Native Ads

Plugin Flutter sẵn sàng sản xuất cho phép hiển thị Google AdMob Native Ads với bố cục có thể tùy chỉnh cao và kiểu khai báo theo phong cách SwiftUI. Cung cấp rendering 100% native thông qua Platform Views với parity đầy đủ giữa các triển khai Android và iOS.

**Phiên bản:** 1.0.0
**Giấy phép:** MIT
**Repository:** https://github.com/tqc/flutter_admob_native_ads

## Các tính năng

- **3 Loại bố cục Responsive**: Compact (120-150dp), Standard (250-300dp), Full Media (350-400dp)
- **Kiểu dáng Toàn diện**: 30+ thuộc tính có thể tùy chỉnh cho mọi thành phần giao diện
- **API Khai báo kiểu SwiftUI**: Cấu hình kiểu dáng sạch sẽ, dễ đọc, an toàn với kiểu
- **100% Native Rendering**: Platform Views với triển khai native Android và iOS
- **Vòng đời Sự kiện Đầy đủ**: Theo dõi các sự kiện tải ad, impression, click và thay đổi trạng thái overlay
- **Giao diện Nội dung Có sẵn**: Light, Dark và Minimal presets với tùy chỉnh dễ dàng
- **Quản lý trạng thái**: NativeAdController tích hợp để kiểm soát vòng đời nâng cao
- **Sẵn sàng sản xuất**: Bảo phủ kiểm tra toàn diện, xử lý lỗi và ghi nhật ký gỡ lỗi
- **Parity Đa nền tảng**: Hành vi và kiểu dáng giống nhau trên Android 21+ và iOS 13.0+

## Cài đặt

Thêm vào `pubspec.yaml` của bạn:

```yaml
dependencies:
  flutter_admob_native_ads:
    path: packages/flutter_admob_native_ads
```

### Cấu hình Android

1. Thêm ID ứng dụng AdMob của bạn vào `AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

2. Thêm dependency vào `build.gradle` của ứng dụng nếu chưa được tự động giải quyết:

```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-ads:23.0.0'
}
```

### Cấu hình iOS

1. Thêm ID ứng dụng AdMob của bạn vào `Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
```

2. Thêm vào `Podfile` của bạn:

```ruby
pod 'Google-Mobile-Ads-SDK', '~> 11.0'
```

## Khởi động nhanh

```dart
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

// Simple usage
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'ca-app-pub-xxx/xxx',
    layoutType: NativeAdLayoutType.standard,
    style: NativeAdStyle.light(),
  ),
  onAdLoaded: () => print('Ad loaded'),
  onAdFailed: (error) => print('Error: $error'),
)
```

## Các loại bố cục

### Compact (120-150dp)
Bố cục tối giản lý tưởng cho các mục danh sách và tích hợp feed.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.compact,
  ),
)
```

### Standard (250-300dp)
Bố cục cân bằng với chế độ xem phương tiện, phù hợp với hầu hết các trường hợp sử dụng.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.standard,
  ),
)
```

### Full Media (350-400dp)
Bố cục phong phú tập trung vào phương tiện cho các vị trí mức độ tham gia cao.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.fullMedia,
  ),
)
```

## Kiểu dáng tùy chỉnh

### Sử dụng các Giao diện có sẵn

```dart
// Giao diện sáng
NativeAdStyle.light()

// Giao diện tối
NativeAdStyle.dark()

// Kiểu dáng tối giản
NativeAdStyle.minimal()
```

### Kiểu dáng tùy chỉnh

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.standard,
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
      containerShadowColor: Colors.black.withOpacity(0.1),
      containerShadowRadius: 8,

      // Text Styles
      headlineTextColor: Colors.black,
      headlineFontSize: 16,
      headlineFontWeight: FontWeight.w600,

      bodyTextColor: Colors.grey[600]!,
      bodyFontSize: 14,

      // Media View
      mediaViewHeight: 200,
      mediaViewCornerRadius: 8,

      // Icon
      iconSize: 48,
      iconCornerRadius: 8,

      // Star Rating
      starRatingSize: 16,
      starRatingActiveColor: Colors.amber,

      // Ad Label
      showAdLabel: true,
      adLabelText: 'Ad',
      adLabelBackgroundColor: Colors.amber,
    ),
  ),
)
```

## Gọi lại sự kiện

```dart
NativeAdWidget(
  options: NativeAdOptions(adUnitId: 'your-ad-unit-id'),
  onAdLoaded: () {
    print('Ad loaded successfully');
  },
  onAdFailed: (error) {
    print('Ad failed: $error');
  },
  onAdClicked: () {
    print('Ad clicked');
  },
  onAdImpression: () {
    print('Ad impression recorded');
  },
)
```

## Sử dụng NativeAdController

Để kiểm soát nhiều hơn vòng đời quảng cáo:

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

## Trạng thái tải và lỗi

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

## ID đơn vị quảng cáo kiểm tra

Để kiểm tra, hãy sử dụng ID đơn vị quảng cáo kiểm tra của Google:

- **Android**: `ca-app-pub-3940256099942544/2247696110`
- **iOS**: `ca-app-pub-3940256099942544/3986624511`

```dart
// Sử dụng các hàm tạo kiểm tra
NativeAdOptions.testAndroid()
NativeAdOptions.testIOS()
```

## Tham khảo API

### Hệ thống phân cấp lớp hoàn chỉnh

```
flutter_admob_native_ads/
├── Models
│   ├── NativeAdLayoutType (Enum)
│   ├── NativeAdOptions
│   ├── NativeAdStyle
│   ├── NativeAdEvents
│   └── Various event typedefs
├── Controllers
│   └── NativeAdController
├── Widgets
│   └── NativeAdWidget
└── Utils
    ├── ColorExtension
    └── EdgeInsetsExtension
```

### NativeAdLayoutType

Enum với ba tùy chọn bố cục responsive:

| Loại | Phạm vi chiều cao | Trường hợp sử dụng được đề xuất | Loại chế độ xem |
|------|--------------|---------------------|-----------|
| `compact` | 120-150dp | Mục danh sách, tích hợp feed, quảng cáo sidebar | `native_ad_view_compact` |
| `standard` | 250-300dp | Mục đích chung, ngắt nội dung, trong feed | `native_ad_view_standard` |
| `fullMedia` | 350-400dp | Vị trí cao cấp, dưới bài viết, mức độ tham gia cao | `native_ad_view_fullMedia` |

**Các phương thức chính:**
- `toInt()`: Trả về số nhận dạng số nguyên (1, 2, 3)
- `fromInt(int)`: Phân tích cú pháp số nguyên thành loại bố cục (mặc định là standard)
- `recommendedHeight`: Trả về Map với giá trị chiều cao min/max
- `viewType`: Trả về chuỗi nhận dạng chế độ xem nền tảng

### NativeAdOptions

Lớp cấu hình để tải quảng cáo và hành vi.

| Thuộc tính | Loại | Mặc định | Mô tả |
|----------|------|---------|-------------|
| `adUnitId` | String | bắt buộc | ID đơn vị quảng cáo Google AdMob (định dạng: `ca-app-pub-...`) |
| `layoutType` | NativeAdLayoutType | standard | Một trong: compact, standard, fullMedia |
| `style` | NativeAdStyle? | null | Cấu hình kiểu dáng; sử dụng mặc định nếu null |
| `enableDebugLogs` | bool | false | Bật ghi nhật ký chi tiết Logcat/console |
| `requestTimeout` | Duration? | null | Thời gian chờ tải quảng cáo |
| `customExtras` | Map<String, String>? | null | Các tham số nhắm mục tiêu tùy chỉnh |
| `testDeviceIds` | List<String>? | null | Danh sách ID thiết bị kiểm tra để kiểm tra quảng cáo |

**Các hàm tạo Factory:**
- `NativeAdOptions.testAndroid()`: Sử dụng đơn vị quảng cáo kiểm tra của Google cho Android
- `NativeAdOptions.testIOS()`: Sử dụng đơn vị quảng cáo kiểm tra của Google cho iOS

**Các phương thức chính:**
- `isValidAdUnitId()`: Xác thực định dạng đơn vị quảng cáo
- `toMap()`: Tuần tự hóa thành Map kênh nền tảng
- `copyWith()`: Tạo bản sao với các thuộc tính đã sửa đổi

### NativeAdStyle

Cấu hình kiểu dáng toàn diện với hơn 30+ thuộc tính. API khai báo lấy cảm hứng từ SwiftUI.

#### Thuộc tính nút CTA
```dart
ctaBackgroundColor: Color        // Nền nút
ctaTextColor: Color              // Màu văn bản nút
ctaFontSize: double              // Kích thước văn bản (mặc định: 14)
ctaFontWeight: FontWeight        // Độ dày phông
ctaCornerRadius: double          // Bán kính viền
ctaPadding: EdgeInsets           // Phần đệm nội bộ
ctaBorderColor: Color?           // Màu viền cho kiểu ngoài
ctaBorderWidth: double?          // Độ dày viền
ctaElevation: double?            // Độ cao Android
```

#### Thuộc tính Container
```dart
containerBackgroundColor: Color
containerCornerRadius: double
containerPadding: EdgeInsets
containerMargin: EdgeInsets
containerBorderColor: Color?
containerBorderWidth: double?
containerShadowColor: Color?
containerShadowRadius: double?
containerShadowOffset: Offset?
```

#### Thuộc tính Văn bản (Headline, Body, Price, Store, Advertiser)
```dart
headlineTextColor: Color
headlineFontSize: double
headlineFontWeight: FontWeight
headlineFontFamily: String?
headlineMaxLines: int?

// Các thuộc tính tương tự cho:
// - bodyTextColor, bodyFontSize, bodyFontWeight, v.v.
// - priceTextColor, priceFontSize, v.v.
// - storeTextColor, storeFontSize, v.v.
// - advertiserTextColor, advertiserFontSize, v.v.
```

#### Thuộc tính Chế độ xem Phương tiện
```dart
mediaViewHeight: double?        // Chiều cao của chế độ xem phương tiện
mediaViewCornerRadius: double?  // Bán kính viền
mediaViewAspectRatio: double?   // Ràng buộc tỷ lệ khung hình
mediaViewBackgroundColor: Color?
```

#### Thuộc tính Biểu tượng
```dart
iconSize: double?
iconCornerRadius: double?
iconBorderColor: Color?
iconBorderWidth: double?
```

#### Thuộc tính Xếp hạng Sao
```dart
starRatingSize: double?
starRatingActiveColor: Color?
starRatingInactiveColor: Color?
```

#### Thuộc tính Nhãn quảng cáo
```dart
showAdLabel: bool
adLabelText: String?
adLabelTextColor: Color?
adLabelBackgroundColor: Color?
adLabelCornerRadius: double?
adLabelPadding: EdgeInsets?
```

#### Khoảng cách Bố cục
```dart
itemSpacing: double?           // Khoảng cách giữa các phần tử giao diện
sectionSpacing: double?        // Khoảng cách giữa các phần
```

**Các hàm tạo Giao diện Nội dung:**
- `NativeAdStyle.light()`: Giao diện sáng sạch sẽ với các màu chuyên nghiệp
- `NativeAdStyle.dark()`: Giao diện tối cho giao diện tối
- `NativeAdStyle.minimal()`: Kiểu dáng tối giản để tích hợp tinh tế

**Các phương thức chính:**
- `toMap()`: Tuần tự hóa tất cả các thuộc tính để giao tiếp trên nền tảng
- `copyWith()`: Tạo bản sao đã sửa đổi của kiểu dáng

### NativeAdEvents

Vùng chứa cho tất cả các gọi lại vòng đời quảng cáo.

```dart
class NativeAdEvents {
  final OnAdLoadedCallback? onAdLoaded;              // Quảng cáo tải thành công
  final OnAdFailedCallback? onAdFailed;              // Tải quảng cáo không thành công
  final OnAdClickedCallback? onAdClicked;            // Người dùng nhấp vào quảng cáo
  final OnAdImpressionCallback? onAdImpression;      // Impression được ghi lại
  final OnAdOpenedCallback? onAdOpened;              // Quảng cáo đã mở overlay
  final OnAdClosedCallback? onAdClosed;              // Quảng cáo đã đóng overlay
}
```

**Chữ ký sự kiện:**
```dart
// Quảng cáo tải thành công
typedef OnAdLoadedCallback = void Function();

// Tải quảng cáo không thành công với thông báo lỗi và mã lỗi
typedef OnAdFailedCallback = void Function(String error, int errorCode);

// Người dùng nhấp vào quảng cáo
typedef OnAdClickedCallback = void Function();

// Impression được ghi lại (lượt xem quảng cáo được tính)
typedef OnAdImpressionCallback = void Function();

// Quảng cáo mở overlay toàn màn hình
typedef OnAdOpenedCallback = void Function();

// Quảng cáo đóng overlay
typedef OnAdClosedCallback = void Function();
```

### NativeAdController

Quản lý trạng thái cho vòng đời quảng cáo và chức năng tải lại.

```dart
class NativeAdController {
  // Thuộc tính
  String get id                           // ID bộ điều khiển duy nhất
  NativeAdState get state                 // Trạng thái hiện tại
  Stream<NativeAdState> get stateStream   // Luồng thay đổi trạng thái
  bool get isLoading                      // Đang tải hiện tại
  bool get isLoaded                       // Tải thành công
  bool get hasError                       // Tải không thành công
  String? get errorMessage                // Mô tả lỗi
  int? get errorCode                      // Mã lỗi trình quản lý quảng cáo

  // Phương thức
  Future<void> loadAd()                   // Kích hoạt tải quảng cáo
  Future<void> reload()                   // Tải lại quảng cáo hiện có
  void dispose()                          // Dọn dẹp tài nguyên
}
```

**Enum NativeAdState:**
- `initial`: Trạng thái ban đầu trước khi tải
- `loading`: Tải đang diễn ra
- `loaded`: Tải thành công
- `error`: Tải không thành công

### NativeAdWidget

Widget chính để hiển thị quảng cáo với quản lý trạng thái đầy đủ.

**Tham số:**
```dart
NativeAdWidget(
  // Bắt buộc
  options: NativeAdOptions,                    // Cấu hình quảng cáo

  // Giao diện tùy chọn
  height: double?,                             // Chiều cao widget
  width: double?,                              // Chiều rộng widget
  loadingWidget: Widget?,                      // Giao diện tải tùy chỉnh
  errorWidget: Widget Function(String)?,       // Giao diện lỗi tùy chỉnh

  // Bộ điều khiển tùy chọn
  controller: NativeAdController?,             // Bộ điều khiển bên ngoài

  // Gọi lại tùy chọn
  onAdLoaded: VoidCallback?,
  onAdFailed: Function(String, int)?,
  onAdClicked: VoidCallback?,
  onAdImpression: VoidCallback?,

  // Hành vi tùy chọn
  autoLoad: bool = true,                       // Tự động tải khi khởi tạo
)
```

### Tiện ích mở rộng

#### ColorExtension
```dart
// Chuyển Color thành chuỗi hex
Color(0xFF1E88E5).toHex()           // Trả về "#1E88E5"
Color(0xFF1E88E5).toHexWithAlpha()  // Trả về "#FF1E88E5"

// Chuyển chuỗi hex thành Color
"#1E88E5".toColor()                 // Trả về Color
"#FF1E88E5".toColor()               // Phân tích với alpha
"1E8".toColor()                     // Hỗ trợ hex 3 chữ số
```

#### EdgeInsetsExtension
```dart
// Chuyển EdgeInsets thành Map/List
EdgeInsets.all(16).toMap()          // {top: 16, left: 16, bottom: 16, right: 16}
EdgeInsets.all(16).toList()         // [16, 16, 16, 16]

// Chuyển Map thành EdgeInsets
{"top": 16, "left": 16, "bottom": 16, "right": 16}.toEdgeInsets()
```

## Kiến trúc & Triển khai

### Kiến trúc Plugin

```
Giao tiếp Platform Channel:
┌─────────────────────────────────────┐
│     Lớp Flutter (Dart)              │
│  - NativeAdWidget                   │
│  - NativeAdController               │
│  - NativeAdOptions/Style/Events     │
└────────────┬────────────────────────┘
             │ MethodChannel
             │ "flutter_admob_native_ads"
             ▼
┌─────────────────────────────────────┐
│     Lớp Native                      │
│  Android: Kotlin + Google Ads SDK   │
│  iOS: Swift + Google Mobile Ads     │
│  - Các phiên bản AdLoader           │
│  - Layout Builders (3 loại)         │
│  - Platform Views                   │
└─────────────────────────────────────┘
```

### Chi tiết triển khai Native

#### Android (Kotlin)

**Các thành phần chính:**
- `FlutterAdmobNativeAdsPlugin`: Điểm vào plugin và trình xử lý phương thức
- `NativeAdLoader`: Bao bọc API `AdLoader` của Google, quản lý vòng đời tải
- `AdLayoutBuilder`: Mô hình Factory để tạo các chế độ xem dành riêng cho bố cục
  - `Form1Builder`: Bố cục ngang compact
  - `Form2Builder`: Bố cục dọc tiêu chuẩn
  - `Form3Builder`: Bố cục phương tiện nổi bật
- `NativeAdPlatformView`: Triển khai PlatformView tùy chỉnh
- `NativeAdViewFactory`: Tạo các phiên bản chế độ xem nền tảng
- `AdStyleManager`: Áp dụng kiểu dáng cho các chế độ xem native
- `ColorUtils` & `DimensionUtils`: Các hàm tiện ích nền tảng

**Thư viện chính:**
- Google Mobile Ads SDK 23.0.0
- Kotlin Coroutines 1.7.3
- Min SDK: 21, Compile SDK: 34

**Phương thức Method Channel:**
- `loadAd`: Tải quảng cáo với các tùy chọn
- `reloadAd`: Tải lại quảng cáo hiện có
- `disposeAd`: Dọn dẹp tài nguyên
- `getPlatformVersion`: Thông tin phiên bản

**Luồng sự kiện:**
1. Flutter gọi `loadAd()` qua MethodChannel
2. Plugin tạo/lấy phiên bản `NativeAdLoader`
3. `AdLoader.loadAd()` yêu cầu từ Google Ad Manager
4. Nhận gọi lại: `onAdLoaded`, `onAdFailedToLoad`, `onAdClicked`, v.v.
5. Gửi sự kiện trở lại Flutter dưới dạng kết quả channel phương thức

#### iOS (Swift)

**Các thành phần chính:**
- `FlutterAdmobNativeAdsPlugin`: Điểm vào plugin, trình xử lý phương thức
- `NativeAdLoader`: Bao bọc `GADAdLoader` của Google, quản lý vòng đời
- `AdLayoutBuilder`: Factory cho các phân cấp UIView dành riêng cho bố cục
  - `Form1Builder`: Stack ngang compact
  - `Form2Builder`: Stack dọc tiêu chuẩn
  - `Form3Builder`: Stack tập trung vào phương tiện đầy đủ
- `NativeAdPlatformView`: PlatformView tùy chỉnh với phân cấp UIView
- `NativeAdViewFactory`: Tạo các phiên bản chế độ xem nền tảng
- `AdStyleManager`: Áp dụng kiểu dáng thông qua auto layout và thuộc tính
- `ColorExtension`: Chuyển đổi hex màu
- `ConstraintBuilder`: Các tiện ích xây dựng ràng buộc auto layout

**Thư viện chính:**
- Google-Mobile-Ads-SDK ~> 11.0
- Mục tiêu triển khai tối thiểu: iOS 13.0
- Kê khai quyền riêng tư (PrivacyInfo.xcprivacy) cho tuân thủ iOS 17+

**Phương thức Method Channel & Sự kiện giống với Android**

### Kiến trúc Layout Builders

Mỗi layout builder tuân theo cùng một mô hình:

```
Layout Builder
├── Tạo hệ thống phân cấp UIView/ViewGroup
├── Áp dụng AdStyleOptions (màu sắc, kích thước, khoảng cách)
├── Ràng buộc dữ liệu GADNativeAd/NativeAd
│   ├── Hình ảnh biểu tượng
│   ├── Văn bản tiêu đề
│   ├── Văn bản nội dung (mô tả)
│   ├── Chế độ xem phương tiện (hình ảnh/video)
│   ├── Nút gọi hành động
│   ├── Xếp hạng sao
│   └── Nhãn cửa hàng/Nhà quảng cáo
└── Trả về chế độ xem được cấu hình sẵn sàng để hiển thị
```

### Mô hình Quản lý trạng thái

```
Widget → Controller → MethodChannel → Native
  ↓         ↓            ↓              ↓
 build   loadAd()   invokeMethod     AdLoader
         stateStream  (result)       callbacks
            ↓         ←─────────────────┘
         setState
           ↓
       rebuild
```

### Xử lý lỗi

Lỗi được lan truyền thông qua:
1. Gọi lại `onAdFailed` với thông báo lỗi và mã lỗi
2. Thuộc tính `NativeAdController.hasError`, `errorMessage`, `errorCode`
3. Trình tạo widget lỗi tùy chỉnh trong `NativeAdWidget`
4. Nhật ký gỡ lỗi (nếu được bật) qua các kênh nền tảng

## Hướng dẫn phát triển

### Cấu trúc dự án

```
flutter_admob_native_ads/
├── lib/
│   ├── flutter_admob_native_ads.dart    # Main exports
│   └── src/
│       ├── models/                      # Data models
│       │   ├── ad_layout_type.dart
│       │   ├── native_ad_options.dart
│       │   ├── native_ad_style.dart
│       │   └── native_ad_events.dart
│       ├── controllers/
│       │   └── native_ad_controller.dart
│       ├── widgets/
│       │   └── native_ad_widget.dart
│       └── utils/
│           ├── color_extension.dart
│           └── edge_insets_extension.dart
├── android/
│   └── src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/
│       ├── FlutterAdmobNativeAdsPlugin.kt
│       ├── ad_loader/
│       ├── layouts/                     # Form1, Form2, Form3
│       ├── platform_view/
│       ├── styling/
│       └── utils/
├── ios/
│   └── Classes/
│       ├── Plugin/
│       ├── AdLoader/
│       ├── Layouts/                     # Form1, Form2, Form3
│       ├── PlatformView/
│       ├── Styling/
│       └── Utils/
├── example/
│   └── lib/main.dart                    # Example app
└── test/
    └── flutter_admob_native_ads_test.dart
```

### Chạy kiểm tra

```bash
# Chạy tất cả các bài kiểm tra
flutter test

# Chạy với bảo hiểm
flutter test --coverage

# Chạy tệp kiểm tra cụ thể
flutter test test/flutter_admob_native_ads_test.dart
```

### Bảo phủ kiểm tra

Plugin bao gồm 7 nhóm kiểm tra (tổng cộng 295 dòng):

1. **NativeAdLayoutType**: Chuyển đổi enum và thuộc tính
2. **NativeAdOptions**: Cấu hình và xác thực
3. **NativeAdStyle**: Kiểu dáng và chủ đề
4. **NativeAdEvents**: Xử lý gọi lại sự kiện
5. **ColorExtension**: Các tiện ích chuyển đổi hex màu
6. **HexColorParsing**: Phân tích chuỗi hex (định dạng 3, 6, 8 chữ số)
7. **EdgeInsetsExtension**: Tuần tự hóa/hủy tuần tự EdgeInsets

### Cấu hình xây dựng

**Android (build.gradle)**
```gradle
minSdk 21
compileSdk 34
targetSdk 34
kotlinVersion '1.9.22'
```

**iOS (pubspec)**
```yaml
ios:
  minVersion: 13.0
```

### Thêm loại bố cục mới

Để thêm bố cục tùy chỉnh:

1. Tạo lớp builder mới:
   - `android/src/main/kotlin/.../layouts/Form4Builder.kt`
   - `ios/Classes/Layouts/Form4Builder.swift`

2. Cập nhật factory `AdLayoutBuilder` để dispatch đến builder mới

3. Thêm giá trị enum mới vào `NativeAdLayoutType`:
   ```dart
   enum NativeAdLayoutType {
     compact(1),
     standard(2),
     fullMedia(3),
     custom(4);  // Bố cục mới
   }
   ```

4. Cập nhật `recommendedHeight` và `viewType` cho bố cục mới

5. Thêm các trường hợp kiểm tra tương ứng

### Mở rộng kiểu dáng

Để thêm thuộc tính kiểu dáng mới:

1. Thêm thuộc tính vào `NativeAdStyle` (Dart)
2. Thêm thuộc tính vào `AdStyleOptions` (Android)
3. Thêm thuộc tính vào `AdStyleOptions` (iOS)
4. Cập nhật triển khai `AdStyleManager` (cả hai nền tảng)
5. Thêm trường hợp kiểm tra cho tuần tự hóa/hủy tuần tự

## Khắc phục sự cố

### Quảng cáo không hiển thị

1. **Xác minh Cấu hình AdMob:**
   - Kiểm tra ID ứng dụng AdMob trong AndroidManifest.xml (Android) hoặc Info.plist (iOS)
   - Xác minh định dạng ID đơn vị quảng cáo: `ca-app-pub-...`
   - Đảm bảo các đơn vị quảng cáo hoạt động trong bảng điều khiển AdMob

2. **Mạng & Kết nối:**
   - Đảm bảo thiết bị/emulator có kết nối internet
   - Kiểm tra tường lửa không chặn các yêu cầu Google Ad Manager
   - Xác minh phân giải DNS cho `googleadservices.com`

3. **Gỡ lỗi:**
   - Bật nhật ký gỡ lỗi: `enableDebugLogs: true` trong `NativeAdOptions`
   - Kiểm tra logcat (Android): `adb logcat | grep -i ads`
   - Kiểm tra bảng điều khiển (iOS): Bảng điều khiển Xcode với bộ lọc GMA
   - Sử dụng ID đơn vị quảng cáo kiểm tra để xác minh thiết lập

4. **Nguyên nhân phổ biến:**
   - Ứng dụng không được ký (sử dụng ID thiết bị kiểm tra)
   - Đơn vị quảng cáo không tồn tại hoặc bị vô hiệu hóa trong bảng điều khiển AdMob
   - Ứng dụng chưa được Google phê duyệt để hiển thị quảng cáo
   - Emulator không được nhận dạng làm thiết bị kiểm tra

### Lỗi xây dựng

**Android:**
- Đảm bảo `minSdkVersion >= 21` trong `android/app/build.gradle`
- Đảm bảo Google Play Services được cập nhật
- Chạy `flutter clean && flutter pub get` nếu bộ nhớ cache gradle bị lỗi

**iOS:**
- Đảm bảo mục tiêu triển khai >= 13.0 trong Podfile
- Chạy `pod update` nếu bộ nhớ cache CocoaPods bị lỗi
- Kiểm tra Cài đặt xây dựng Xcode để tương thích
- Đảm bảo phiên bản Swift khớp với yêu cầu plugin (5.0+)

### Vấn đề quản lý trạng thái

**Quảng cáo không tải lại:**
- Gọi `controller.reload()` để kích hoạt tải mới
- Đảm bảo bộ điều khiển chưa bị loại bỏ trước khi tải lại

**Nhiều bộ điều khiển:**
- Mỗi NativeAdWidget tạo ID bộ điều khiển duy nhất
- Lưu trữ tham chiếu nếu cần kiểm soát thủ công
- Gọi `dispose()` trên các bộ điều khiển khi hoàn thành

### Vấn đề cụ thể trên nền tảng

**Chỉ Android:**
- Kiểm tra `ColorUtils.parseColor()` để tìm các chuỗi hex không hợp lệ
- Xác minh chuyển đổi `DimensionUtils.dpToPx()`
- Đảm bảo phân cấp chế độ xem quảng cáo native không vượt quá giới hạn độ sâu

**Chỉ iOS:**
- Kiểm tra ràng buộc auto layout để tìm xung đột
- Xác minh chuyển đổi không gian màu cho các màu cạnh
- Đảm bảo vòng đời UIView phù hợp với vòng đời Flutter

## Giấy phép

Giấy phép MIT - xem tệp LICENSE để biết chi tiết.

## Hỗ trợ & Đóng góp

Để báo cáo vấn đề, yêu cầu tính năng hoặc đóng góp:
- **Repository**: https://github.com/tqc/flutter_admob_native_ads
- **Issues**: Báo cáo qua GitHub Issues
- **Pull Requests**: Hoan nghênh với mô tả chi tiết

## Changelog

Xem [CHANGELOG.md](CHANGELOG.md) để biết lịch sử phiên bản và ghi chú phát hành.
