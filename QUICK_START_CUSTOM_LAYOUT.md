# Quick Start - Custom Layout trong 5 phút

## 🎯 Mục tiêu
Tạo một custom native ad layout hoàn toàn theo ý bạn với Android (Kotlin) và iOS (Swift).

## 📦 Files Example đã có sẵn

Tôi đã tạo sẵn example layout đẹp mắt cho bạn:

```
✅ FormExampleBuilder.kt      (Android - 422 dòng)
✅ FormExampleBuilder.swift   (iOS - 400+ dòng)
✅ CUSTOM_LAYOUT_GUIDE.md     (Hướng dẫn chi tiết)
✅ EXAMPLE_LAYOUT_STRUCTURE.md (Visualization)
```

## 🚀 3 Bước Nhanh

### Bước 1: Xem Example Code (2 phút)

**Android:**
```bash
# Mở file này
android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/layouts/FormExampleBuilder.kt
```

**iOS:**
```bash
# Mở file này
ios/Classes/Layouts/FormExampleBuilder.swift
```

Đọc qua code để hiểu structure:
- Main container với gradient
- Media view ở trên
- Icon overlay
- Info section
- CTA button

### Bước 2: Copy & Rename (1 phút)

**Android:**
```bash
cd android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/layouts/
cp FormExampleBuilder.kt FormMyCustomBuilder.kt
```

**iOS:**
```bash
cd ios/Classes/Layouts/
cp FormExampleBuilder.swift FormMyCustomBuilder.swift
```

Trong files mới:
- Đổi tên object/enum: `FormExampleBuilder` → `FormMyCustomBuilder`

### Bước 3: Customize (2 phút)

Thay đổi colors/sizes theo ý bạn:

**Android (FormMyCustomBuilder.kt):**
```kotlin
// Thay đổi gradient background
intArrayOf(
    Color.parseColor("#FF6B6B"), // Red
    Color.parseColor("#4ECDC4")  // Teal
)

// Thay đổi icon size
private const val ICON_SIZE_DP = 80f  // Lớn hơn

// Thay đổi CTA gradient
intArrayOf(
    Color.parseColor("#FFA500"), // Orange
    Color.parseColor("#FF6347")  // Tomato
)
```

**iOS (FormMyCustomBuilder.swift):**
```swift
// Thay đổi gradient background
UIColor(hex: "#FF6B6B").cgColor, // Red
UIColor(hex: "#4ECDC4").cgColor  // Teal

// Thay đổi icon size
private static let iconSize: CGFloat = 80

// Thay đổi CTA gradient
UIColor(hex: "#FFA500").cgColor, // Orange
UIColor(hex: "#FF6347").cgColor  // Tomato
```

## 📝 Đăng ký Layout

### Android
**File:** `android/src/main/kotlin/.../layouts/AdLayoutBuilder.kt`

```kotlin
object AdLayoutBuilder {
    fun build(
        context: Context,
        layoutType: NativeAdLayoutType,
        styleManager: AdStyleManager
    ): NativeAdView {
        return when (layoutType) {
            NativeAdLayoutType.COMPACT -> Form1Builder.build(context, styleManager)
            NativeAdLayoutType.STANDARD -> Form2Builder.build(context, styleManager)
            NativeAdLayoutType.FULL_MEDIA -> Form3Builder.build(context, styleManager)
            NativeAdLayoutType.MY_CUSTOM -> FormMyCustomBuilder.build(context, styleManager) // ← ADD
            else -> Form2Builder.build(context, styleManager)
        }
    }
}
```

### iOS
**File:** `ios/Classes/Layouts/AdLayoutBuilder.swift`

```swift
enum AdLayoutBuilder {
    static func build(
        layoutType: NativeAdLayoutType,
        styleManager: AdStyleManager
    ) -> GADNativeAdView {
        switch layoutType {
        case .compact:
            return Form1Builder.build(styleManager: styleManager)
        case .standard:
            return Form2Builder.build(styleManager: styleManager)
        case .fullMedia:
            return Form3Builder.build(styleManager: styleManager)
        case .myCustom:
            return FormMyCustomBuilder.build(styleManager: styleManager) // ← ADD
        default:
            return Form2Builder.build(styleManager: styleManager)
        }
    }
}
```

### Dart
**File:** `lib/src/models/ad_layout_type.dart`

