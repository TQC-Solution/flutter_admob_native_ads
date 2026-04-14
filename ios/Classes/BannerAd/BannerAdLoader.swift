import Foundation
import GoogleMobileAds
import Flutter

/// Protocol for banner ad loader callbacks.
protocol BannerAdLoaderDelegate: AnyObject {
    func adLoader(_ loader: BannerAdLoader, didReceiveBannerAd bannerView: BannerView)
    func adLoader(_ loader: BannerAdLoader, didFailWithError error: Error)
}

/// Handles loading banner ads from AdMob.
class BannerAdLoader: NSObject {

    private let adUnitId: String
    let controllerId: String
    private let channel: FlutterMethodChannel
    private let enableDebugLogs: Bool
    private let adSize: AdSize

    private var bannerView: BannerView?

    weak var delegate: BannerAdLoaderDelegate?
    private var onAdLoadedCallback: ((BannerView) -> Void)?

    init(
        adUnitId: String,
        controllerId: String,
        channel: FlutterMethodChannel,
        adSize: AdSize,
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
    func setOnAdLoadedCallback(callback: @escaping (BannerView) -> Void) {
        onAdLoadedCallback = callback
    }

    /// Loads a banner ad.
    func loadAd() {
        guard let rootVC = rootViewController() else {
            log("ERROR: Could not get root view controller!")
            return
        }

        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = rootVC
        bannerView.delegate = self

        self.bannerView = bannerView
        bannerView.load(Request())
    }

    /// Gets the currently loaded banner view.
    func getBannerView() -> BannerView? {
        return bannerView
    }

    /// Destroys the loader and releases resources.
    func destroy() {
        bannerView?.delegate = nil
        bannerView = nil
        onAdLoadedCallback = nil
    }

    // MARK: - Private Methods

    private func rootViewController() -> UIViewController? {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.rootViewController
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

// MARK: - BannerViewDelegate

extension BannerAdLoader: BannerViewDelegate {

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        sendEvent("onAdLoaded", arguments: [
            "controllerId": controllerId
        ])

        onAdLoadedCallback?(bannerView)
        delegate?.adLoader(self, didReceiveBannerAd: bannerView)
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        log("Banner ad failed to load: \(error.localizedDescription)")

        let nsError = error as NSError
        sendEvent("onAdFailedToLoad", arguments: [
            "controllerId": controllerId,
            "error": error.localizedDescription,
            "errorCode": nsError.code
        ])

        delegate?.adLoader(self, didFailWithError: error)
    }

    func bannerViewDidRecordClick(_ bannerView: BannerView) {
        sendEvent("onAdClicked", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
        sendEvent("onAdImpression", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
        sendEvent("onAdOpened", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
    }

    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
        sendEvent("onAdClosed", arguments: [
            "controllerId": controllerId
        ])
    }

    func bannerView(_ bannerView: BannerView, didReceiveAdValue value: AdValue) {
        let valueInDollars = Double(truncating: value.value) / 1_000_000.0
        sendEvent("onAdPaid", arguments: [
            "controllerId": controllerId,
            "value": valueInDollars,
            "currencyCode": value.currencyCode
        ])
    }
}
