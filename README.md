# Flutter AdMob Native Ads

Plugin Flutter sẵn sàng sản xuất cho phép hiển thị Google AdMob Native Ads với 12 bố cục đa dạng và kiểu khai báo theo phong cách SwiftUI. Cung cấp rendering 100% native thông qua Platform Views với parity đầy đủ giữa các triển khai Android và iOS.

**Phiên bản:** 1.0.1
**Giấy phép:** MIT
**Repository:** https://github.com/tqc/flutter_admob_native_ads

## Các tính năng

- **12 Bố cục Đa dạng**: Từ compact (80dp) đến full media (320dp), phù hợp với mọi trường hợp sử dụng
- **Kiểu dáng Toàn diện**: 30+ thuộc tính có thể tùy chỉnh cho mọi thành phần giao diện
- **API Khai báo kiểu SwiftUI**: Cấu hình kiểu dáng sạch sẽ, dễ đọc, an toàn với kiểu
- **100% Native Rendering**: Platform Views với triển khai native Android và iOS
- **Vòng đời Sự kiện Đầy đủ**: Theo dõi các sự kiện tải ad, impression, click và thay đổi trạng thái overlay
- **Giao diện Nội dung Có sẵn**: Light, Dark và Minimal presets với tùy chỉnh dễ dàng
- **Quản lý trạng thái**: NativeAdController tích hợp để kiểm soát vòng đời nâng cao
- **Sẵn sàng sản xuất**: Bảo phủ kiểm tra toàn diện, xử lý lỗi và ghi nhật ký gỡ lỗi
- **Parity Đa nền tảng**: Hành vi và kiểu dáng giống nhau trên Android 21+ và iOS 13.0+

## Cập nhật quan trọng (v1.0.0)

### Thay đổi từ hệ thống 3 layouts cũ

Plugin đã được refactor hoàn toàn để cung cấp **12 forms layout** thay vì 3 layouts cũ (compact, standard, fullMedia):

| Cũ | Mới tương đương | Lưu ý |
|-----|----------------|-------|
| `compact` | `form1` | Compact horizontal với icon |
| `standard` | `form6` | Standard feed card |
| `fullMedia` | `form3` hoặc `form4` | Vertical layout với media lớn |

**Migration code:**
```dart
// Cũ
layoutType: NativeAdLayoutType.compact
// Mới
layoutType: NativeAdLayoutType.form1

// Cũ
layoutType: NativeAdLayoutType.standard
// Mới
layoutType: NativeAdLayoutType.form6

// Cũ
layoutType: NativeAdLayoutType.fullMedia
// Mới
layoutType: NativeAdLayoutType.form3  // hoặc form4
```

### Lợi ích của 12 Forms

- **Đa dạng hơn**: Nhiều tùy chọn layout cho mọi use case
- **Tối ưu hóa**: Mỗi form được thiết kế cho mục đích cụ thể
- **Linh hoạt**: Từ compact 80dp đến full media 320dp
- **Tương thích ngược**: Dễ dàng migration từ hệ thống cũ

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

2. Khởi tạo Google Mobile Ads SDK trong `AppDelegate.swift`:

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

3. Thêm vào `Podfile` của bạn:

```ruby
pod 'Google-Mobile-Ads-SDK', '~> 11.0'
```

4. Xử lý các thư viện liên kết tĩnh (statically linked binaries):

Nếu bạn gặp cảnh báo "The 'Pods-Runner' target has transitive dependencies that include statically linked binaries", hãy cập nhật Podfile của bạn như sau:

```ruby
target 'Runner' do
  use_frameworks! :linkage => :static
  
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Fix for statically linked binaries warning
  pod 'Google-Mobile-Ads-SDK', :modular_headers => true
  pod 'GoogleUserMessagingPlatform', :modular_headers => true
  
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # Fix for statically linked binaries warning
    if target.name == 'Google-Mobile-Ads-SDK' || target.name == 'GoogleUserMessagingPlatform'
      target.build_configurations.each do |config|
        config.build_settings['MACH_O_TYPE'] = 'staticlib'
      end
    end
  end
end
```

5. Đảm bảo chỉ định platform iOS:

```ruby
platform :ios, '13.0'
```

6. Quyền riêng tư cho iOS 17+:

