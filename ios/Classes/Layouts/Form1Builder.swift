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
        mainStack.spacing = 8
        mainStack.alignment = .center
        mainStack.distribution = .fill
        styleManager.styleMainContainer(mainStack)
        
        // Icon (Left)
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true
        iconView.widthAnchor.constraint(equalToConstant: 42).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        mainStack.addArrangedSubview(iconView)
        
        // Middle content (Ad label + Title + Body)
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 2
        contentStack.alignment = .leading
        
        // Title row with Ad label
        let titleRow = UIStackView()
        titleRow.axis = .horizontal
        titleRow.spacing = 2
        titleRow.alignment = .center
        
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
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 2
        titleRow.addArrangedSubview(headlineLabel)
        contentStack.addArrangedSubview(titleRow)
        
        // Body text
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 10)
        bodyLabel.textColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1) // #838383
        bodyLabel.numberOfLines = 2
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
        
        let contentPadding: CGFloat = 8
        NSLayoutConstraint.activate([
            // mainStack.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: contentPadding),
            mainStack.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            // mainStack.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -contentPadding)
        ])
        
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.callToActionView = ctaButton
        
        return nativeAdView
    }
}