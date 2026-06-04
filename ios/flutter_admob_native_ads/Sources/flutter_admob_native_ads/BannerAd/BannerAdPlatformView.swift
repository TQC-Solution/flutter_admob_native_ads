import Flutter
import UIKit
import GoogleMobileAds

/// Platform view for displaying banner ads.
class BannerAdPlatformView: NSObject, FlutterPlatformView {

    private let containerView: UIView
    private var bannerView: BannerView?
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

    /// Registers with the plugin to receive ad updates.
    /// IMPORTANT: Register callback FIRST, then check existing ad to avoid race condition.
    private func registerForAdUpdates() {
        guard let controllerId = controllerId else {
            log("Invalid controllerId, cannot register for ad updates")
            return
        }

        // Register callback FIRST to avoid missing ads that load between check and register
        FlutterAdmobNativeAdsPlugin.shared()?.registerBannerAdCallback(controllerId: controllerId) { [weak self] bannerView in
            self?.onAdLoaded(bannerView)
        }

        // THEN check if ad is already loaded (from cache)
        if let existingBannerView = FlutterAdmobNativeAdsPlugin.shared()?.getBannerAd(controllerId: controllerId) {
            onAdLoaded(existingBannerView)
        }
    }

    private func onAdLoaded(_ view: BannerView) {
        // Remove old banner view if exists
        if let oldBanner = bannerView {
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

        // Register this view for pause/resume rendering (fix GPU crashes)
        if let controllerId = controllerId {
            FlutterAdmobNativeAdsPlugin.shared()?.registerActiveBannerAdView(controllerId: controllerId, view: view)
            log("Registered banner view for pause/resume rendering")
        }
    }

    private func log(_ message: String) {
        if enableDebugLogs {
            print("[BannerAdPlatformView] \(message)")
        }
    }

    deinit {
        // Unregister from pause/resume tracking
        if let controllerId = controllerId {
            FlutterAdmobNativeAdsPlugin.shared()?.unregisterActiveBannerAdView(controllerId: controllerId)
        }

        if let controllerId = controllerId {
            FlutterAdmobNativeAdsPlugin.shared()?.unregisterBannerAdCallback(controllerId: controllerId)
        }
    }
}
