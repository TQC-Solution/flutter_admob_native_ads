# Hướng dẫn tạo Custom Native Ad Layout

Tài liệu này hướng dẫn chi tiết cách tạo layout tùy chỉnh cho Native Ads trên cả Android và iOS.

## 📁 Files Example

Tôi đã tạo sẵn 2 files example hoàn chỉnh cho bạn tham khảo:

- **Android (Kotlin):** `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/layouts/FormExampleBuilder.kt`
- **iOS (Swift):** `ios/Classes/Layouts/FormExampleBuilder.swift`

Cả 2 files đều implement một **Card-style layout với gradient background**, bao gồm:
- ✨ Gradient background (blue to purple)
- 🎨 Circular icon với white border overlay trên media
- 📐 Rounded corners cho tất cả elements
- 🔘 CTA button với gradient (pink to red) và shadow
- 🏷️ Ad badge ở góc trên phải
- 💎 Card elevation và shadow effects

---

## 🎯 Các bước tạo Custom Layout

### Bước 1: Tạo Builder Class

#### Android (Kotlin)
```kotlin
// File: FormYourNameBuilder.kt
package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import com.google.android.gms.ads.nativead.NativeAdView

object FormYourNameBuilder {
    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        // Your custom layout code here
    }
}
```

#### iOS (Swift)
```swift
// File: FormYourNameBuilder.swift
import UIKit
import GoogleMobileAds

enum FormYourNameBuilder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        // Your custom layout code here
    }
}
```

---

### Bước 2: Tạo UI Components

#### Android - Views bạn có thể dùng:

```kotlin
// Containers
LinearLayout(context)           // Vertical/Horizontal layout
FrameLayout(context)           // Overlay layout
RelativeLayout(context)        // Position relative
ConstraintLayout(context)      // Complex constraints
CardView(context)              // Material card

// Basic Views
TextView(context)              // Text/labels
ImageView(context)             // Images/icons
Button(context)                // Buttons
View(context)                  // Spacer/divider

// AdMob Components (BẮT BUỘC)
NativeAdView(context)          // Container wrapper
MediaView(context)             // Video/Image content
RatingBar(context)             // Star rating
```

**Ví dụ tạo Gradient Background:**
```kotlin
val container = FrameLayout(context).apply {
    background = GradientDrawable(
        GradientDrawable.Orientation.TOP_BOTTOM,
        intArrayOf(
            Color.parseColor("#667eea"), // Start color
            Color.parseColor("#764ba2")  // End color
        )
    ).apply {
        cornerRadius = dpToPx(16f).toFloat()
    }
}
```

**Ví dụ tạo Circular Image với Border:**
```kotlin
val iconView = ImageView(context).apply {
    scaleType = ImageView.ScaleType.CENTER_CROP
    background = GradientDrawable().apply {
        shape = GradientDrawable.OVAL
        setColor(Color.WHITE)
        setStroke(dpToPx(4f), Color.WHITE)
    }
    clipToOutline = true
    elevation = dpToPx(4f).toFloat()
}
```

---

#### iOS - Views bạn có thể dùng:

```swift
// Containers
UIStackView()                  // Auto-layout stack
UIView()                       // Basic container
UIScrollView()                 // Scrollable content

// Basic Views
UILabel()                      // Text/labels
UIImageView()                  // Images/icons
UIButton()                     // Buttons

// AdMob Components (BẮT BUỘC)
GADNativeAdView()              // Container wrapper
GADMediaView()                 // Video/Image content
```

**Ví dụ tạo Gradient Background:**
```swift
let gradientLayer = CAGradientLayer()
gradientLayer.colors = [
    UIColor(hex: "#667eea").cgColor,
    UIColor(hex: "#764ba2").cgColor
]
gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
gradientLayer.cornerRadius = 16

container.layer.insertSublayer(gradientLayer, at: 0)
```

**Ví dụ tạo Circular Image với Border:**
```swift
let iconView = UIImageView()
iconView.contentMode = .scaleAspectFill
iconView.backgroundColor = .white
iconView.layer.cornerRadius = 30
iconView.layer.borderWidth = 4
iconView.layer.borderColor = UIColor.white.cgColor
iconView.clipsToBounds = true
iconView.layer.shadowColor = UIColor.black.cgColor
iconView.layer.shadowOpacity = 0.3
```

