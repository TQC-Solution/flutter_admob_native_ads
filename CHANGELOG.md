# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-12-16

### Added
- **Preload Ads Feature**: Load ads before displaying for instant appearance
  - New `preload()` method in `NativeAdController` that waits for ad to load
  - Returns `true`/`false` to indicate preload success
  - Use with `autoLoad: false` to show preloaded ads instantly
  - Improves UX significantly by eliminating loading spinners
  - Check state with `isPreloaded` and `isLoaded` getters

### Fixed
- **CRITICAL:** Border and border radius now rendered natively instead of Flutter Container
  - Added `styleMainContainer()` method to `AdStyleManager` on both platforms
  - Refactored all 24 layout builders (12 Android + 12 iOS) to use native container styling
  - Border and corner radius now applied directly to native views for better performance
  - Removed Flutter `Container` decoration wrapper

### Changed
- **Default style values updated** for better visual consistency:
  - `containerCornerRadius`: 8 (changed from 12)
  - `containerBorderColor`: `#C1B5B5` (light gray border)
  - `containerBorderWidth`: 1 (default border enabled)
- All container styling (background, border, corner radius) now 100% native

### Technical Details
**Preload Pattern:**
```dart
final controller = NativeAdController(options: NativeAdOptions(...));
await controller.preload();  // Wait for ad to load
NativeAdWidget(controller: controller, autoLoad: false);
```

**Files Modified:**
- `lib/src/controllers/native_ad_controller.dart`: Added `preload()` method and `isPreloaded` getter
- `lib/src/widgets/native_ad_widget.dart`: Removed Container decoration
- `lib/src/models/native_ad_style.dart`: Updated default values
- `android/.../styling/AdStyleManager.kt`: Added `styleMainContainer()`
- `ios/Classes/Styling/AdStyleManager.swift`: Added `styleMainContainer()`
- Android: `Form1Builder.kt` through `Form12Builder.kt` (12 files)
- iOS: `Form1Builder.swift` through `Form12Builder.swift` (12 files)

## [1.0.1] - 2025-12-14

### Fixed
- **CRITICAL:** Fixed CTA button styling not working - All `NativeAdStyle` properties for CTA button (`ctaBackgroundColor`, `ctaTextColor`, `ctaCornerRadius`, `ctaPadding`, etc.) were being ignored
- Refactored all 24 layout builders (12 Android + 12 iOS) to properly apply styles via `styleManager.styleButton()`
- CTA buttons previously always displayed with hardcoded color `#4285F4` regardless of style settings
- Affected files:
  - Android: `Form1Builder.kt` through `Form12Builder.kt`
  - iOS: `Form1Builder.swift` through `Form12Builder.swift`

### Technical Details
- Before: Layout builders created CTA buttons with hardcoded colors and styles
- After: Layout builders delegate all styling to `AdStyleManager.styleButton()` which correctly applies `NativeAdStyle` properties
- This fix ensures proper styling customization for all 12 form layouts on both platforms

## [1.0.0] - 2025-12-12

### Added
- Initial release of Flutter AdMob Native Ads plugin
- **12 diverse layout forms** (form1 to form12) - từ compact (80dp) đến full media (320dp)
- Comprehensive styling options (30+ properties) for all ad components
- SwiftUI-style declarative styling API
- Full native rendering via Platform Views
- Event callbacks: onAdLoaded, onAdFailed, onAdClicked, onAdImpression, onAdOpened, onAdClosed
- Built-in theme presets: light, dark, minimal
- NativeAdController for advanced lifecycle management
- Support for custom loading and error widgets
- Test ad unit ID helpers
- Android support (minSdk 21, Google Mobile Ads SDK 23.0.0)
- iOS support (iOS 13.0+, Google Mobile Ads SDK 11.0)

### Layout Forms Overview

| Form | Height | Style | Best for |
|------|--------|-------|----------|
| form1 | 80dp | Horizontal compact | List items |
| form2 | 90dp | Horizontal media | List with media |
| form3 | 320dp | Vertical story | Feed cards |
| form4 | 300dp | Vertical media-first | Product cards |
| form5 | 300dp | Vertical article | Article cards |
| form6 | 280dp | Vertical standard | Standard feeds |
| form7 | 140dp | Horizontal video | Video ads |
| form8 | 100dp | Horizontal compact | Compact cards |
| form9 | 280dp | Vertical action-first | CTA focused |
| form10 | 120dp | Text-only minimal | Text ads |
| form11 | 280dp | Vertical clean | Clean layout |
| form12 | 280dp | Vertical alternative | Alt layout |

### Styling Options
- CTA button: background color, text color, font, corner radius, padding, border, elevation
- Container: background, corner radius, padding, margin, border, shadow
- Text: headline, body, price, store, advertiser styling
- Media view: height, corner radius, aspect ratio, background
- Icon: size, corner radius, border
- Star rating: size, active/inactive colors
- Ad label: visibility, text, colors, corner radius, padding
- Layout spacing: item spacing, section spacing
