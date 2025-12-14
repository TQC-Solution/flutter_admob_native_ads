import UIKit
import GoogleMobileAds

/// Form4 Builder - Vertical Media Top (ad_4.png)
enum Form4Builder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .fill
        mainStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.backgroundColor = .white
        mainStack.layer.cornerRadius = 12
        mainStack.clipsToBounds = true
        
        let mediaView = GADMediaView()
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        mainStack.addArrangedSubview(mediaView)
        
        let headerRow = UIStackView()
        headerRow.axis = .horizontal
        headerRow.spacing = 8
        headerRow.alignment = .center
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        headerRow.addArrangedSubview(iconView)
        
        let adLabel = UILabel()
        adLabel.text = "Ad"
        adLabel.font = .systemFont(ofSize: 10, weight: .bold)
        adLabel.textColor = UIColor(red: 0.36, green: 0.25, blue: 0.22, alpha: 1)
        adLabel.backgroundColor = UIColor(red: 1.0, green: 0.88, blue: 0.7, alpha: 1)
        adLabel.layer.cornerRadius = 3
        adLabel.clipsToBounds = true
        headerRow.addArrangedSubview(adLabel)
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        headerRow.addArrangedSubview(headlineLabel)
        mainStack.addArrangedSubview(headerRow)
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1)
        bodyLabel.numberOfLines = 1
        mainStack.addArrangedSubview(bodyLabel)
        
        let ctaButton = UIButton(type: .system)
        ctaButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.backgroundColor = UIColor(red: 0.26, green: 0.52, blue: 0.96, alpha: 1)
        ctaButton.layer.cornerRadius = 24
        ctaButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        mainStack.addArrangedSubview(ctaButton)
        
        nativeAdView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor)
        ])
        
        nativeAdView.mediaView = mediaView
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = ctaButton
        return nativeAdView
    }
}