```dart
enum NativeAdLayoutType {
  compact(1),
  standard(2),
  fullMedia(3),
  myCustom(4);  // ← ADD

  final int value;
  const NativeAdLayoutType(this.value);

  int toInt() => value;

  static NativeAdLayoutType fromInt(int value) {
    switch (value) {
      case 1: return NativeAdLayoutType.compact;
      case 2: return NativeAdLayoutType.standard;
      case 3: return NativeAdLayoutType.fullMedia;
      case 4: return NativeAdLayoutType.myCustom;  // ← ADD
      default: return NativeAdLayoutType.standard;
    }
  }

  Map<String, int> get recommendedHeight {
    switch (this) {
      case NativeAdLayoutType.compact:
        return {'min': 120, 'max': 150};
      case NativeAdLayoutType.standard:
        return {'min': 250, 'max': 300};
      case NativeAdLayoutType.fullMedia:
        return {'min': 350, 'max': 400};
      case NativeAdLayoutType.myCustom:  // ← ADD
        return {'min': 400, 'max': 500};
    }
  }

  String get viewType {
    switch (this) {
      case NativeAdLayoutType.compact:
        return 'native_ad_view_compact';
      case NativeAdLayoutType.standard:
        return 'native_ad_view_standard';
      case NativeAdLayoutType.fullMedia:
        return 'native_ad_view_fullMedia';
      case NativeAdLayoutType.myCustom:  // ← ADD
        return 'native_ad_view_myCustom';
    }
  }
}
```

## ✅ Sử dụng trong Flutter

```dart
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'ca-app-pub-3940256099942544/2247696110', // Test ID
    layoutType: NativeAdLayoutType.myCustom, // ← Your layout!
    enableDebugLogs: true,
  ),
  height: 450,
  onAdLoaded: () => print('✅ Ad loaded!'),
  onAdFailed: (error) => print('❌ Error: $error'),
  onAdClicked: () => print('👆 Clicked!'),
)
```

## 🎨 Customization Ideas

### 1. Change Colors
```kotlin
// Android - Gradient colors
Color.parseColor("#your-color-1")
Color.parseColor("#your-color-2")
```

### 2. Change Sizes
```kotlin
// Android - Dimensions
private const val ICON_SIZE_DP = 80f       // Icon lớn hơn
private const val MEDIA_HEIGHT_DP = 250f   // Media cao hơn
private const val CARD_CORNER_RADIUS = 24f // Bo tròn hơn
```

### 3. Change Layout
```kotlin
// Android - Đổi orientation
LinearLayout(context).apply {
    orientation = LinearLayout.HORIZONTAL  // Horizontal instead of vertical
}
```

### 4. Add Components
```kotlin
// Android - Thêm subtitle
val subtitleView = TextView(context).apply {
    textSize = 12f
    setTextColor(Color.GRAY)
}
```

### 5. Remove Components
```kotlin
// Android - Không cần body text
// Just comment out hoặc xóa bodyView
```

## 📚 Tài liệu đầy đủ

Nếu bạn muốn hiểu sâu hơn hoặc tạo layout phức tạp:

1. **CUSTOM_LAYOUT_GUIDE.md** - Hướng dẫn chi tiết 400+ dòng
2. **EXAMPLE_LAYOUT_STRUCTURE.md** - Visualization và diagrams
3. **CUSTOM_LAYOUT_SUMMARY.md** - Overview và checklist

## 🐛 Troubleshooting

### Ad không hiển thị?
```dart
// Enable debug logs
NativeAdOptions(
  enableDebugLogs: true,
  // ...
)

// Check logs:
// Android: adb logcat | grep -i ads
// iOS: Xcode console với filter "GMA"
```

### Layout bị vỡ?
- ✅ Kiểm tra constraints (iOS) hoặc LayoutParams (Android)
- ✅ Đảm bảo đã map views: `nativeAdView.headlineView = ...`
- ✅ Test trên nhiều screen sizes

### Compile error?
- ✅ Đảm bảo package name đúng
- ✅ Import đầy đủ: `com.google.android.gms.ads.nativead.*`
- ✅ Sync Gradle (Android) hoặc Pod install (iOS)

## ⚡ Quick Tips

1. **Bắt đầu từ Example** - Đừng viết từ đầu
2. **Test với Test IDs** - Nhanh hơn nhiều
3. **Maintain Parity** - Android và iOS phải giống nhau
4. **Comment Your Code** - Dễ maintain sau này
5. **Check Policies** - Follow AdMob guidelines

## 🎯 Kết quả

Sau 5 phút, bạn sẽ có:
- ✅ Custom layout riêng của bạn
- ✅ Hoạt động trên cả Android và iOS
- ✅ Có thể customize bất kỳ aspect nào
- ✅ Ready to use trong Flutter app

## 🚀 Next Steps

1. **Customize design** - Thay colors, sizes, layout
2. **Add animations** - Entrance effects, hover states
3. **Test thoroughly** - Multiple devices, screen sizes
4. **Optimize** - Performance, memory usage
5. **Deploy** - Production với real ad unit IDs

---

**That's it! Bây giờ bạn có thể tạo bất kỳ native ad layout nào bạn muốn! 🎉**

Need help? Check out the detailed guides:
- 📖 CUSTOM_LAYOUT_GUIDE.md
- 📊 EXAMPLE_LAYOUT_STRUCTURE.md
- 📋 CUSTOM_LAYOUT_SUMMARY.md
