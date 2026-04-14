/// Fires when a load or reload **attempt** starts (before network request).
typedef OnNativeAdLoadAttemptStartedCallback = void Function();

/// Callback invoked when an ad has been successfully loaded.
typedef OnAdLoadedCallback = void Function();

/// Callback invoked when ad loading fails.
///
/// [error] contains the error message describing the failure.
/// [errorCode] contains the native error code from the ad SDK.
typedef OnAdFailedCallback = void Function(String error, int errorCode);

/// Callback invoked when the user clicks on the ad.
typedef OnAdClickedCallback = void Function();

/// Callback invoked when an ad impression is recorded.
typedef OnAdImpressionCallback = void Function();

/// Callback invoked when a paid event is recorded.
///
/// [value] is the ad value in the specified currency.
/// [currencyCode] is the ISO 4217 currency code (e.g., "USD").
typedef OnAdPaidCallback = void Function(double value, String currencyCode);

/// Callback invoked when the ad opens an overlay (e.g., full-screen view).
typedef OnAdOpenedCallback = void Function();

/// Callback invoked when the ad overlay is closed.
typedef OnAdClosedCallback = void Function();

/// Callback invoked when a cached ad is ready to be shown.
///
/// Used by smart reload to notify the widget that a preloaded ad
/// is available and should replace the current ad.
typedef OnCachedAdReadyCallback = void Function();

/// Container class for all native ad event callbacks.
///
/// Use this class to group all event handlers when configuring a native ad.
///
/// Example:
/// ```dart
/// NativeAdEvents(
///   onAdLoaded: () => print('Ad loaded'),
///   onAdFailed: (error, code) => print('Error: $error'),
///   onAdClicked: () => print('Ad clicked'),
/// )
/// ```
class NativeAdEvents {
  /// Creates a [NativeAdEvents] instance with optional callbacks.
  const NativeAdEvents({
    this.onLoadAttemptStarted,
    this.onAdLoaded,
    this.onAdFailed,
    this.onAdClicked,
    this.onAdImpression,
    this.onAdPaid,
    this.onAdOpened,
    this.onAdClosed,
    this.onCachedAdReady,
  });

  /// Fires when [NativeAdController.loadAd] / reload begins a network attempt.
  final OnNativeAdLoadAttemptStartedCallback? onLoadAttemptStarted;

  /// Callback when ad loads successfully.
  final OnAdLoadedCallback? onAdLoaded;

  /// Callback when ad fails to load.
  final OnAdFailedCallback? onAdFailed;

  /// Callback when ad is clicked.
  final OnAdClickedCallback? onAdClicked;

  /// Callback when ad impression is recorded.
  final OnAdImpressionCallback? onAdImpression;

  /// Callback when a paid event is recorded.
  final OnAdPaidCallback? onAdPaid;

  /// Callback when ad opens overlay.
  final OnAdOpenedCallback? onAdOpened;

  /// Callback when ad overlay closes.
  final OnAdClosedCallback? onAdClosed;

  /// Callback when a cached ad is ready to be shown.
  ///
  /// Used by smart reload to notify when a preloaded ad
  /// is available and should replace the current ad.
  final OnCachedAdReadyCallback? onCachedAdReady;

  /// Creates a copy with updated callbacks.
  NativeAdEvents copyWith({
    OnNativeAdLoadAttemptStartedCallback? onLoadAttemptStarted,
    OnAdLoadedCallback? onAdLoaded,
    OnAdFailedCallback? onAdFailed,
    OnAdClickedCallback? onAdClicked,
    OnAdImpressionCallback? onAdImpression,
    OnAdPaidCallback? onAdPaid,
    OnAdOpenedCallback? onAdOpened,
    OnAdClosedCallback? onAdClosed,
    OnCachedAdReadyCallback? onCachedAdReady,
  }) {
    return NativeAdEvents(
      onLoadAttemptStarted: onLoadAttemptStarted ?? this.onLoadAttemptStarted,
      onAdLoaded: onAdLoaded ?? this.onAdLoaded,
      onAdFailed: onAdFailed ?? this.onAdFailed,
      onAdClicked: onAdClicked ?? this.onAdClicked,
      onAdImpression: onAdImpression ?? this.onAdImpression,
      onAdPaid: onAdPaid ?? this.onAdPaid,
      onAdOpened: onAdOpened ?? this.onAdOpened,
      onAdClosed: onAdClosed ?? this.onAdClosed,
      onCachedAdReady: onCachedAdReady ?? this.onCachedAdReady,
    );
  }
}