---

### Bước 3: Map Views (BẮT BUỘC)

Sau khi tạo UI, bạn **PHẢI** map các views cho AdMob để nó biết đâu là component nào:

#### Android
```kotlin
nativeAdView.iconView = yourIconImageView
nativeAdView.headlineView = yourHeadlineTextView
nativeAdView.bodyView = yourBodyTextView
nativeAdView.callToActionView = yourCTAButton
nativeAdView.mediaView = yourMediaView
nativeAdView.starRatingView = yourRatingBar
nativeAdView.priceView = yourPriceTextView
nativeAdView.storeView = yourStoreTextView
nativeAdView.advertiserView = yourAdvertiserTextView
```

#### iOS
```swift
nativeAdView.iconView = yourIconImageView
nativeAdView.headlineView = yourHeadlineLabel
nativeAdView.bodyView = yourBodyLabel
nativeAdView.callToActionView = yourCTAButton
nativeAdView.mediaView = yourMediaView
nativeAdView.priceView = yourPriceLabel
nativeAdView.storeView = yourStoreLabel
nativeAdView.advertiserView = yourAdvertiserLabel
```

**⚠️ Lưu ý:** Không phải tất cả views đều bắt buộc phải có. Chỉ map những gì bạn muốn hiển thị.

---

### Bước 4: Đăng ký Layout với Plugin

Sau khi tạo xong builder, bạn cần đăng ký nó:

#### 4.1. Update `AdLayoutBuilder.kt` (Android)

```kotlin
// File: android/src/main/kotlin/.../layouts/AdLayoutBuilder.kt

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
            NativeAdLayoutType.EXAMPLE -> FormExampleBuilder.build(context, styleManager) // ← ADD THIS
            else -> Form2Builder.build(context, styleManager)
        }
    }
}
```

#### 4.2. Update `AdLayoutBuilder.swift` (iOS)

```swift
// File: ios/Classes/Layouts/AdLayoutBuilder.swift

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
        case .example:
            return FormExampleBuilder.build(styleManager: styleManager) // ← ADD THIS
        default:
            return Form2Builder.build(styleManager: styleManager)
        }
    }
}
```

#### 4.3. Update Dart Enum

```dart
// File: lib/src/models/ad_layout_type.dart

enum NativeAdLayoutType {
  compact(1),
  standard(2),
  fullMedia(3),
  example(4); // ← ADD THIS

  final int value;
  const NativeAdLayoutType(this.value);

  // ... rest of the code
}
```

---

## 🎨 Custom Styling Tips

### 1. Gradient Backgrounds

**Android:**
```kotlin
GradientDrawable(
    GradientDrawable.Orientation.LEFT_RIGHT,
    intArrayOf(Color.parseColor("#FF6B6B"), Color.parseColor("#4ECDC4"))
)
```

**iOS:**
```swift
let gradient = CAGradientLayer()
gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
gradient.startPoint = CGPoint(x: 0, y: 0.5)
gradient.endPoint = CGPoint(x: 1, y: 0.5)
```

---

### 2. Shadows

**Android:**
```kotlin
view.elevation = dpToPx(8f).toFloat()
view.outlineProvider = ViewOutlineProvider.BACKGROUND
```

**iOS:**
```swift
view.layer.shadowColor = UIColor.black.cgColor
view.layer.shadowOpacity = 0.2
view.layer.shadowOffset = CGSize(width: 0, height: 4)
view.layer.shadowRadius = 8
view.layer.masksToBounds = false
```

---

### 3. Rounded Corners

**Android:**
```kotlin
val drawable = GradientDrawable()
drawable.cornerRadius = dpToPx(16f).toFloat()
drawable.setColor(Color.WHITE)
view.background = drawable
```

**iOS:**
```swift
view.layer.cornerRadius = 16
view.clipsToBounds = true
```

---

### 4. Borders

**Android:**
```kotlin
val drawable = GradientDrawable()
drawable.setStroke(dpToPx(2f), Color.parseColor("#4ECDC4"))
drawable.cornerRadius = dpToPx(8f).toFloat()
```