Để tuân thủ yêu cầu quyền riêng tư của iOS 17+, hãy đảm bảo file `PrivacyInfo.xcprivacy` được bao gồm trong plugin của bạn với các quyền cần thiết cho Google Mobile Ads SDK:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSPrivacyTrackingDomains</key>
	<array/>
	<key>NSPrivacyAccessedAPITypes</key>
	<array>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategorySystemBootTime</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>35F9.1</string>
			</array>
		</dict>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>C617.1</string>
			</array>
		</dict>
		<dict>
			<key>NSPrivacyAccessedAPIType</key>
			<string>NSPrivacyAccessedAPICategoryDeviceID</string>
			<key>NSPrivacyAccessedAPITypeReasons</key>
			<array>
				<string>35F9.1</string>
			</array>
		</dict>
	</array>
	<key>NSPrivacyCollectedDataTypes</key>
	<array>
		<dict>
			<key>NSPrivacyCollectedDataType</key>
			<string>NSPrivacyCollectedDataTypeDeviceID</string>
			<key>NSPrivacyCollectedDataTypeLinked</key>
			<false/>
			<key>NSPrivacyCollectedDataTypeTracking</key>
			<false/>
			<key>NSPrivacyCollectedDataTypePurposes</key>
			<array>
				<string>NSPrivacyCollectedDataTypePurposeAnalytics</string>
				<string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
			</array>
		</dict>
	</array>
	<key>NSPrivacyTracking</key>
	<false/>
</dict>
</plist>
```

Đảm bảo file này được tham chiếu trong podspec của plugin:

```ruby
# Privacy manifest
s.resource_bundles = {'flutter_admob_native_ads_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
```

## Khởi động nhanh

```dart
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

// Sử dụng đơn giản
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

## Các loại bố cục (12 Forms)

Plugin cung cấp 12 mẫu bố cục khác nhau, mỗi mẫu được tối ưu hóa cho các trường hợp sử dụng cụ thể:

> **Tham khảo hình ảnh:** Các mẫu thiết kế của 12 forms có sẵn trong thư mục [ads_template_native/](ads_template_native/). Xem file [ads_template_native/ad_full.png](ads_template_native/ad_full.png) để tham khảo tất cả các layout.

### Form 1 - Compact Horizontal (80dp)
Bố cục ngang tối giản với Icon + Title + Description + CTA.
**Phù hợp với:** Mục danh sách, vị trí compact.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form1,
  ),
  height: 80,
)
```

### Form 2 - Media Compact (90dp)
Bố cục ngang với Large Media + Title + Description + CTA.
**Phù hợp với:** Mục danh sách với media preview.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form2,
  ),
  height: 90,
)
```

### Form 3 - Vertical Story (320dp)
Bố cục dọc với Title + Description + Large Media + CTA ở dưới.
**Phù hợp với:** Feed cards, story layout.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form3,
  ),
  height: 320,
)
```

### Form 4 - Media-First Card (300dp)
Bố cục dọc với Large Media + Icon + Title + Description + CTA.
**Phù hợp với:** Product cards, media-first layout.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form4,
  ),
  height: 300,
)
```

### Form 5 - Article Card (300dp)
Bố cục dọc với Icon + Title + Description + Large Media + CTA.
**Phù hợp với:** Article cards, blog posts.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form5,
  ),
  height: 300,
)
```

### Form 6 - Standard Feed Card (280dp)
Bố cục dọc tiêu chuẩn với Icon + Title + Description + Media + CTA.
**Phù hợp với:** Standard feed cards.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form6,
  ),
  height: 280,
)
```

### Form 7 - Video Horizontal (140dp)
Bố cục ngang với Video/Media (Left) + Title + Description + CTA (Right).
**Phù hợp với:** Video ads, horizontal scrolling.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form7,
  ),
  height: 140,
)
```

### Form 8 - Compact Horizontal Media (100dp)
Bố cục ngang compact với Media (Left) + Title + Description + CTA (Right).
**Phù hợp với:** Compact horizontal cards.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form8,
  ),
  height: 100,
)
```

