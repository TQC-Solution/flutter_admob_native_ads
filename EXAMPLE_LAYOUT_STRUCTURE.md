# Example Layout Structure Visualization

## Layout Overview - FormExampleBuilder

```
┌─────────────────────────────────────────────────────────────┐
│  NativeAdView / GADNativeAdView (Root Container)            │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Main Container (Gradient: Blue → Purple)              │ │
│  │  [Card with rounded corners + shadow]              🏷️Ad│ │
│  │                                                          │ │
│  │  ┌────────────────────────────────────────────────────┐ │ │
│  │  │  📸 MEDIA VIEW (200dp/280pt height)               │ │ │
│  │  │  [Video/Image content - rounded top corners]      │ │ │
│  │  │                                                    │ │ │
│  │  │                                                    │ │ │
│  │  │                                                    │ │ │
│  │  │  ┌──────┐                                         │ │ │
│  │  │  │ ICON │ ← Circular icon với white border       │ │ │
│  │  │  │  60dp│   overlapping bottom-left của media    │ │ │
│  │  └──┴──────┴─────────────────────────────────────────┘ │ │
│  │                                                          │ │
│  │  ┌────────────────────────────────────────────────────┐ │ │
│  │  │  INFO SECTION (với padding 16dp)                   │ │ │
│  │  │                                                     │ │ │
│  │  │  📝 HEADLINE                                        │ │ │
│  │  │  "Ad Title Here - Bold, 20sp, White"               │ │ │
│  │  │  (max 2 lines)                                     │ │ │
│  │  │                                                     │ │ │
│  │  │  ⭐⭐⭐⭐⭐ Advertiser Name                         │ │ │
│  │  │  [Rating + Advertiser horizontal row]              │ │ │
│  │  │                                                     │ │ │
│  │  │  📄 Body Text                                       │ │ │
│  │  │  "Description of the ad content here..."           │ │ │
│  │  │  (max 3 lines, light gray)                         │ │ │
│  │  │                                                     │ │ │
│  │  │  💰 $4.99    🏪 Google Play                        │ │ │
│  │  │  [Price + Store horizontal row]                    │ │ │
│  │  └─────────────────────────────────────────────────────┘ │ │
│  │                                                          │ │
│  │  ┌────────────────────────────────────────────────────┐ │ │
│  │  │  🔘 CTA BUTTON (Gradient: Pink → Red)             │ │ │
│  │  │     "Install Now" / "Learn More"                   │ │ │
│  │  │  [Full width, rounded 24dp, với shadow]            │ │ │
│  │  └────────────────────────────────────────────────────┘ │ │
│  │                                                          │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Component Breakdown

### 1. Main Container
```
┌────────────────────────────────┐
│  Gradient Background           │
│  • Colors: #667eea → #764ba2   │
│  • Corner Radius: 16dp         │
│  • Elevation/Shadow: 8dp       │
│  • Margin: 8dp all sides       │
└────────────────────────────────┘
```

### 2. Media View
```
┌─────────────────────────────────┐
│  📸 GADMediaView / MediaView    │
│  • Height: 200dp (Android)      │
│            280pt (iOS)          │
│  • Background: #f0f0f0          │
│  • Rounded Corners: Top only    │
│  • Contains: Video or Image     │
└─────────────────────────────────┘
```

### 3. Icon Overlay
```
    ┌──────────┐
    │  ICON    │ ← Overlapping bottom-left
    │  60x60   │   của Media View
    │  ●●●●●●  │
    │  Circle  │
    │  Border  │
    └──────────┘
    • Shape: Circular
    • Border: 4dp white
    • Shadow: elevation 4dp
    • Position: -30dp overlap
```

### 4. Info Section Layout
```
┌──────────────────────────────────────┐
│  Padding: 16dp all + 30dp top        │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  HEADLINE (TextView/UILabel)   │  │
│  │  • Size: 20sp/pt               │  │
│  │  • Weight: Bold                │  │
│  │  │  Color: White                │  │
│  │  • Lines: max 2                │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌─────────┬──────────────────────┐  │
│  │ ⭐⭐⭐ │ Advertiser Name      │  │
│  │ Rating  │ (12sp, light gray)   │  │
│  └─────────┴──────────────────────┘  │
│                                      │
│  ┌────────────────────────────────┐  │
│  │  BODY TEXT                     │  │
│  │  • Size: 14sp/pt               │  │
│  │  • Color: #f0f0f0              │  │
│  │  • Lines: max 3                │  │
│  └────────────────────────────────┘  │
│                                      │
│  ┌──────────┬──────────────────────┐ │
│  │ $4.99    │ Google Play          │ │
│  │ (Bold)   │ (12sp, light gray)   │ │
│  └──────────┴──────────────────────┘ │
│                                      │
└──────────────────────────────────────┘
```

### 5. CTA Button
```
┌──────────────────────────────────────┐
│   🔘 "Install Now" / "Learn More"   │
│                                      │
│   • Gradient: #f093fb → #f5576c     │
│   • Height: 48dp                    │
│   • Corner Radius: 24dp             │
│   • Text: 16sp, Bold, White         │
│   • Shadow: elevation 4dp           │
│   • Margin: 16dp horizontal         │
└──────────────────────────────────────┘
```

### 6. Ad Badge
```
    ┌─────┐
    │ Ad  │ ← Top-right corner
    └─────┘
    • Background: #ffd700 (Gold)
    • Text: 10sp, Bold, #333333
    • Corner Radius: 4dp
    • Padding: 6dp horizontal, 3dp vertical
    • Shadow: elevation 2dp
