import Flutter
import UIKit
import GoogleMobileAds

/// Platform view that displays a native ad.
class NativeAdPlatformView: NSObject, FlutterPlatformView {

    private let containerView: UIView
    private var nativeAdView: GADNativeAdView?
    private let styleOptions: AdStyleOptions
    private let styleManager: AdStyleManager
    private let enableDebugLogs: Bool
    private let layoutType: String
    private var isLayoutBuilt = false
    private let controllerId: String?

    init(
        frame: CGRect,
        viewId: Int64,
        creationParams: [String: Any],
        messenger: FlutterBinaryMessenger,
        layoutType: String
    ) {
        self.containerView = UIView(frame: frame)
        self.styleOptions = AdStyleOptions.fromMap(creationParams)
        self.styleManager = AdStyleManager(options: styleOptions)
        self.enableDebugLogs = creationParams["enableDebugLogs"] as? Bool ?? false
        self.layoutType = layoutType
        self.controllerId = creationParams["controllerId"] as? String

        super.init()

        containerView.backgroundColor = .clear

        log("Initializing platform view with layout: \(layoutType)")

        // Pre-build the layout once before loading ad
        prebuildLayout()

        // Register to receive ad from plugin's centralized loader
        registerForAdUpdates()
    }

    private func prebuildLayout() {
        log("Pre-building layout structure")
        let layoutTypeInt = AdLayoutBuilder.getLayoutType(from: layoutType)
        nativeAdView = AdLayoutBuilder.buildLayout(
            layoutType: layoutTypeInt,
            styleOptions: styleOptions
        )
        isLayoutBuilt = true
    }

    func view() -> UIView {
        return containerView
    }

    // MARK: - Private Methods

    private func registerForAdUpdates() {
        guard let controllerId = controllerId else {
            log("Invalid controllerId, cannot register for ad updates")
            return
        }

        log("Registering for ad updates for controller: \(controllerId)")

        // Register callback with plugin to receive ad when loaded
        FlutterAdmobNativeAdsPlugin.shared()?.registerAdLoadedCallback(controllerId: controllerId) { [weak self] nativeAd in
            self?.onAdLoaded(nativeAd)
        }
    }

    private func onAdLoaded(_ nativeAd: GADNativeAd) {
        log("Ad loaded, populating view with data")

        // Layout should already be built, just populate data
        if !isLayoutBuilt || nativeAdView == nil {
            log("Layout not pre-built, building now")
            prebuildLayout()
        }

        guard let adView = nativeAdView else { return }

        // Populate the ad data into existing layout
        populateAdView(nativeAd)

        // Add to container if not already added
        if adView.superview == nil {
            containerView.addSubview(adView)

            // Layout constraints
            adView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: containerView.topAnchor),
                adView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                adView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }

    private func populateAdView(_ nativeAd: GADNativeAd) {
        guard let adView = nativeAdView else { return }

        // Headline (required)
        if let headlineLabel = adView.headlineView as? UILabel {
            headlineLabel.text = nativeAd.headline
            headlineLabel.isHidden = false
        }

        // Body
        if let bodyLabel = adView.bodyView as? UILabel, let body = nativeAd.body {
            bodyLabel.text = body
            bodyLabel.isHidden = false
        }

        // Call to Action (required)
        if let ctaButton = adView.callToActionView as? UIButton, let callToAction = nativeAd.callToAction {
            ctaButton.setTitle(callToAction, for: .normal)
            ctaButton.isHidden = false
            ctaButton.isUserInteractionEnabled = false // GADNativeAdView handles taps
        }

        // Icon
        if let iconView = adView.iconView as? UIImageView, let icon = nativeAd.icon {
            iconView.image = icon.image
            iconView.isHidden = false
        }

        // Star Rating
        if let rating = nativeAd.starRating?.doubleValue {
            // Find rating container by tag and add star rating view
            if let ratingContainer = adView.viewWithTag(1001) {
                // Remove existing stars
                ratingContainer.subviews.forEach { $0.removeFromSuperview() }

                let starView = styleManager.createStarRatingView(rating: rating)
                ratingContainer.addSubview(starView)
                starView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    starView.topAnchor.constraint(equalTo: ratingContainer.topAnchor),
                    starView.leadingAnchor.constraint(equalTo: ratingContainer.leadingAnchor),
                    starView.trailingAnchor.constraint(lessThanOrEqualTo: ratingContainer.trailingAnchor),
                    starView.bottomAnchor.constraint(equalTo: ratingContainer.bottomAnchor)
                ])
                ratingContainer.isHidden = false
            }
            adView.starRatingView = adView.viewWithTag(1001)
        }

        // Price
        if let priceLabel = adView.priceView as? UILabel, let price = nativeAd.price {
            priceLabel.text = price
            priceLabel.isHidden = false
            priceLabel.superview?.isHidden = false
        }

        // Store
        if let storeLabel = adView.storeView as? UILabel, let store = nativeAd.store {
            storeLabel.text = store
            storeLabel.isHidden = false
            storeLabel.superview?.isHidden = false
        }

        // Advertiser
        if let advertiserLabel = adView.advertiserView as? UILabel, let advertiser = nativeAd.advertiser {
            advertiserLabel.text = advertiser
            advertiserLabel.isHidden = false
        }

        // Media View
        if let mediaView = adView.mediaView {
            mediaView.mediaContent = nativeAd.mediaContent
        }

        // Register the native ad
        adView.nativeAd = nativeAd

        log("Ad view populated successfully")
    }

    private func log(_ message: String) {
        if enableDebugLogs {
            print("[NativeAdPlatformView] \(message)")
        }
    }

    deinit {
        // Unregister callback from plugin when view is deallocated
        if let controllerId = controllerId {
            FlutterAdmobNativeAdsPlugin.shared()?.unregisterAdLoadedCallback(controllerId: controllerId)
        }
    }
}
