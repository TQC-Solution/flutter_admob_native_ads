# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2026-01-09

### Added
- **Banner Ad Support** with full AdMob size compatibility
  - All 7 AdMob banner sizes: Banner (50dp), Full Banner (60dp), Leaderboard (90dp), Medium Rectangle (250dp), Smart Banner (adaptive), Adaptive Banner (custom height), Inline Adaptive Banner
  - `BannerAdController` with smart preload/reload support
  - `BannerAdWidget` with visibility tracking and shimmer loading state
  - `BannerAdSize` enum with size-to-height mapping
  - `BannerAdOptions` configuration class
  - `BannerAdEvents` with onAdPaid callback support
  - Test ad unit ID helpers for both platforms

- **AdControllerMixin** for code sharing between controllers
  - Extracted ~90% duplicate code from NativeAdController and BannerAdController
  - Shared smart preload/reload logic
  - Shared visibility tracking
  - Shared event handling and state management
  - Easier to add new ad types (Interstitial, Rewarded)

### Changed
- **NativeAdController** refactored to use AdControllerMixin
  - Reduced from ~600 lines to ~260 lines
  - Maintains all existing functionality
  - Better code organization and maintainability

- **BannerAdController** now uses AdControllerMixin
  - Reduced from ~560 lines to ~240 lines
  - Full feature parity with NativeAdController
  - Supports smart preload/reload with visibility tracking

### Technical Details
**Banner Ad Usage:**
```dart
// Create controller
final controller = BannerAdController(
  options: BannerAdOptions(
    adUnitId: 'ca-app-pub-xxx/xxx',
    size: BannerAdSize.adaptiveBanner,
    adaptiveBannerHeight: 60, // Custom height for adaptive
    enableSmartPreload: true,
    enableSmartReload: true,
  ),
  events: BannerAdEvents(
    onAdLoaded: () => print('Loaded'),
    onAdFailed: (error, code) => print('Failed: $error'),
    onAdPaid: (value, currency) => print('Paid: $value $currency'),
  ),
);

// Load ad
await controller.loadAd();

// Display widget
BannerAdWidget(
  controller: controller,
  height: 60,
)

// Smart reload
controller.updateVisibility(true); // Called automatically by widget
controller.reload();
```

**Files Modified:**
- `lib/src/controllers/ad_controller_mixin.dart` - NEW: Shared controller logic
- `lib/src/models/ad_state_base.dart` - NEW: Base class for state enums
- `lib/src/controllers/native_ad_controller.dart` - Refactored with mixin
- `lib/src/controllers/banner_ad_controller.dart` - Refactored with mixin
- `lib/src/models/banner_ad_size.dart` - NEW: Banner size enum
- `lib/src/models/banner_ad_options.dart` - NEW: Banner options
- `lib/src/models/banner_ad_events.dart` - NEW: Banner events
- `lib/src/widgets/banner_ad_widget.dart` - NEW: Banner widget
- Android: `banner/` package with BannerAdLoader, BannerAdPlatformView, etc.
- iOS: `BannerAd/` classes with GADBannerView integration

## [1.0.3] - 2026-01-08

### Added
- **Smart Preload System** with 4-layer awareness for intelligent ad loading
  - `PreloadScheduler` service orchestrates intelligent ad preloading
  - Layer 1 - Awareness: Checks app foreground, internet, cooldown, retry limit
  - Layer 2 - Cache/Loading: Avoids redundant requests if ad loading or cached
  - Layer 3 - Request: Single point for actual ad SDK calls
  - Layer 4 - Backoff: Exponential retry delays on failure (10s → 20s → 40s)
  - 90-second cooldown after ad impressions
  - Max 3 retry attempts with exponential backoff
  - Reset retry counter when network is restored

- **Smart Reload System** with visibility-aware logic
  - `ReloadScheduler` service orchestrates intelligent ad reloading
  - Cache-first strategy: uses preloaded ad if available, otherwise requests new
  - Visibility check: only reloads when app in foreground AND ad is visible
  - Remote config support for automatic reload intervals
  - 10-15 second retry delay on failed reloads
  - Automatic background preload after showing cached ad

- **AppLifecycleManager** service
  - Monitors app foreground/background state using WidgetsBindingObserver
  - Provides `isAppInForeground` getter and `foregroundStream` for state changes
  - Prevents ad loading when app is in background

- **NetworkConnectivityManager** service
  - Monitors internet connectivity using connectivity_plus package
  - Provides `isConnected` getter and `connectivityStream` for state changes
  - Resets retry counters when connectivity is restored

- **Enhanced NativeAdController** with smart scheduling support
  - New `preloadScheduler` and `reloadScheduler` properties
  - `setPreloadScheduler()` and `setReloadScheduler()` methods for service injection
  - Enhanced state management for preload/reload coordination
  - Better event callbacks for scheduler integration

### Changed
- Updated preload method to integrate with `PreloadScheduler`
- Added connectivity_plus dependency for network monitoring
- Enhanced event system for scheduler callbacks

### Technical Details
**Smart Preload Pattern:**
```dart
final scheduler = PreloadScheduler(
  lifecycleManager: lifecycleManager,
  networkManager: networkManager,
  loadAdCallback: () => controller.preload(),
  enableDebugLogs: true,
);
scheduler.initialize();

// Scheduler automatically handles when to load
scheduler.evaluateAndLoad();
```

**Smart Reload Pattern:**
```dart
final reloadScheduler = ReloadScheduler(
  lifecycleManager: lifecycleManager,
  networkManager: networkManager,
  reloadCallback: () => controller.reload(),
  cacheCheckCallback: () => preloadedController.isLoaded,
  showCachedAdCallback: () => showPreloadedAd(),
  preloadTriggerCallback: () => preloadedController.preload(),
  reloadIntervalSeconds: 60, // Auto-reload every 60s
);
reloadScheduler.initialize();
```

**Files Modified:**
- `lib/src/services/preload_scheduler.dart` - NEW: 4-layer preload orchestration
- `lib/src/services/reload_scheduler.dart` - NEW: Visibility-aware reload orchestration
- `lib/src/services/app_lifecycle_manager.dart` - NEW: App lifecycle monitoring
- `lib/src/services/network_connectivity_manager.dart` - NEW: Network connectivity monitoring
- `lib/src/controllers/native_ad_controller.dart` - Enhanced with scheduler support
- `lib/src/models/native_ad_events.dart` - Enhanced event callbacks
- `lib/src/models/native_ad_options.dart` - Updated options

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
