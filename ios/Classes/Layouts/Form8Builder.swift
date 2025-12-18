import UIKit
import GoogleMobileAds

/// Form8 Builder - Compact Horizontal Layout (ad_8.png)
/// Layout: Row[Media (left) + Column[Row[Ad Badge + Title] + Body + CTA Button]]
/// Compact layout optimized for mobile
enum Form8Builder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Main horizontal stack containing media (left) and content column (right)
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        styleManager.styleMainContainer(mainStack)

        // Left section: Media view (120x120)
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        mainStack.addArrangedSubview(mediaView)

        // Right section: Vertical stack containing header row, body text, and CTA button
        let contentStack = UIStackView()
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.alignment = .leading
        contentStack.distribution = .equalSpacing
        contentStack.heightAnchor.constraint(equalToConstant: 100).isActive = true

        // Header row: Ad badge + headline
        let headerRow = UIStackView()
        headerRow.axis = .horizontal
        headerRow.spacing = 4
        headerRow.alignment = .center

        // Ad Badge with "AD" text
        let adLabel = UILabel()
        adLabel.text = "AD"
        adLabel.font = .systemFont(ofSize: 8, weight: .bold)
        adLabel.textColor = .white
        adLabel.backgroundColor = .clear
        adLabel.textAlignment = .center

        // Container view for Ad Badge (yellow background with rounded corners)
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.996, green: 0.765, blue: 0.094, alpha: 1) // #FEC318
        container.layer.cornerRadius = 3
        container.clipsToBounds = true
        container.addSubview(adLabel)
        adLabel.translatesAutoresizingMaskIntoConstraints = false
        let padH: CGFloat = 6
        let padV: CGFloat = 2
        NSLayoutConstraint.activate([
            adLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: padV),
            adLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padV),
            adLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padH),
            adLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padH),
        ])
        container.setContentHuggingPriority(.required, for: .horizontal)
        headerRow.addArrangedSubview(container)

        // Headline label (truncates to 1 line)
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        headerRow.addArrangedSubview(headlineLabel)
        contentStack.addArrangedSubview(headerRow)

        // Body text (2 lines max)
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1) // #757575
        bodyLabel.numberOfLines = 2
        contentStack.addArrangedSubview(bodyLabel)

        // CTA button (full width)
        let ctaButton = UIButton(type: .system)
        styleManager.styleButton(ctaButton)
        contentStack.addArrangedSubview(ctaButton)
        mainStack.addArrangedSubview(contentStack)

        // Make CTA button fill full width of content column
        NSLayoutConstraint.activate([
            ctaButton.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            ctaButton.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor)
        ])

        // Add main stack to native ad view
        nativeAdView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor)
        ])

        // Bind ad components to views
        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
