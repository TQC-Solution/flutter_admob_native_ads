# Custom Layout Example - Summary

## 📦 Files đã tạo

Tôi đã tạo cho bạn **3 files hoàn chỉnh** để bắt đầu phát triển custom layouts:

### 1. **Android Implementation**
📁 `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/layouts/FormExampleBuilder.kt`

- ✅ **422 dòng code** với comments chi tiết
- ✅ Card-style layout với gradient background (Blue → Purple)
- ✅ Circular icon overlay với white border
- ✅ Gradient CTA button (Pink → Red)
- ✅ Ad badge ở góc trên phải
- ✅ Shadow effects và rounded corners
- ✅ Sử dụng: `LinearLayout`, `FrameLayout`, `ImageView`, `TextView`, `Button`, `MediaView`
- ✅ Helper functions cho gradient, shadows, shapes

### 2. **iOS Implementation**
📁 `ios/Classes/Layouts/FormExampleBuilder.swift`

- ✅ **400+ dòng code** với comments chi tiết
- ✅ Thiết kế giống hệt Android version
- ✅ Sử dụng: `UIStackView`, `UIView`, `UILabel`, `UIImageView`, `UIButton`, `GADMediaView`
- ✅ CAGradientLayer cho gradient backgrounds
- ✅ Auto Layout constraints
- ✅ Helper extensions (createVerticalStack, createHorizontalStack)
- ✅ UIColor hex extension

### 3. **Documentation**
📁 `CUSTOM_LAYOUT_GUIDE.md` - Hướng dẫn chi tiết 400+ dòng
📁 `EXAMPLE_LAYOUT_STRUCTURE.md` - Visualization và structure

---

## 🎨 Design Features

Layout example này có các features sau:

```
┌─────────────────────────────────────┐
│  Gradient Card (Blue → Purple)   🏷️│
│  ┌───────────────────────────────┐  │
│  │   📸 Media View (Video/Image) │  │
│  │                               │  │
│  │   ┌────┐                      │  │
│  │   │Icon│ Circular Overlay     │  │
│  ├───┴────┴──────────────────────┤  │
│  │  Headline (Bold, White)       │  │
│  │  ⭐⭐⭐ Advertiser           │  │
│  │  Body text description...     │  │
│  │  💰$4.99  🏪Store Name       │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │  Gradient CTA Button    │  │  │
│  │  │  (Pink → Red)           │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Custom Elements:**
- 🎨 Gradient backgrounds (2 gradients: card + button)
- ⭕ Circular icon với white border
- 📐 Rounded corners (16dp/pt)
- 💎 Shadow effects (elevation 8dp)
- 🏷️ Gold badge "Ad" label
- 🔘 Gradient CTA button với shadow
- 📱 Responsive design

---

## 🚀 Cách sử dụng

### Bước 1: Copy files vào project
Files đã được tạo sẵn tại đúng vị trí, bạn chỉ cần:
1. Kiểm tra `FormExampleBuilder.kt` (Android)
2. Kiểm tra `FormExampleBuilder.swift` (iOS)

### Bước 2: Đăng ký layout (nếu chưa có)

**Android** - Update `AdLayoutBuilder.kt`:
```kotlin
NativeAdLayoutType.EXAMPLE -> FormExampleBuilder.build(context, styleManager)
```

**iOS** - Update `AdLayoutBuilder.swift`:
```swift
case .example:
    return FormExampleBuilder.build(styleManager: styleManager)
```

**Dart** - Update `ad_layout_type.dart`:
```dart
enum NativeAdLayoutType {
  compact(1),
  standard(2),
  fullMedia(3),
  example(4), // ← Add this
  // ...
}
```

### Bước 3: Sử dụng trong Flutter
```dart
NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'ca-app-pub-3940256099942544/2247696110',
    layoutType: NativeAdLayoutType.example,
  ),
  height: 450,
  onAdLoaded: () => print('Ad loaded!'),
)
```

---

## 📖 Ngôn ngữ & Framework

### Android (Kotlin)
```kotlin
// Bạn viết UI hoàn toàn tự do bằng:
- LinearLayout, FrameLayout, ConstraintLayout
- TextView, ImageView, Button, View
- GradientDrawable (gradients, shapes, borders)
- ViewGroup.LayoutParams (sizing, margins)
- elevation, outlineProvider (shadows)
- Any Android View/ViewGroup!

