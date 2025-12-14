import UIKit
import GoogleMobileAds

/// Form7 Builder - Horizontal Large Media Left (ad_7.png)
enum Form7Builder {
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.backgroundColor = .white
        mainStack.layer.cornerRadius = 12
        mainStack.clipsToBounds = true
        
        let mediaView = GADMediaView()
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        mainStack.addArrangedSubview(mediaView)
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .leading
        
        let adLabel = UILabel()
        adLabel.text = "Ad"
        adLabel.font = .systemFont(ofSize: 10, weight: .bold)
        adLabel.textColor = UIColor(red: 0.36, green: 0.25, blue: 0.22, alpha: 1)
        adLabel.backgroundColor = UIColor(red: 1.0, green: 0.88, blue: 0.7, alpha: 1)
        adLabel.layer.cornerRadius = 3
        adLabel.clipsToBounds = true
        rightStack.addArrangedSubview(adLabel)
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 2
        rightStack.addArrangedSubview(headlineLabel)
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1)
        bodyLabel.numberOfLines = 2
        rightStack.addArrangedSubview(bodyLabel)
        
        let ctaButton = UIButton(type: .system)
        ctaButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.backgroundColor = UIColor(red: 0.26, green: 0.52, blue: 0.96, alpha: 1)
        ctaButton.layer.cornerRadius = 18
        ctaButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        rightStack.addArrangedSubview(ctaButton)
        
        mainStack.addArrangedSubview(rightStack)
        
        nativeAdView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor)
        ])
        
        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = ctaButton
        return nativeAdView
    }
}