**iOS:**
```swift
view.layer.borderWidth = 2
view.layer.borderColor = UIColor.blue.cgColor
```

---

## 🚀 Sử dụng Custom Layout trong Flutter

```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'your-ad-unit-id',
    layoutType: NativeAdLayoutType.example, // ← Use your custom layout
    style: NativeAdStyle.light(),
  ),
  onAdLoaded: () => print('Ad loaded'),
  onAdFailed: (error) => print('Error: $error'),
)
```

---

## 📝 Checklist khi tạo Custom Layout

- [ ] ✅ Tạo file Builder (Android + iOS)
- [ ] ✅ Tạo `NativeAdView`/`GADNativeAdView` container
- [ ] ✅ Tạo UI components theo design của bạn
- [ ] ✅ Map views cho AdMob (iconView, headlineView, etc.)
- [ ] ✅ Đăng ký trong `AdLayoutBuilder` (Android + iOS)
- [ ] ✅ Thêm enum value trong Dart
- [ ] ✅ Test với test ad unit ID
- [ ] ✅ Kiểm tra trên cả Android và iOS
- [ ] ✅ Tuân thủ AdMob policies

---

## ⚠️ Lưu ý quan trọng

### Bắt buộc phải có:
1. **Container**: `NativeAdView` (Android) hoặc `GADNativeAdView` (iOS)
2. **MediaView**: Nếu muốn hiển thị video/image ads
3. **View Mapping**: Map tất cả views bạn muốn hiển thị

### Không bắt buộc nhưng nên có:
1. **Headline**: Tiêu đề của ad (rất ít ad không có)
2. **CTA Button**: Call-to-action button
3. **Icon**: App icon

### Tùy chọn:
1. Body text (description)
2. Star rating
3. Price
4. Store name
5. Advertiser name

---

## 🎯 Ideas cho Custom Layouts

1. **Minimalist Card** - Clean white card với subtle shadow
2. **Dark Mode Premium** - Dark background với neon accents
3. **Magazine Style** - Large image với text overlay
4. **Carousel Item** - Horizontal scrollable layout
5. **Story Format** - Vertical full-screen như Instagram Stories
6. **Glassmorphism** - Blurred background với transparency
7. **Neumorphism** - Soft shadows và highlights
8. **Brutalist** - Bold typography và geometric shapes
9. **Floating Card** - Heavy shadow với depth effect
10. **Split Screen** - Media một bên, info một bên

---

## 🐛 Troubleshooting

### Ad không hiển thị
- ✅ Kiểm tra xem đã map đủ views chưa (ít nhất: headline, CTA)
- ✅ Kiểm tra layout có đúng kích thước không (không quá nhỏ)
- ✅ Kiểm tra logs để xem có lỗi gì không

### Layout bị vỡ trên một platform
- ✅ Kiểm tra constraints (iOS) hoặc LayoutParams (Android)
- ✅ Test trên nhiều kích thước màn hình
- ✅ So sánh implementation giữa Android và iOS

### Views không nhận được data
- ✅ Kiểm tra mapping trong `mapViews()`
- ✅ Đảm bảo views có đúng ID
- ✅ Kiểm tra visibility của views (có thể đang hidden)

---

## 📚 Resources

- [Google Mobile Ads SDK - Android](https://developers.google.com/admob/android/native/start)
- [Google Mobile Ads SDK - iOS](https://developers.google.com/admob/ios/native/start)
- [AdMob Policy Guidelines](https://support.google.com/admob/answer/6128543)
- [Native Ads Best Practices](https://support.google.com/admob/answer/6329638)

---

## 💡 Tips & Tricks

1. **Sử dụng helper functions** từ `FormExampleBuilder` (createVerticalStack, createHorizontalStack)
2. **Test với test ad IDs** trước khi dùng production IDs
3. **Maintain parity** giữa Android và iOS design
4. **Optimize cho performance** - tránh quá nhiều nested layouts
5. **Responsive design** - test trên nhiều screen sizes
6. **Follow Material/iOS guidelines** cho consistency
7. **Use AdStyleManager** để apply styles từ Flutter

---

Chúc bạn tạo được những native ad layouts đẹp và độc đáo! 🎨✨
