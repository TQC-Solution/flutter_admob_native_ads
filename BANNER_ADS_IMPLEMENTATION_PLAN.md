# Implementation Plan: Banner Ad Support with Preload/Reload

## Summary
Add full Banner Ad support to the plugin with all AdMob sizes and smart preload/reload features, following the same architecture patterns as Native Ad.

## User Requirements
- **Ad Sizes**: All AdMob sizes (Banner, Full Banner, Leaderboard, Medium Rectangle, Smart Banner, Adaptive Banner, Inline Adaptive)
- **Styling**: Default AdMob appearance only (no custom styling)
- **Smart Features**: Full smart preload/reload like native ads

---

## Phase 1: Flutter Layer - Models & Controller

### 1.1 Create Models

| File | Description |
|------|-------------|
| `lib/src/models/banner_ad_size.dart` | Enum for all 7 banner sizes with toInt()/fromInt() and viewType getter |
| `lib/src/models/banner_ad_options.dart` | Config class with adUnitId, size, enableSmartPreload, enableSmartReload, reloadIntervalSeconds, retryDelaySeconds, adaptiveBannerHeight. Include testAndroid()/testIOS() factories |
| `lib/src/models/banner_ad_events.dart` | Callback typedefs: onAdLoaded, onAdFailed, onAdClicked, onAdImpression, onAdOpened, onAdClosed, onAdPaid |

### 1.2 Create Controller

| File | Key Implementation |
|------|-------------------|
| `lib/src/controllers/banner_ad_controller.dart` | Mirror `NativeAdController` patterns: <br>- Reuse `AppLifecycleManager`, `NetworkConnectivityManager`, `PreloadScheduler`, `ReuseScheduler` services<br>- Method channel: `flutter_admob_banner_ads`<br>- Methods: `loadAd()`, `reload()`, `preload()`, `updateVisibility()`, `triggerSmartReload()`<br>- Events: `onAdLoaded`, `onAdFailed`, `onAdClicked`, `onAdImpression`, `onAdOpened`, `onAdClosed`, `onAdPaid`<br>- State: `initial`, `loading`, `loaded`, `error` |

### 1.3 Update Library Export

| File | Changes |
|------|---------|
| `lib/flutter_admob_native_ads.dart` | Add exports for banner components |

---

## Phase 2: Platform Layer - Android

### 2.1 Create New Files

| File | Description |
|------|-------------|
| `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/banner/BannerAdLoader.kt` | Loads `AdView` with `AdListener`, sends events via method channel |
| `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/banner/BannerAdPlatformView.kt` | `PlatformView` wrapper that receives `AdView` from loader via callback |
| `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/banner/BannerAdViewFactory.kt` | `PlatformViewFactory` for banner ads |
| `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/banner/BannerAdSizeExtensions.kt` | Maps sizeIndex to `AdSize` (BANNER, FULL_BANNER, LEADERBOARD, MEDIUM_RECTANGLE, SMART_BANNER, adaptive, inline adaptive) |

### 2.2 Modify Plugin

| File | Changes |
|------|---------|
| `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/FlutterAdmobNativeAdsPlugin.kt` | - Add `bannerAdLoaders` and `bannerAdCallbacks` registries<br>- Add `registerBannerAdCallback()`, `unregisterBannerAdCallback()`, `getBannerAd()`<br>- Add view type: `flutter_admob_banner_ads`<br>- Add method handlers: `loadBannerAd`, `reloadBannerAd`, `disposeBannerAd`<br>- Clean up banner resources in `onDetachedFromEngine` |

---

## Phase 3: Platform Layer - iOS

### 3.1 Create New Files

| File | Description |
|------|-------------|
| `ios/Classes/BannerAd/BannerAdLoader.swift` | Loads `GADBannerView` with `GADBannerViewDelegate`, implements `BannerAdLoaderDelegate` protocol |
| `ios/Classes/BannerAd/BannerAdPlatformView.swift` | `FlutterPlatformView` wrapper that receives `GADBannerView` from loader via callback |
| `ios/Classes/BannerAd/BannerAdViewFactory.swift` | `FlutterPlatformViewFactory` for banner ads |
| `ios/Classes/BannerAd/BannerAdSizeExtensions.swift` | Maps sizeIndex to `GADAdSize` using GMA SDK constants |

### 3.2 Modify Plugin

| File | Changes |
|------|---------|
| `ios/Classes/Plugin/FlutterAdmobNativeAdsPlugin.swift` | - Add `bannerAdLoaders` and `bannerAdCallbacks` dictionaries<br>- Add `registerBannerAdCallback()`, `unregisterBannerAdCallback()`, `getBannerAd()`<br>- Add view type: `flutter_admob_banner_ads`<br>- Add method handlers: `loadBannerAd`, `reloadBannerAd`, `disposeBannerAd`<br>- Implement `BannerAdLoaderDelegate` extension<br>- Clean up in `detachFromEngine` |

---

## Phase 4: Flutter Widget

| File | Key Implementation |
|------|-------------------|
| `lib/src/widgets/banner_ad_widget.dart` | Mirror `NativeAdWidget` patterns: <br>- Uses `VisibilityDetector` for visibility tracking<br>- Wraps `AndroidView`/`UiKitView` based on platform<br>- Simplified loading/error states (no shimmer needed for banners)<br>- Properties: `options`, `controller`, `height`, `width`, `loadingWidget`, `errorWidget`, event callbacks, `autoLoad`, `visibilityThreshold` |

---

## Implementation Sequence

1. **Flutter Models**: Create `BannerAdSize`, `BannerAdOptions`, `BannerAdEvents`
2. **Flutter Controller**: Create `BannerAdController` (reuse existing services)
3. **Android Platform**: Create banner package files and update plugin
4. **iOS Platform**: Create banner package files and update plugin
5. **Flutter Widget**: Create `BannerAdWidget`
6. **Testing**: Add example usage and verify all sizes on both platforms

---

## Critical Files to Reference

| File | Purpose |
|------|---------|
| `lib/src/controllers/native_ad_controller.dart` | Reference for controller patterns |
| `lib/src/widgets/native_ad_widget.dart` | Reference for widget patterns |
| `lib/src/models/native_ad_options.dart` | Reference for options structure |
| `android/src/main/kotlin/com/tqc/ads/flutter_admob_native_ads/FlutterAdmobNativeAdsPlugin.kt` | Reference for Android plugin patterns |
| `ios/Classes/Plugin/FlutterAdmobNativeAdsPlugin.swift` | Reference for iOS plugin patterns |
| `lib/src/services/*.dart` | Services to reuse (lifecycle, network, preload, reload) |

---

## Verification

1. **Test all ad sizes** on Android and iOS
2. **Test preload**: `controller.preload()` should complete when ad loads
3. **Test reload**: `controller.reload()` should fetch new ad
4. **Test smart preload**: Enable `enableSmartPreload`, verify ads load only when foreground + network
5. **Test smart reload**: Enable `enableSmartReload`, verify visibility-aware reloading
6. **Test visibility tracking**: Verify `updateVisibility()` affects reload behavior
7. **Test events**: Verify all callbacks fire correctly
8. **Test lifecycle**: Verify proper cleanup on dispose
