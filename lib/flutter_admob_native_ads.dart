/// Flutter plugin for displaying AdMob Native Ads with customizable layouts
/// and SwiftUI-style declarative styling.
///
/// This plugin provides:
/// - Three layout types: compact, standard, and fullMedia
/// - Comprehensive styling options for all ad components
/// - Full native rendering via Platform Views
/// - Event callbacks for ad lifecycle management
///
/// ## Getting Started
///
/// 1. Add the dependency to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   flutter_admob_native_ads:
///     path: packages/flutter_admob_native_ads
/// ```
///
/// 2. Configure your Android app:
/// ```xml
/// <!-- AndroidManifest.xml -->
/// <meta-data
///     android:name="com.google.android.gms.ads.APPLICATION_ID"
///     android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
/// ```
///
/// 3. Configure your iOS app:
/// ```xml
/// <!-- Info.plist -->
/// <key>GADApplicationIdentifier</key>
/// <string>ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy</string>
/// ```
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';
///
/// NativeAdWidget(
///   options: NativeAdOptions(
///     adUnitId: 'ca-app-pub-xxx/xxx',
///     layoutType: NativeAdLayoutType.standard,
///     style: NativeAdStyle.light(),
///   ),
///   onAdLoaded: () => print('Ad loaded'),
///   onAdFailed: (error) => print('Error: $error'),
/// )
/// ```
///
/// ## Layout Types
///
/// - **compact**: Minimal layout (120-150dp), ideal for lists
/// - **standard**: Balanced layout (250-300dp) with media view
/// - **fullMedia**: Rich media layout (350-400dp), high engagement
///
/// ## Custom Styling
///
/// ```dart
/// NativeAdStyle(
///   ctaBackgroundColor: Colors.blue,
///   ctaTextColor: Colors.white,
///   containerBackgroundColor: Colors.white,
///   headlineTextColor: Colors.black,
///   // ... more options
/// )
/// ```
library;

// Native Ad Models
export 'src/models/ad_layout_type.dart';
export 'src/models/native_ad_events.dart';
export 'src/models/native_ad_options.dart';
export 'src/models/native_ad_style.dart';

// Banner Ad Models
export 'src/models/banner_ad_size.dart';
export 'src/models/banner_ad_events.dart';
export 'src/models/banner_ad_options.dart';

// Controllers
export 'src/controllers/native_ad_controller.dart';
export 'src/controllers/banner_ad_controller.dart';

// Widgets
export 'src/widgets/native_ad_widget.dart';
export 'src/widgets/banner_ad_widget.dart';

// Services (for advanced usage)
export 'src/services/app_lifecycle_manager.dart';
export 'src/services/network_connectivity_manager.dart';
export 'src/services/preload_scheduler.dart';
export 'src/services/reload_scheduler.dart';

// Utils (for advanced usage)
export 'src/utils/color_extension.dart';
export 'src/utils/edge_insets_extension.dart';
