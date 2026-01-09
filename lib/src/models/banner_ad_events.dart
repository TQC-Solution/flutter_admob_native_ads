/// Callback type for when a banner ad is loaded successfully.
typedef OnBannerAdLoadedCallback = void Function();

/// Callback type for when a banner ad fails to load.
///
/// [error] contains the error message.
/// [errorCode] contains the platform-specific error code.
typedef OnBannerAdFailedCallback = void Function(String error, int errorCode);

/// Callback type for when a banner ad is clicked.
typedef OnBannerAdClickedCallback = void Function();

/// Callback type for when a banner ad impression is recorded.
typedef OnBannerAdImpressionCallback = void Function();

/// Callback type for when a banner ad is opened (full screen overlay).
typedef OnBannerAdOpenedCallback = void Function();

/// Callback type for when a banner ad is closed (full screen overlay).
typedef OnBannerAdClosedCallback = void Function();

/// Callback type for when a paid event is recorded.
///
/// [value] is the ad value in the specified currency.
/// [currencyCode] is the ISO 4217 currency code (e.g., "USD").
typedef OnBannerAdPaidCallback = void Function(double value, String currencyCode);

/// Container for banner ad event callbacks.
///
/// All callbacks are optional. Only provide callbacks for events you care about.
///
/// Example:
/// ```dart
/// BannerAdEvents(
///   onAdLoaded: () => print('Ad loaded'),
///   onAdFailed: (error, code) => print('Failed: $error'),
///   onAdClicked: () => print('Clicked'),
///   onAdPaid: (value, currency) => print('Earned \$$value $currency'),
/// )
/// ```
class BannerAdEvents {
  /// Creates a [BannerAdEvents] instance.
  const BannerAdEvents({
    this.onAdLoaded,
    this.onAdFailed,
    this.onAdClicked,
    this.onAdImpression,
    this.onAdOpened,
    this.onAdClosed,
    this.onAdPaid,
  });

  /// Called when an ad is loaded successfully.
  final OnBannerAdLoadedCallback? onAdLoaded;

  /// Called when an ad fails to load.
  final OnBannerAdFailedCallback? onAdFailed;

  /// Called when an ad is clicked.
  final OnBannerAdClickedCallback? onAdClicked;

  /// Called when an ad impression is recorded.
  final OnBannerAdImpressionCallback? onAdImpression;

  /// Called when an ad opens a full screen overlay.
  final OnBannerAdOpenedCallback? onAdOpened;

  /// Called when a full screen overlay is closed.
  final OnBannerAdClosedCallback? onAdClosed;

  /// Called when a paid event is recorded.
  final OnBannerAdPaidCallback? onAdPaid;
}
