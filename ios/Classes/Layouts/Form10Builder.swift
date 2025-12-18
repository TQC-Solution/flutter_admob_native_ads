import UIKit
import GoogleMobileAds

/// Form10 Builder - Minimal Text Only (ad_10.png)
enum Form10Builder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Main vertical stack
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.alignment = .fill
        styleManager.styleMainContainer(mainStack)

        // Title label
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        headlineLabel.lineBreakMode = .byTruncatingTail
        mainStack.addArrangedSubview(headlineLabel)

        // Ad badge container (left-aligned within stack)
        let adBadgeContainer = UIView()
        adBadgeContainer.translatesAutoresizingMaskIntoConstraints = false

        let adLabel = UILabel()
        adLabel.text = "AD"
        adLabel.font = .systemFont(ofSize: 8, weight: .bold)
        adLabel.textColor = UIColor(red: 1.0, green: 0.753, blue: 0.0, alpha: 1)
        adLabel.backgroundColor = .clear
        adLabel.textAlignment = .center

        let adBadge = UIView()
        adBadge.translatesAutoresizingMaskIntoConstraints = false
        adBadge.backgroundColor = .clear
        adBadge.layer.cornerRadius = 4
        adBadge.layer.borderWidth = 1
        adBadge.layer.borderColor = UIColor(red: 1.0, green: 0.753, blue: 0.0, alpha: 1).cgColor
        adBadge.clipsToBounds = true
        adBadge.addSubview(adLabel)
        adLabel.translatesAutoresizingMaskIntoConstraints = false

        adBadgeContainer.addSubview(adBadge)

        NSLayoutConstraint.activate([
            adLabel.topAnchor.constraint(equalTo: adBadge.topAnchor, constant: 2),
            adLabel.bottomAnchor.constraint(equalTo: adBadge.bottomAnchor, constant: -2),
            adLabel.leadingAnchor.constraint(equalTo: adBadge.leadingAnchor, constant: 4),
            adLabel.trailingAnchor.constraint(equalTo: adBadge.trailingAnchor, constant: -4),

            adBadge.leadingAnchor.constraint(equalTo: adBadgeContainer.leadingAnchor),
            adBadge.topAnchor.constraint(equalTo: adBadgeContainer.topAnchor),
            adBadge.bottomAnchor.constraint(equalTo: adBadgeContainer.bottomAnchor),
        ])
        mainStack.addArrangedSubview(adBadgeContainer)

        // Body text
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 11)
        bodyLabel.textColor = UIColor(white: 0.4, alpha: 1)
        bodyLabel.numberOfLines = 2
        bodyLabel.lineBreakMode = .byTruncatingTail
        mainStack.addArrangedSubview(bodyLabel)

        // CTA button (full width)
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        styleManager.styleButton(ctaButton)
        mainStack.addArrangedSubview(ctaButton)

        // Set button height
        NSLayoutConstraint.activate([
            ctaButton.heightAnchor.constraint(equalToConstant: 34)
        ])

        nativeAdView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor)
        ])

        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = ctaButton
        return nativeAdView
    }
}
