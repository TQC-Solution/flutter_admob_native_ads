import Flutter
import UIKit
import GoogleMobileAds

/// Platform view for displaying banner ads.
class BannerAdPlatformView: NSObject, FlutterPlatformView {

    private let containerView: UIView
    private var bannerView: GADBannerView?
    private let enableDebugLogs: Bool
    private let controllerId: String?

    init(
        frame: CGRect,
        viewId: Int64,
        creationParams: [String: Any],
        messenger: FlutterBinaryMessenger
    ) {
        self.containerView = UIView(frame: frame)
        self.enableDebugLogs = creationParams["enableDebugLogs"] as? Bool ?? false
        self.controllerId = creationParams["controllerId"] as? String

        super.init()

        containerView.backgroundColor = .clear

        log("Initializing banner platform view")

        registerForAdUpdates()
    }

    func view() -> UIView {
        return containerView
    }

    private func registerForAdUpdates() {
        guard let controllerId = controllerId else {
            log("Invalid controllerId, cannot register for ad updates")
            return
        }

        log("Registering for banner ad updates for controller: \(controllerId)")

        // Check if ad is already loaded
        if let existingBannerView = FlutterAdmobNativeAdsPlugin.shared()?.getBannerAd(controllerId: controllerId) {
            log("Banner ad already loaded, adding to container immediately")
            onAdLoaded(existingBannerView)
        }

        FlutterAdmobNativeAdsPlugin.shared()?.registerBannerAdCallback(controllerId: controllerId) { [weak self] bannerView in
            self?.onAdLoaded(bannerView)
        }
    }

    private func onAdLoaded(_ view: GADBannerView) {
        log("Banner ad loaded, adding to container. Banner size: \(view.bounds.size)")

        // Remove old banner view if exists
        if let oldBanner = bannerView {
            log("Removing old banner view")
            oldBanner.removeFromSuperview()
        }

        bannerView = view

        containerView.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        log("Banner added to container with constraints. Container frame: \(containerView.bounds)")
    }

    private func log(_ message: String) {
        if enableDebugLogs {
            print("[BannerAdPlatformView] \(message)")
        }
    }

    deinit {
        if let controllerId = controllerId {
            FlutterAdmobNativeAdsPlugin.shared()?.unregisterBannerAdCallback(controllerId: controllerId)
        }
    }
}