// Bắt buộc:
- NativeAdView (container)
- MediaView (video/image content)
- Mapping views (nativeAdView.iconView = ...)
```

### iOS (Swift)
```swift
// Bạn viết UI hoàn toàn tự do bằng:
- UIStackView, UIView, UIScrollView
- UILabel, UIImageView, UIButton
- CAGradientLayer (gradients)
- NSLayoutConstraint (Auto Layout)
- CALayer (shadows, borders, corners)
- Any UIKit component!

// Bắt buộc:
- GADNativeAdView (container)
- GADMediaView (video/image content)
- Mapping views (nativeAdView.iconView = ...)
```

---

## 🎯 Những gì bạn CÓ THỂ customize

### ✅ Layout Structure
- Horizontal, vertical, grid, overlay, floating
- Any arrangement you can imagine
- Nested layouts, complex hierarchies

### ✅ Styling
- **Colors**: Solid, gradients, patterns
- **Shapes**: Rectangle, circle, custom paths
- **Borders**: Width, color, dashed, dotted
- **Corners**: Rounded, circular, asymmetric
- **Shadows**: Elevation, blur, color, offset

### ✅ Components
- **Text**: Any font, size, color, style, gradient text
- **Images**: Round, square, masks, filters
- **Buttons**: Any shape, gradient, icons, animations
- **Containers**: Cards, panels, sheets, modals

### ✅ Effects
- Shadows (drop shadow, inner shadow)
- Gradients (linear, radial, angular)
- Transparency & blur
- Animations (entrance, hover, click)

---

## ⚠️ Những gì BẮT BUỘC

### 1. Container Wrapper
```kotlin
// Android
val nativeAdView = NativeAdView(context)
```
```swift
// iOS
let nativeAdView = GADNativeAdView()
```

### 2. Media View (nếu muốn hiển thị video/images)
```kotlin
// Android
val mediaView = MediaView(context)
nativeAdView.mediaView = mediaView
```
```swift
// iOS
let mediaView = GADMediaView()
nativeAdView.mediaView = mediaView
```

### 3. View Mapping
```kotlin
// Android - Map ít nhất headline + CTA
nativeAdView.headlineView = headlineTextView
nativeAdView.callToActionView = ctaButton
```
```swift
// iOS
nativeAdView.headlineView = headlineLabel
nativeAdView.callToActionView = ctaButton
```

---

## 📝 Checklist phát triển

Khi tạo custom layout của riêng bạn:

- [ ] ✅ Đọc `CUSTOM_LAYOUT_GUIDE.md` để hiểu flow
- [ ] ✅ Xem code trong `FormExampleBuilder.kt` (Android)
- [ ] ✅ Xem code trong `FormExampleBuilder.swift` (iOS)
- [ ] ✅ Copy một trong 2 files làm template
- [ ] ✅ Customize UI components theo design của bạn
- [ ] ✅ Đảm bảo map đủ views (ít nhất headline + CTA)
- [ ] ✅ Test với test ad unit ID
- [ ] ✅ Verify trên cả Android và iOS
- [ ] ✅ Check performance (không quá nhiều nested views)
- [ ] ✅ Follow AdMob policies

---

## 💡 Tips quan trọng

### 1. Bắt đầu từ Example
Đừng viết từ đầu! Copy `FormExampleBuilder` và customize:
- Giữ structure cơ bản
- Thay đổi colors, sizes, spacing
- Thêm/bớt components theo nhu cầu

### 2. Maintain Parity
Android và iOS phải giống nhau:
- Cùng structure
- Cùng colors
- Cùng dimensions (dp = pt)

### 3. Test Early, Test Often
```dart
// Dùng test ad IDs để test nhanh
NativeAdOptions.testAndroid()  // Android test ID
NativeAdOptions.testIOS()      // iOS test ID
```

### 4. Use Helper Functions
Example đã có sẵn helper functions:
```kotlin
// Android
createMainContainer()
createHeaderSection()
createInfoSection()
createCtaButton()
```

```swift
// iOS
createVerticalStack()
createHorizontalStack()
```

### 5. Comment Your Code
Giống như example, thêm comments để:
- Document layout structure
- Explain custom logic
- Note dimensions và colors

---

## 🎨 Example Customizations

Từ `FormExampleBuilder`, bạn có thể dễ dàng tạo:

### 1. Minimalist White Card
```kotlin
// Change colors:
Color.WHITE                    // Background
Color.parseColor("#333333")    // Text
Color.parseColor("#2196F3")    // CTA button
```

### 2. Dark Mode
```kotlin
// Change colors:
Color.parseColor("#1a1a1a")    // Background
Color.WHITE                    // Text
Color.parseColor("#bb86fc")    // CTA button
```

### 3. Magazine Style
```kotlin
// Change layout:
- Media at top (full width)
- Text overlay on media
- Transparent gradient over media
```

### 4. Floating Icon
```kotlin
// Change icon position:
- Center of media (not bottom-left)
- Larger size (80dp instead of 60dp)
- Different border color
```

### 5. Horizontal Card
```kotlin
// Change main orientation:
- Use horizontal LinearLayout
- Media on left (150dp width)
- Content on right
```

---

## 📚 Documentation Files

1. **CUSTOM_LAYOUT_GUIDE.md**
   - Complete guide (400+ lines)
   - Step-by-step instructions
   - Code examples for common patterns
   - Troubleshooting tips

2. **EXAMPLE_LAYOUT_STRUCTURE.md**
   - Visual diagrams
   - Component breakdown
   - Dimensions reference
   - Color palette

3. **CUSTOM_LAYOUT_SUMMARY.md** (this file)
   - Quick overview
   - Getting started
   - Checklist

---

## 🚀 Next Steps

1. **Explore the code:**
   ```
   Open: FormExampleBuilder.kt
   Open: FormExampleBuilder.swift
   ```

2. **Understand the structure:**
   ```
   Read: EXAMPLE_LAYOUT_STRUCTURE.md
   ```

3. **Learn customization:**
   ```
   Read: CUSTOM_LAYOUT_GUIDE.md
   ```

4. **Create your own:**
   ```
   Copy FormExampleBuilder → FormYourNameBuilder
   Customize colors, layout, components
   Register in AdLayoutBuilder
   Test in Flutter app
   ```

5. **Test & Deploy:**
   ```
   Test with test ad IDs
   Verify on multiple devices
   Check performance
   Deploy to production
   ```

---

## 🎓 Learning Resources

**Trong codebase:**
- `Form1Builder.kt` / `Form1Builder.swift` - Simple horizontal layout
- `Form2Builder.kt` / `Form2Builder.swift` - Standard vertical layout
- `Form3Builder.kt` / `Form3Builder.swift` - Full media layout
- `FormExampleBuilder.kt` / `FormExampleBuilder.swift` - Advanced custom layout

**External:**
- [Google AdMob Native Ads - Android](https://developers.google.com/admob/android/native/start)
- [Google AdMob Native Ads - iOS](https://developers.google.com/admob/ios/native/start)
- [Material Design Guidelines](https://material.io/design)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

## ✅ Summary

Bạn hiện có:
- ✅ **2 files hoàn chỉnh** implement custom layout (Android + iOS)
- ✅ **3 files documentation** hướng dẫn chi tiết
- ✅ **Working example** với gradient, shadows, circular icon, overlay
- ✅ **Helper functions** để tái sử dụng
- ✅ **Step-by-step guide** để tạo layouts mới

Bạn có thể:
- ✅ Customize bất kỳ aspect nào của layout
- ✅ Tạo designs độc đáo cho brand của bạn
- ✅ Sử dụng full power của Android & iOS UI frameworks
- ✅ Maintain parity giữa platforms

Bạn cần biết:
- ✅ Kotlin (Android) và Swift (iOS) basics
- ✅ Android Views và iOS UIKit basics
- ✅ Layout concepts (constraints, stacks, etc.)

---

**Happy coding! Chúc bạn tạo được những native ad layouts đẹp và hiệu quả! 🎨✨**

---

## 📞 Quick Reference

```kotlin
// Android - View Types
LinearLayout, FrameLayout, RelativeLayout, ConstraintLayout
TextView, ImageView, Button, View
MediaView, NativeAdView, RatingBar

// Android - Styling
GradientDrawable (gradients, shapes, borders)
elevation (shadows)
clipToOutline (clipping)
```

```swift
// iOS - View Types
UIStackView, UIView, UIScrollView
UILabel, UIImageView, UIButton
GADMediaView, GADNativeAdView

// iOS - Styling
CAGradientLayer (gradients)
layer.cornerRadius (rounded corners)
layer.shadow* (shadows)
NSLayoutConstraint (positioning)
```

```dart
// Flutter - Usage
NativeAdWidget(
  options: NativeAdOptions(
    layoutType: NativeAdLayoutType.example,
  ),
)
```
