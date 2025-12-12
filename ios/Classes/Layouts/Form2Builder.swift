import UIKit
import GoogleMobileAds

/// Builder for Form 2 - Standard Layout.
///
/// Layout structure:
/// GADNativeAdView
/// └── Container (UIView with padding)
///     ├── UILabel (Ad Label - top right)
///     └── UIStackView (Vertical)
///         ├── UIStackView (Header - Horizontal)
///         │   ├── UIImageView (Icon - 48pt)
///         │   └── UIStackView (Vertical)
///         │       ├── UILabel (Headline)
///         │       └── StarRatingView
///         ├── GADMediaView (200pt height)
///         ├── UILabel (Body - max 3 lines)
///         ├── UIStackView (Footer - Horizontal)
///         │   ├── UILabel (Price)
///         │   ├── UILabel (Store)
///         │   └── UILabel (Advertiser)
///         └── UIButton (CTA - full width)
enum Form2Builder {

    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Apply container styles
        styleManager.applyContainerStyle(to: nativeAdView)

        // Create main vertical stack
        let mainStack = createVerticalStack(
            spacing: styleManager.sectionSpacing,
            alignment: .fill
        )

        // === Header Section ===
        let headerStack = buildHeaderSection(styleManager: styleManager)

        // === Media View ===
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleMediaView(mediaView)
        mediaView.heightAnchor.constraint(equalToConstant: styleManager.mediaViewHeight).isActive = true

        // === Body ===
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleBody(bodyLabel)
        bodyLabel.isHidden = true

        // === Footer Section ===
        let (footerStack, priceLabel, storeLabel, advertiserLabel) = buildFooterSection(styleManager: styleManager)

        // === CTA Button ===
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleButton(ctaButton)

        // Assemble main stack
        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(mediaView)
        mainStack.addArrangedSubview(bodyLabel)
        mainStack.addArrangedSubview(footerStack)
        mainStack.addArrangedSubview(ctaButton)

        // Add to native ad view
        nativeAdView.addSubview(mainStack)

        // Layout main stack with padding
        let padding = styleManager.options.containerPadding
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: padding.top),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: padding.left),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -padding.right),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -padding.bottom)
        ])

        // Add Ad label if enabled
        if styleManager.shouldShowAdLabel {
            let adLabel = styleManager.createAdLabel()
            adLabel.translatesAutoresizingMaskIntoConstraints = false
            nativeAdView.addSubview(adLabel)

            NSLayoutConstraint.activate([
                adLabel.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: padding.top),
                adLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -padding.right)
            ])
        }

        // Map views to GADNativeAdView
        // Find icon and headline from header
        if let iconView = headerStack.arrangedSubviews.first as? UIImageView {
            nativeAdView.iconView = iconView
        }
        if let infoStack = headerStack.arrangedSubviews.last as? UIStackView,
           let headlineLabel = infoStack.arrangedSubviews.first as? UILabel {
            nativeAdView.headlineView = headlineLabel
        }

        nativeAdView.mediaView = mediaView
        nativeAdView.bodyView = bodyLabel
        nativeAdView.priceView = priceLabel
        nativeAdView.storeView = storeLabel
        nativeAdView.advertiserView = advertiserLabel
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }

    private static func buildHeaderSection(styleManager: AdStyleManager) -> UIStackView {
        let headerStack = createHorizontalStack(
            spacing: styleManager.itemSpacing,
            alignment: .center
        )

        // Icon
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        styleManager.styleIcon(iconView)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: styleManager.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: styleManager.iconSize)
        ])

        // Info stack
        let infoStack = createVerticalStack(
            spacing: styleManager.itemSpacing / 2,
            alignment: .leading
        )

        // Headline
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleHeadline(headlineLabel)

        // Rating placeholder
        let ratingContainer = UIView()
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.isHidden = true
        ratingContainer.tag = 1001

        infoStack.addArrangedSubview(headlineLabel)
        infoStack.addArrangedSubview(ratingContainer)

        headerStack.addArrangedSubview(iconView)
        headerStack.addArrangedSubview(infoStack)

        return headerStack
    }

    private static func buildFooterSection(styleManager: AdStyleManager) -> (UIStackView, UILabel, UILabel, UILabel) {
        let footerStack = createHorizontalStack(
            spacing: styleManager.itemSpacing,
            alignment: .center
        )
        footerStack.isHidden = true

        // Price
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.stylePrice(priceLabel)
        priceLabel.isHidden = true

        // Store
        let storeLabel = UILabel()
        storeLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleStore(storeLabel)
        storeLabel.isHidden = true

        // Spacer
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        // Advertiser
        let advertiserLabel = UILabel()
        advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleAdvertiser(advertiserLabel)
        advertiserLabel.isHidden = true

        footerStack.addArrangedSubview(priceLabel)
        footerStack.addArrangedSubview(storeLabel)
        footerStack.addArrangedSubview(spacer)
        footerStack.addArrangedSubview(advertiserLabel)

        return (footerStack, priceLabel, storeLabel, advertiserLabel)
    }
}