### Form 9 - Action-First (280dp)
Bố cục dọc với CTA (Top) + Icon + Title + Description + Media.
**Phù hợp với:** Action-first layout.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form9,
  ),
  height: 280,
)
```

### Form 10 - Text-Only Minimal (120dp)
Bố cục tối giản với Title + Description + CTA (không có media).
**Phù hợp với:** Text-only ads, minimal design.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form10,
  ),
  height: 120,
)
```

### Form 11 - Clean Vertical (280dp)
Bố cục dọc sạch sẽ với Ad Label (Top) + Title + Media + CTA (Bottom).
**Phù hợp với:** Clean vertical layout.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form11,
  ),
  height: 280,
)
```

### Form 12 - Alternative Vertical (280dp)
Bố cục dọc phong cách thay thế với Ad Label (Top) + Title + Media + CTA (Bottom).
**Phù hợp với:** Alternative vertical layout.

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form12,
  ),
  height: 280,
)
```

### Bảng So sánh Nhanh

| Form | Chiều cao | Kiểu | Phù hợp với |
|------|-----------|------|-------------|
| Form1 | 80dp | Horizontal compact | List items |
| Form2 | 90dp | Horizontal media | List with media |
| Form3 | 320dp | Vertical story | Feed cards |
| Form4 | 300dp | Vertical media-first | Product cards |
| Form5 | 300dp | Vertical article | Article cards |
| Form6 | 280dp | Vertical standard | Standard feeds |
| Form7 | 140dp | Horizontal video | Video ads |
| Form8 | 100dp | Horizontal compact | Compact cards |
| Form9 | 280dp | Vertical action-first | CTA focused |
| Form10 | 120dp | Text-only minimal | Text ads |
| Form11 | 280dp | Vertical clean | Clean layout |
| Form12 | 280dp | Vertical alternative | Alt layout |

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

Enum với 12 tùy chọn bố cục được thiết kế sẵn:

| Loại | Chiều cao | Mô tả | Loại chế độ xem |
|------|-----------|-------|----------------|
| `form1` | 80dp | Compact horizontal: Icon + Title + CTA | `flutter_admob_native_ads_form1` |
| `form2` | 90dp | Horizontal với large media | `flutter_admob_native_ads_form2` |
| `form3` | 320dp | Vertical story layout | `flutter_admob_native_ads_form3` |
| `form4` | 300dp | Media-first vertical card | `flutter_admob_native_ads_form4` |
| `form5` | 300dp | Article card layout | `flutter_admob_native_ads_form5` |
| `form6` | 280dp | Standard feed card | `flutter_admob_native_ads_form6` |
| `form7` | 140dp | Horizontal video layout | `flutter_admob_native_ads_form7` |
| `form8` | 100dp | Compact horizontal media | `flutter_admob_native_ads_form8` |
| `form9` | 280dp | Action-first vertical | `flutter_admob_native_ads_form9` |
| `form10` | 120dp | Text-only minimal | `flutter_admob_native_ads_form10` |
| `form11` | 280dp | Clean vertical layout | `flutter_admob_native_ads_form11` |
| `form12` | 280dp | Alternative vertical | `flutter_admob_native_ads_form12` |

**Các phương thức chính:**
- `toInt()`: Trả về số nhận dạng số nguyên (1-12)
- `fromInt(int)`: Phân tích cú pháp số nguyên thành loại bố cục (mặc định là form1)
- `recommendedHeight`: Trả về chiều cao đề xuất (double)
- `viewType`: Trả về chuỗi nhận dạng chế độ xem nền tảng
- `name`: Trả về tên form (form1, form2, ...)

### NativeAdOptions

Lớp cấu hình để tải quảng cáo và hành vi.

