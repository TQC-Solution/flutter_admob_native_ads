import Foundation
import GoogleMobileAds
import Flutter

/// Protocol for banner ad loader callbacks.
protocol BannerAdLoaderDelegate: AnyObject {
    func adLoader(_ loader: BannerAdLoader, didReceiveBannerAd bannerView: GADBannerView)
    func adLoader(_ loader: BannerAdLoader, didFailWithError error: Error)
}

/// Handles loading banner ads from AdMob.
class BannerAdLoader: NSObject {

    private let adUnitId: String
    let controllerId: String
    private let channel: FlutterMethodChannel
    private let enableDebugLogs: Bool
    private let adSize: GADAdSize

    private var bannerView: GADBannerView?

    weak var delegate: BannerAdLoaderDelegate?
    private var onAdLoadedCallback: ((GADBannerView) -> Void)?

    init(
        adUnitId: String,
        controllerId: String,
        channel: FlutterMethodChannel,
        adSize: GADAdSize,
        enableDebugLogs: Bool = false
    ) {
        self.adUnitId = adUnitId
        self.controllerId = controllerId
        self.channel = channel
        self.adSize = adSize
        self.enableDebugLogs = enableDebugLogs
        super.init()
    }

    /// Sets the callback for when an ad is loaded.
    func setOnAdLoadedCallback(callback: @escaping (GADBannerView) -> Void) {
        onAdLoadedCallback = callback
    }

    /// Loads a banner ad.
    func loadAd() {
        log("Loading banner ad for unit: \(adUnitId), size: \(adSize)")

        guard let rootVC = rootViewController() else {
            log("ERROR: Could not get root view controller!")
            return
        }

        log("Got root view controller: \(rootVC)")

        let bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = rootVC
        bannerView.delegate = self

        self.bannerView = bannerView
        bannerView.load(GADRequest())

        log("Started banner ad request")
    }

    /// Gets the currently loaded banner view.
    func getBannerView() -> GADBannerView? {
        return bannerView
    }

    /// Destroys the loader and releases resources.
    func destroy() {
        log("Destroying banner ad loader")
        bannerView?.delegate = nil
        bannerView = nil
        onAdLoadedCallback = nil
    }

    // MARK: - Private Methods

    private func rootViewController() -> UIViewController? {
        // iOS 13+ uses connectedScenes
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first }
                .first?.rootViewController
        }
        // Fallback for older iOS versions
        return UIApplication.shared.windows.first?.rootViewController
    }

    private func sendEvent(_ method: String, arguments: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.channel.invokeMethod(method, arguments: arguments)
        }
    }

    private func log(_ message: String) {
        if enableDebugLogs {
            print("[BannerAdLoader][\(controllerId)] \(message)")
        }
    }
}

// MARK: - GADBannerViewDelegate

extension BannerAdLoader: GADBannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        log("Banner ad received")

        sendEvent("onAdLoaded", arguments: [
            "controllerId": controllerId
        ])

        onAdLoadedCallback?(bannerView)
        delegate?.adLoader(self, didReceiveBannerAd: bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        log("Banner ad failed to load: \(error.localizedDescription)")

        let nsError = error as NSError
        sendEvent("onAdFailedToLoad", arguments: [
            "controllerId": controllerId,
            "error": error.localizedDescription,
            "errorCode": nsError.code
        ])

        delegate?.adLoader(self, didFailWithError: error)
    }

    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        log("Banner ad clicked")
        sendEvent("onAdClicked", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        log("Banner ad impression recorded")
        sendEvent("onAdImpression", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        log("Banner ad will present screen")
        sendEvent("onAdOpened", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        log("Banner ad will dismiss screen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        log("Banner ad did dismiss screen")
        sendEvent("onAdClosed", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerView(_ bannerView: GADBannerView, didReceiveAdValue value: GADAdValue) {
        let valueInDollars = Double(value.value) / 1_000_000.0
        sendEvent("onAdPaid", arguments: [
            "controllerId": controllerId,
            "value": valueInDollars,
            "currencyCode": value.currencyCode
        ])
    }
}
