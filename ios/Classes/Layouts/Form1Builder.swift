import UIKit
import GoogleMobileAds

/// Builder for Form 1 - Compact Layout.
///
/// Layout structure:
/// GADNativeAdView
/// └── Container (UIView with padding)
///     ├── UILabel (Ad Label - top right)
///     └── UIStackView (Horizontal)
///         ├── UIImageView (Icon - 48pt)
///         └── UIStackView (Vertical - Content)
///             ├── UILabel (Headline - max 2 lines)
///             ├── StarRatingView (optional)
///             └── UIButton (CTA)
enum Form1Builder {

    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Apply container styles
        styleManager.applyContainerStyle(to: nativeAdView)

        // Create main horizontal stack
        let mainStack = createHorizontalStack(
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

        // Content stack (vertical)
        let contentStack = createVerticalStack(
            spacing: styleManager.itemSpacing / 2,
            alignment: .leading
        )

        // Headline
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleHeadline(headlineLabel)

        // Star rating placeholder (will be replaced when ad loads)
        let ratingContainer = UIView()
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.isHidden = true

        // CTA Button
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleButton(ctaButton)

        // Assemble content stack
        contentStack.addArrangedSubview(headlineLabel)
        contentStack.addArrangedSubview(ratingContainer)
        contentStack.addArrangedSubview(ctaButton)

        // Assemble main stack
        mainStack.addArrangedSubview(iconView)
        mainStack.addArrangedSubview(contentStack)

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
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.callToActionView = ctaButton

        // Store rating container reference (will be used during ad population)
        ratingContainer.tag = 1001 // Custom tag for finding later

        return nativeAdView
    }
}
