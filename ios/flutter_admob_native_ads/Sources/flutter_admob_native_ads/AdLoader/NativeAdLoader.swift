import Foundation
import GoogleMobileAds
import Flutter

/// Protocol for native ad loader callbacks.
protocol NativeAdLoaderEventDelegate: AnyObject {
    func adLoader(_ loader: NativeAdLoader, didReceiveNativeAd nativeAd: NativeAd)
    func adLoader(_ loader: NativeAdLoader, didFailWithError error: Error)
}

/// Represents a loaded native ad with its metadata.
struct LoadedAd {
    /// The native ad instance
    let ad: NativeAd

    /// Timestamp when the ad was loaded
    let loadedAt: Date

    /// The ad unit ID used to load this ad
    let adUnitId: String

    /// Returns the age of this ad (time since loaded) in seconds
    var age: TimeInterval {
        return Date().timeIntervalSince(loadedAt)
    }

    /// Returns the age of this ad in minutes
    var ageInMinutes: Int {
        return Int(age / 60)
    }

    /// Ad time-to-live in minutes (AdMob native ads expire after 60 minutes)
    static let adTTLMinutes: Int = 60

    /// Warning threshold for ad expiry in minutes
    static let adExpiryWarningMinutes: Int = 55

    /// Returns true if this ad has expired (age >= 60 minutes)
    var isExpired: Bool {
        return ageInMinutes >= LoadedAd.adTTLMinutes
    }

    /// Returns true if this ad is near expiry (age >= 55 minutes)
    var isNearExpiry: Bool {
        return ageInMinutes >= LoadedAd.adExpiryWarningMinutes
    }

    /// Returns the number of minutes until expiry (0 if already expired)
    var minutesUntilExpiry: Int {
        return max(0, LoadedAd.adTTLMinutes - ageInMinutes)
    }
}

/// Handles loading native ads from AdMob.
class NativeAdLoader: NSObject {

    private let adUnitId: String
    let controllerId: String  // Made internal for plugin access
    private let channel: FlutterMethodChannel
    private let enableDebugLogs: Bool

    private var adLoader: AdLoader?
    private var loadedAd: LoadedAd?

    /// Returns the currently loaded native ad (convenience property for backward compatibility)
    private(set) var nativeAd: NativeAd? {
        get { return loadedAd?.ad }
        set { /* Use setLoadedAd instead */ }
    }

    weak var delegate: NativeAdLoaderEventDelegate?

    init(
        adUnitId: String,
        controllerId: String,
        channel: FlutterMethodChannel,
        enableDebugLogs: Bool = false
    ) {
        self.adUnitId = adUnitId
        self.controllerId = controllerId
        self.channel = channel
        self.enableDebugLogs = enableDebugLogs
        super.init()
    }

    /// Loads a native ad.
    func loadAd() {
        // Get root view controller
        guard let rootViewController = rootViewController() else {
            log("No root view controller available")
            sendEvent("onAdFailedToLoad", arguments: [
                "controllerId": controllerId,
                "error": "No root view controller available",
                "errorCode": -1
            ])
            return
        }

        // Create ad loader
        let options = NativeAdMediaAdLoaderOptions()
        options.mediaAspectRatio = .landscape

        adLoader = AdLoader(
            adUnitID: adUnitId,
            rootViewController: rootViewController,
            adTypes: [.native],
            options: [options]
        )

        adLoader?.delegate = self

        // Load ad
        let request = Request()
        adLoader?.load(request)
    }

    /// Destroys the loader and releases resources.
    func destroy() {
        loadedAd = nil
        adLoader = nil
    }

    /// Gets the currently loaded native ad with TTL validation.
    ///
    /// Returns nil if:
    /// - No ad has been loaded
    /// - The ad has expired (age >= 60 minutes)
    ///
    /// Logs a warning if the ad is near expiry (age >= 55 minutes).
    ///
    /// - Returns: The native ad if valid, nil otherwise
    func getNativeAd() -> NativeAd? {
        guard let cached = loadedAd else { return nil }

        // Check if ad has expired
        if cached.isExpired {
            log("Ad expired (age: \(cached.ageInMinutes)min)")
            loadedAd = nil
            return nil
        }

        // Warn if ad is near expiry
        if cached.isNearExpiry {
            log("WARNING: Ad near expiry (\(cached.minutesUntilExpiry)min remaining)")
        }

        return cached.ad
    }

    /// Gets the age of the currently loaded ad.
    ///
    /// - Returns: The age of the ad in seconds, or nil if no ad is loaded
    func getAdAge() -> TimeInterval? {
        return loadedAd?.age
    }

    /// Gets the number of minutes until the ad expires.
    ///
    /// - Returns: Minutes until expiry, or nil if no ad is loaded
    func getMinutesUntilExpiry() -> Int? {
        return loadedAd?.minutesUntilExpiry
    }

    // MARK: - Private Methods

    private func sendEvent(_ method: String, arguments: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.channel.invokeMethod(method, arguments: arguments)
        }
    }

    private func rootViewController() -> UIViewController? {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.rootViewController
    }

    private func log(_ message: String) {
        if enableDebugLogs {
            print("[NativeAdLoader][\(controllerId)] \(message)")
        }
    }
}

// MARK: - AdLoaderDelegate

extension NativeAdLoader: AdLoaderDelegate {

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        log("Ad failed to load: \(error.localizedDescription)")

        let nsError = error as NSError
        sendEvent("onAdFailedToLoad", arguments: [
            "controllerId": controllerId,
            "error": error.localizedDescription,
            "errorCode": nsError.code
        ])

        delegate?.adLoader(self, didFailWithError: error)
    }
}

// MARK: - NativeAdLoaderDelegate

extension NativeAdLoader: NativeAdLoaderDelegate {

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        // Store new ad with timestamp
        loadedAd = LoadedAd(
            ad: nativeAd,
            loadedAt: Date(),
            adUnitId: adUnitId
        )

        nativeAd.paidEventHandler = { [weak self] adValue in
            guard let self = self else { return }
            let valueInDollars = Double(truncating: adValue.value) / 1_000_000.0
            self.sendEvent("onAdPaid", arguments: [
                "controllerId": self.controllerId,
                "value": valueInDollars,
                "currencyCode": adValue.currencyCode
            ])
        }

        nativeAd.delegate = self

        sendEvent("onAdLoaded", arguments: [
            "controllerId": controllerId
        ])

        delegate?.adLoader(self, didReceiveNativeAd: nativeAd)
    }
}

// MARK: - NativeAdDelegate

extension NativeAdLoader: NativeAdDelegate {

    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        sendEvent("onAdClicked", arguments: [
            "controllerId": controllerId
        ])
    }

    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        sendEvent("onAdImpression", arguments: [
            "controllerId": controllerId
        ])
    }

    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        sendEvent("onAdOpened", arguments: [
            "controllerId": controllerId
        ])
    }

    func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
        sendEvent("onAdClosed", arguments: [
            "controllerId": controllerId
        ])
    }
}
