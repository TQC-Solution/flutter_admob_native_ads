import UIKit
import GoogleMobileAds

/// Form9 Builder - CTA Top Layout (ad_9.png)
enum Form9Builder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .fill
        styleManager.styleMainContainer(mainStack)

        // CTA at top
        let ctaButton = UIButton(type: .system)
        styleManager.styleButton(ctaButton)
        mainStack.addArrangedSubview(ctaButton)

        // Content row: Icon + Right column
        let contentRow = UIStackView()
        contentRow.axis = .horizontal
        contentRow.spacing = 8
        contentRow.alignment = .top

        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        contentRow.addArrangedSubview(iconView)

        // Right column: Ad Title Row + Body
        let rightColumn = UIStackView()
        rightColumn.axis = .vertical
        rightColumn.spacing = 4
        rightColumn.alignment = .leading

        // Ad Title Row: Ad label + Headline
        let adTitleRow = UIStackView()
        adTitleRow.axis = .horizontal
        adTitleRow.spacing = 8
        adTitleRow.alignment = .center

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
        adTitleRow.addArrangedSubview(container)
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        adTitleRow.addArrangedSubview(headlineLabel)
        rightColumn.addArrangedSubview(adTitleRow)
        

        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        bodyLabel.numberOfLines = 1
        rightColumn.addArrangedSubview(bodyLabel)

        contentRow.addArrangedSubview(rightColumn)
        mainStack.addArrangedSubview(contentRow)
        
        let mediaView = GADMediaView()
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        mainStack.addArrangedSubview(mediaView)
        
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
