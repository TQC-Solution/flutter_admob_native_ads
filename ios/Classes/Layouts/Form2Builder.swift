import UIKit
import GoogleMobileAds

/// Form2 Builder - Horizontal with Square Media (ad_2.png)
/// Layout: [Square Media] [Ad] Title / Body [CTA Button]
enum Form2Builder {
    
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        mainStack.spacing = 12
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.backgroundColor = .white
        mainStack.layer.cornerRadius = 8
        mainStack.clipsToBounds = true
        
        // Media View (Left) - Square
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        mediaView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        mainStack.addArrangedSubview(mediaView)
        
        // Middle content
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 2
        contentStack.alignment = .leading
        
        let titleRow = UIStackView()
        titleRow.axis = .horizontal
        titleRow.spacing = 6
        titleRow.alignment = .center
        
        let adLabel = UILabel()
        adLabel.text = "Ad"
        adLabel.font = .systemFont(ofSize: 10, weight: .bold)
        adLabel.textColor = UIColor(red: 0.36, green: 0.25, blue: 0.22, alpha: 1)
        adLabel.backgroundColor = UIColor(red: 1.0, green: 0.88, blue: 0.7, alpha: 1)
        adLabel.layer.cornerRadius = 3
        adLabel.clipsToBounds = true
        adLabel.textAlignment = .center
        adLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleRow.addArrangedSubview(adLabel)
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 15, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        titleRow.addArrangedSubview(headlineLabel)
        contentStack.addArrangedSubview(titleRow)
        
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1)
        bodyLabel.numberOfLines = 1
        contentStack.addArrangedSubview(bodyLabel)
        
        mainStack.addArrangedSubview(contentStack)
        
        // CTA Button
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.backgroundColor = UIColor(red: 0.26, green: 0.52, blue: 0.96, alpha: 1)
        ctaButton.layer.cornerRadius = 18
        ctaButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        ctaButton.setContentHuggingPriority(.required, for: .horizontal)
        mainStack.addArrangedSubview(ctaButton)
        
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
