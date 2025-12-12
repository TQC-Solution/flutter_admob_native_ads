import UIKit
import GoogleMobileAds

/// Builder for Form 3 - Full Media Layout.
///
/// Layout structure (larger, more prominent):
/// GADNativeAdView
/// └── Container (UIView with padding)
///     ├── UILabel (Ad Label - top right over media)
///     └── UIStackView (Vertical)
///         ├── GADMediaView (280pt height - prominent)
///         ├── UIStackView (Header - Horizontal)
///         │   ├── UIImageView (Icon - 64pt - larger)
///         │   └── UIStackView (Vertical)
///         │       ├── UILabel (Headline - larger)
///         │       ├── UILabel (Advertiser)
///         │       └── StarRatingView
///         ├── UILabel (Body - max 4 lines)
///         ├── UIStackView (Footer - Horizontal)
///         │   ├── UILabel (Price)
///         │   └── UILabel (Store)
///         └── UIButton (CTA - prominent)
enum Form3Builder {

    private static let mediaHeight: CGFloat = 280
    private static let iconSize: CGFloat = 64

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

        // === Media View (Prominent) ===
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleMediaView(mediaView)
        mediaView.heightAnchor.constraint(equalToConstant: mediaHeight).isActive = true

        // === Header Section ===
        let headerStack = buildHeaderSection(styleManager: styleManager)

        // === Body ===
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleBody(bodyLabel)
        bodyLabel.numberOfLines = 4
        bodyLabel.isHidden = true

        // === Footer Section ===
        let (footerStack, priceLabel, storeLabel) = buildFooterSection(styleManager: styleManager)

        // === CTA Button (Prominent) ===
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleButton(ctaButton)

        // Add extra shadow for prominence
        ctaButton.layer.shadowColor = UIColor.black.cgColor
        ctaButton.layer.shadowRadius = 4
        ctaButton.layer.shadowOpacity = 0.2
        ctaButton.layer.shadowOffset = CGSize(width: 0, height: 2)

        // Assemble main stack
        mainStack.addArrangedSubview(mediaView)
        mainStack.addArrangedSubview(headerStack)
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

        // Add Ad label if enabled (over media)
        if styleManager.shouldShowAdLabel {
            let adLabel = styleManager.createAdLabel()
            adLabel.translatesAutoresizingMaskIntoConstraints = false
            nativeAdView.addSubview(adLabel)

            NSLayoutConstraint.activate([
                adLabel.topAnchor.constraint(equalTo: mediaView.topAnchor, constant: 8),
                adLabel.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: -8)
            ])
        }

        // Map views to GADNativeAdView
        nativeAdView.mediaView = mediaView

        // Find icon, headline, advertiser from header
        if let iconView = headerStack.arrangedSubviews.first as? UIImageView {
            nativeAdView.iconView = iconView
        }
        if let infoStack = headerStack.arrangedSubviews.last as? UIStackView {
            if let headlineLabel = infoStack.arrangedSubviews.first as? UILabel {
                nativeAdView.headlineView = headlineLabel
            }
            if infoStack.arrangedSubviews.count > 1,
               let advertiserLabel = infoStack.arrangedSubviews[1] as? UILabel {
                nativeAdView.advertiserView = advertiserLabel
            }
        }

        nativeAdView.bodyView = bodyLabel
        nativeAdView.priceView = priceLabel
        nativeAdView.storeView = storeLabel
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }

    private static func buildHeaderSection(styleManager: AdStyleManager) -> UIStackView {
        let headerStack = createHorizontalStack(
            spacing: styleManager.sectionSpacing,
            alignment: .center
        )

        // Icon (larger)
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        styleManager.styleIcon(iconView)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize)
        ])

        // Info stack
        let infoStack = createVerticalStack(
            spacing: styleManager.itemSpacing / 2,
            alignment: .leading
        )

        // Headline (larger)
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleHeadline(headlineLabel)
        headlineLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        // Advertiser
        let advertiserLabel = UILabel()
        advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleAdvertiser(advertiserLabel)
        advertiserLabel.isHidden = true

        // Rating placeholder
        let ratingContainer = UIView()
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.isHidden = true
        ratingContainer.tag = 1001

        infoStack.addArrangedSubview(headlineLabel)
        infoStack.addArrangedSubview(advertiserLabel)
        infoStack.addArrangedSubview(ratingContainer)

        headerStack.addArrangedSubview(iconView)
        headerStack.addArrangedSubview(infoStack)

        return headerStack
    }

    private static func buildFooterSection(styleManager: AdStyleManager) -> (UIStackView, UILabel, UILabel) {
        let footerStack = createHorizontalStack(
            spacing: styleManager.sectionSpacing,
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

        footerStack.addArrangedSubview(priceLabel)
        footerStack.addArrangedSubview(storeLabel)

        return (footerStack, priceLabel, storeLabel)
    }
}