| Thuộc tính | Loại | Mặc định | Mô tả |
|----------|------|---------|-------------|
| `adUnitId` | String | bắt buộc | ID đơn vị quảng cáo Google AdMob (định dạng: `ca-app-pub-...`) |
| `layoutType` | NativeAdLayoutType | form1 | Một trong 12 forms: form1, form2, ..., form12 |
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
│  - Layout Builders (12 forms)       │
│  - Platform Views                   │
└─────────────────────────────────────┘
```

### Chi tiết triển khai Native

#### Android (Kotlin)

**Các thành phần chính:**
- `FlutterAdmobNativeAdsPlugin`: Điểm vào plugin và trình xử lý phương thức
- `NativeAdLoader`: Bao bọc API `AdLoader` của Google, quản lý vòng đời tải
- `AdLayoutBuilder`: Mô hình Factory để tạo các chế độ xem dành riêng cho bố cục
  - `Form1Builder` đến `Form12Builder`: 12 bố cục đa dạng
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
  - `Form1Builder` đến `Form12Builder`: 12 bố cục đa dạng
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
│       ├── layouts/                     # Form1-Form12 builders
│       ├── platform_view/
│       ├── styling/
│       └── utils/
├── ios/
│   └── Classes/
│       ├── Plugin/
│       ├── AdLoader/
│       ├── Layouts/                     # Form1-Form12 builders
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

Plugin hiện có 12 forms được thiết kế sẵn. Để thêm bố cục tùy chỉnh (Form13+):

1. Tạo lớp builder mới:
   - `android/src/main/kotlin/.../layouts/Form13Builder.kt`
   - `ios/Classes/Layouts/Form13Builder.swift`

2. Cập nhật factory `AdLayoutBuilder` để dispatch đến builder mới (cả Android và iOS)

3. Thêm giá trị enum mới vào `NativeAdLayoutType` trong [lib/src/models/ad_layout_type.dart](lib/src/models/ad_layout_type.dart):
   ```dart
   enum NativeAdLayoutType {
     form1,
     form2,
     ...
     form12,
     form13;  // Bố cục mới
   }
   ```

4. Cập nhật các phương thức `toInt()`, `fromInt()`, `recommendedHeight` và `viewType` cho form mới

5. Thêm các trường hợp kiểm tra tương ứng trong [test/flutter_admob_native_ads_test.dart](test/flutter_admob_native_ads_test.dart)

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

### Lỗi GADInvalidInitializationException

Nếu bạn gặp lỗi `GADInvalidInitializationException` với thông báo "The Google Mobile Ads SDK was initialized without an application ID", hãy thực hiện các bước sau:

1. **Kiểm tra ID ứng dụng trong Info.plist:**
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
   ```

2. **Khởi tạo SDK trong AppDelegate.swift:**
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

3. **Xử lý các thư viện liên kết tĩnh:**
   Nếu bạn gặp cảnh báo "The 'Pods-Runner' target has transitive dependencies that include statically linked binaries", hãy cập nhật Podfile của bạn như được mô tả trong phần cấu hình iOS ở trên.

4. **Sử dụng ID ứng dụng thử nghiệm:**
   Trong quá trình phát triển, bạn có thể sử dụng ID ứng dụng thử nghiệm của Google:
   ```
   ca-app-pub-3940256099942544~1458002511
   ```

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

## Bug Fixes quan trọng

### Fix: ctaBackgroundColor và các style properties không hoạt động (v1.0.1)

**Vấn đề:** Khi set các thuộc tính styling như `ctaBackgroundColor`, `ctaTextColor`, `ctaCornerRadius` trong `NativeAdStyle`, màu sắc và kiểu dáng không được apply cho CTA button.

**Nguyên nhân:** Tất cả 24 layout form builders (12 Android + 12 iOS) đều hardcode màu sắc và kiểu dáng của CTA button thay vì sử dụng `styleManager.styleButton()` để apply styles từ `NativeAdStyle`.

**Giải pháp:** Đã refactor toàn bộ 24 layout builders để gọi `styleManager.styleButton()` thay vì hardcode styles.

**Files đã sửa:**
- Android: `Form1Builder.kt` đến `Form12Builder.kt` (12 files)
- iOS: `Form1Builder.swift` đến `Form12Builder.swift` (12 files)

**Ví dụ sử dụng sau khi fix:**
```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.form1,
    style: NativeAdStyle(
      ctaBackgroundColor: Color(0xFFD6FFC9),  // ✅ Bây giờ hoạt động!
      ctaTextColor: Colors.black,
      ctaCornerRadius: 12,
      ctaPadding: EdgeInsets.all(16),
    ),
  ),
)
```

Trước đây, các style properties này bị ignore và CTA button luôn hiển thị với màu mặc định `#4285F4` (Google Blue).

## Changelog

Xem [CHANGELOG.md](CHANGELOG.md) để biết lịch sử phiên bản và ghi chú phát hành.
