import Flutter
import UIKit
import GoogleMobileAds

/// Platform view that displays a native ad.
class NativeAdPlatformView: NSObject, FlutterPlatformView {

    private let containerView: UIView
    private var nativeAdView: GADNativeAdView?
    private var adLoader: NativeAdLoader?
    private let styleOptions: AdStyleOptions
    private let styleManager: AdStyleManager
    private let enableDebugLogs: Bool
    private let layoutType: String

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

        super.init()

        containerView.backgroundColor = .clear

        log("Initializing platform view with layout: \(layoutType)")

        initializeAdLoader(creationParams: creationParams, messenger: messenger)
    }

    func view() -> UIView {
        return containerView
    }

    // MARK: - Private Methods

    private func initializeAdLoader(creationParams: [String: Any], messenger: FlutterBinaryMessenger) {
        guard let adUnitId = creationParams["adUnitId"] as? String,
              let controllerId = creationParams["controllerId"] as? String else {
            log("Invalid adUnitId or controllerId")
            return
        }

        let isPreloaded = creationParams["isPreloaded"] as? Bool ?? false

        // Check for preloaded ad first
        if isPreloaded {
            if let preloadedAd = FlutterAdmobNativeAdsPlugin.shared()?.getPreloadedAd(controllerId: controllerId) {
                log("Using preloaded ad for controller: \(controllerId)")
                onAdLoaded(preloadedAd)
                return
            }
            log("Preloaded ad not found for controller: \(controllerId), falling back to load")
        }

        // Fallback: load ad normally
        let channel = FlutterMethodChannel(
            name: "flutter_admob_native_ads",
            binaryMessenger: messenger
        )

        adLoader = NativeAdLoader(
            adUnitId: adUnitId,
            controllerId: controllerId,
            channel: channel,
            enableDebugLogs: enableDebugLogs
        )

        adLoader?.delegate = self
        adLoader?.loadAd()
    }

    private func onAdLoaded(_ nativeAd: GADNativeAd) {
        log("Ad loaded, building layout")

        // Remove old view if exists
        nativeAdView?.removeFromSuperview()

        // Build the layout
        let layoutTypeInt = AdLayoutBuilder.getLayoutType(from: layoutType)
        nativeAdView = AdLayoutBuilder.buildLayout(
            layoutType: layoutTypeInt,
            styleOptions: styleOptions
        )

        guard let adView = nativeAdView else { return }

        // Populate the ad
        populateAdView(nativeAd)

        // Add to container
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
}

// MARK: - NativeAdLoaderDelegate

extension NativeAdPlatformView: NativeAdLoaderDelegate {

    func adLoader(_ loader: NativeAdLoader, didReceiveNativeAd nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            self?.onAdLoaded(nativeAd)
        }
    }

    func adLoader(_ loader: NativeAdLoader, didFailWithError error: Error) {
        log("Ad loader failed: \(error.localizedDescription)")
    }
}
