import UIKit
import GoogleMobileAds

/// Form6 Builder - Vertical Smaller Media (ad_6.png)
/// Layout: Column[Row[Icon + Column[Row[AD + Title] + Body]] + Media + CTA]
enum Form6Builder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Main vertical container
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .fill
        styleManager.styleMainContainer(mainStack)

        // Inner content container with background color
        let contentContainer = UIStackView()
        contentContainer.axis = .vertical
        contentContainer.spacing = 12
        contentContainer.alignment = .fill
        contentContainer.backgroundColor = UIColor(red: 0.945, green: 0.914, blue: 0.914, alpha: 1) // #F1E9E9
        contentContainer.layer.cornerRadius = 8
        contentContainer.clipsToBounds = true
        contentContainer.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        contentContainer.isLayoutMarginsRelativeArrangement = true

        // Header row: Icon + Right column
        let headerRow = UIStackView()
        headerRow.axis = .horizontal
        headerRow.spacing = 8
        headerRow.alignment = .top

        // Icon (Left)
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        headerRow.addArrangedSubview(iconView)

        // Right column: Title row + Body
        let rightColumn = UIStackView()
        rightColumn.axis = .vertical
        rightColumn.spacing = 4
        rightColumn.alignment = .fill

        // Title row with Ad label
        let titleRow = UIStackView()
        titleRow.axis = .horizontal
        titleRow.spacing = 2
        titleRow.alignment = .center

        // Ad label container
        let adLabel = UILabel()
        adLabel.text = "AD"
        adLabel.font = .systemFont(ofSize: 8, weight: .bold)
        adLabel.textColor = .white
        adLabel.backgroundColor = .clear
        adLabel.textAlignment = .center

        let container = UIView()
        container.backgroundColor = UIColor(red: 0.996, green: 0.765, blue: 0.094, alpha: 1)
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
        titleRow.addArrangedSubview(container)

        // Headline (takes remaining space)
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 2
        titleRow.addArrangedSubview(headlineLabel)
        rightColumn.addArrangedSubview(titleRow)

        // Body text
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1)
        bodyLabel.numberOfLines = 2
        rightColumn.addArrangedSubview(bodyLabel)

        headerRow.addArrangedSubview(rightColumn)
        contentContainer.addArrangedSubview(headerRow)

        // Media view (120dp height)
        let mediaView = GADMediaView()
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        contentContainer.addArrangedSubview(mediaView)

        // CTA Button
        let ctaButton = UIButton(type: .system)
        styleManager.styleButton(ctaButton)
        contentContainer.addArrangedSubview(ctaButton)

        mainStack.addArrangedSubview(contentContainer)
        nativeAdView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor)
        ])
        
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.mediaView = mediaView
        nativeAdView.callToActionView = ctaButton
        return nativeAdView
    }
}
