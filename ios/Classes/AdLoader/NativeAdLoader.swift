import Foundation
import GoogleMobileAds
import Flutter

/// Protocol for native ad loader callbacks.
protocol NativeAdLoaderDelegate: AnyObject {
    func adLoader(_ loader: NativeAdLoader, didReceiveNativeAd nativeAd: GADNativeAd)
    func adLoader(_ loader: NativeAdLoader, didFailWithError error: Error)
}

/// Handles loading native ads from AdMob.
class NativeAdLoader: NSObject {

    private let adUnitId: String
    let controllerId: String  // Made internal for plugin access
    private let channel: FlutterMethodChannel
    private let enableDebugLogs: Bool

    private var adLoader: GADAdLoader?
    private(set) var nativeAd: GADNativeAd?

    weak var delegate: NativeAdLoaderDelegate?

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
        log("Loading ad for unit: \(adUnitId)")

        // Get root view controller
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            log("No root view controller available")
            sendEvent("onAdFailedToLoad", arguments: [
                "controllerId": controllerId,
                "error": "No root view controller available",
                "errorCode": -1
            ])
            return
        }

        // Create ad loader
        let options = GADNativeAdMediaAdLoaderOptions()
        options.mediaAspectRatio = .landscape

        adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: rootViewController,
            adTypes: [.native],
            options: [options]
        )

        adLoader?.delegate = self

        // Load ad
        let request = GADRequest()
        adLoader?.load(request)
    }

    /// Destroys the loader and releases resources.
    func destroy() {
        log("Destroying ad loader")
        nativeAd = nil
        adLoader = nil
    }

    // MARK: - Private Methods

    private func sendEvent(_ method: String, arguments: [String: Any]) {
        DispatchQueue.main.async { [weak self] in
            self?.channel.invokeMethod(method, arguments: arguments)
        }
    }

    private func log(_ message: String) {
        if enableDebugLogs {
            print("[NativeAdLoader][\(controllerId)] \(message)")
        }
    }
}

// MARK: - GADAdLoaderDelegate

extension NativeAdLoader: GADAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
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

// MARK: - GADNativeAdLoaderDelegate

extension NativeAdLoader: GADNativeAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        log("Native ad received")

        self.nativeAd = nativeAd
        nativeAd.delegate = self

        sendEvent("onAdLoaded", arguments: [
            "controllerId": controllerId
        ])

        delegate?.adLoader(self, didReceiveNativeAd: nativeAd)
    }
}

// MARK: - GADNativeAdDelegate

extension NativeAdLoader: GADNativeAdDelegate {

    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        log("Ad clicked")
        sendEvent("onAdClicked", arguments: [
            "controllerId": controllerId
        ])
    }

    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        log("Ad impression recorded")
        sendEvent("onAdImpression", arguments: [
            "controllerId": controllerId
        ])
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        log("Ad will present screen")
        sendEvent("onAdOpened", arguments: [
            "controllerId": controllerId
        ])
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        log("Ad dismissed screen")
        sendEvent("onAdClosed", arguments: [
            "controllerId": controllerId
        ])
    }
}
