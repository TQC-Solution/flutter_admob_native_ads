import UIKit
import GoogleMobileAds

/// Form1 Builder - Compact Horizontal Layout (ad_1.png)
/// Layout: [Icon] [Ad] Title / Body [CTA Button]
enum Form1Builder {
    
    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        // Main horizontal container
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
        
        // Icon (Left)
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        mainStack.addArrangedSubview(iconView)
        
        // Middle content (Ad label + Title + Body)
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 2
        contentStack.alignment = .leading
        
        // Title row with Ad label
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
        let padH: CGFloat = 6
        let padV: CGFloat = 2
        adLabel.layoutMargins = UIEdgeInsets(top: padV, left: padH, bottom: padV, right: padH)
        adLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleRow.addArrangedSubview(adLabel)
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 15, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        titleRow.addArrangedSubview(headlineLabel)
        contentStack.addArrangedSubview(titleRow)
        
        // Body text
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1)
        bodyLabel.numberOfLines = 1
        contentStack.addArrangedSubview(bodyLabel)
        
        mainStack.addArrangedSubview(contentStack)
        
        // CTA Button (Right)
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.setContentHuggingPriority(.required, for: .horizontal)
        ctaButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        styleManager.styleButton(ctaButton)
        mainStack.addArrangedSubview(ctaButton)
        
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
        nativeAdView.callToActionView = ctaButton
        
        return nativeAdView
    }
}