```

---

## Color Palette

```
Gradient Background:
┌────────┐  ┌────────┐
│#667eea │→│#764ba2 │  (Blue to Purple)
└────────┘  └────────┘

CTA Button:
┌────────┐  ┌────────┐
│#f093fb │→│#f5576c │  (Pink to Red)
└────────┘  └────────┘

Text Colors:
• Headline:   #FFFFFF (White)
• Body:       #f0f0f0 (Light Gray)
• Advertiser: #e0e0e0 (Gray)
• Store:      #e0e0e0 (Gray)

Badge:
• Background: #ffd700 (Gold)
• Text:       #333333 (Dark Gray)
```

---

## Dimensions Reference

### Android (dp)
```
Card:
├─ Corner Radius: 16dp
├─ Elevation: 8dp
├─ Margin: 8dp
└─ Padding: 16dp

Media:
├─ Height: 200dp
└─ Corner Radius: 16dp (top only)

Icon:
├─ Size: 60x60dp
├─ Border Width: 4dp
├─ Overlap: -30dp
└─ Elevation: 4dp

CTA Button:
├─ Height: 48dp
├─ Corner Radius: 24dp
├─ Padding: 24dp H, 12dp V
└─ Elevation: 4dp

Spacing:
├─ Section Spacing: 16dp
└─ Item Spacing: 8dp
```

### iOS (pt)
```
Card:
├─ Corner Radius: 16pt
├─ Shadow Radius: 8pt
├─ Margin: 8pt
└─ Padding: 16pt

Media:
├─ Height: 280pt
└─ Corner Radius: 16pt (top only)

Icon:
├─ Size: 60x60pt
├─ Border Width: 4pt
├─ Overlap: 30pt
└─ Shadow Radius: 4pt

CTA Button:
├─ Height: 48pt
├─ Corner Radius: 24pt
└─ Shadow Radius: 4pt

Spacing:
├─ Section Spacing: 16pt
└─ Item Spacing: 8pt
```

---

## View Mapping

### Required Mappings
```kotlin
// Android
nativeAdView.iconView = iconView          // ✅ App icon (60dp circular)
nativeAdView.headlineView = headlineView  // ✅ Ad title (bold, white)
nativeAdView.callToActionView = ctaButton // ✅ CTA button (gradient)
nativeAdView.mediaView = mediaView        // ✅ Video/Image (200dp)
```

```swift
// iOS
nativeAdView.iconView = iconView          // ✅ App icon (60pt circular)
nativeAdView.headlineView = headlineLabel // ✅ Ad title (bold, white)
nativeAdView.callToActionView = ctaButton // ✅ CTA button (gradient)
nativeAdView.mediaView = mediaView        // ✅ Video/Image (280pt)
```

### Optional Mappings
```kotlin
// Android
nativeAdView.bodyView = bodyView              // 📝 Description
nativeAdView.starRatingView = ratingBar       // ⭐ Rating
nativeAdView.advertiserView = advertiserView  // 🏢 Advertiser
nativeAdView.priceView = priceView            // 💰 Price
nativeAdView.storeView = storeView            // 🏪 Store
```

```swift
// iOS
nativeAdView.bodyView = bodyLabel             // 📝 Description
// Rating handled separately                  // ⭐ Rating
nativeAdView.advertiserView = advertiserLabel // 🏢 Advertiser
nativeAdView.priceView = priceLabel           // 💰 Price
nativeAdView.storeView = storeLabel           // 🏪 Store
```

---

## File Locations

```
project_root/
├── android/
│   └── src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/layouts/
│       └── FormExampleBuilder.kt  ← Android Implementation
│
└── ios/
    └── Classes/Layouts/
        └── FormExampleBuilder.swift  ← iOS Implementation
```

---

## Usage in Flutter

```dart
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

NativeAdWidget(
  options: NativeAdOptions(
    adUnitId: 'ca-app-pub-3940256099942544/2247696110', // Test ID
    layoutType: NativeAdLayoutType.example, // ← Your custom layout
    enableDebugLogs: true,
  ),
  height: 450, // Recommended height
  onAdLoaded: () => print('✅ Ad loaded successfully'),
  onAdFailed: (error) => print('❌ Ad failed: $error'),
  onAdClicked: () => print('👆 Ad clicked'),
)
```

---

## Visual Comparison

### Standard Layout (Form2)
```
┌───────────────────────┐
│ [Icon] Headline       │
│        ⭐⭐⭐        │
├───────────────────────┤
│                       │
│    📸 Media View     │
│                       │
├───────────────────────┤
│ Body text...          │
│ $4.99 | Google Play   │
│ [    CTA Button    ]  │
└───────────────────────┘
```

### Example Custom Layout (FormExample)
```
┌───────────────────────┐
│      🏷️Ad            │
│    📸 Media View     │
│      ┌────┐          │
│      │Icon│          │ ← Overlapping
├──────┴────┴──────────┤
│  Headline (White)     │
│  ⭐⭐⭐ Advertiser   │
│  Body text...         │
│  $4.99 | Play Store   │
│  [  Gradient CTA  ]   │
└───────────────────────┘
     ↑
  Gradient Background
```

---

## Next Steps

1. ✅ Review code trong `FormExampleBuilder.kt` và `.swift`
2. ✅ Test với test ad unit IDs
3. ✅ Customize colors, sizes theo brand của bạn
4. ✅ Thêm animations (optional)
5. ✅ Test trên nhiều devices
6. ✅ Deploy và monitor performance

Happy coding! 🚀
