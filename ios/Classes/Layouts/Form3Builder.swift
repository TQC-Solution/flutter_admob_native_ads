import UIKit
import GoogleMobileAds

/// Form3 Builder - Vertical Card with Large Media Bottom (ad_3.png)
/// Layout: [Icon + Ad + Title + Body] → [Large Media] → [CTA]
enum Form3Builder {
    
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
        
        // Header row
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
        
        let adLabel = PaddingLabel()
        adLabel.text = "Ad"
        adLabel.font = .systemFont(ofSize: 10, weight: .bold)
        adLabel.textColor = UIColor(red: 0.36, green: 0.25, blue: 0.22, alpha: 1)
        adLabel.backgroundColor = UIColor(red: 1.0, green: 0.88, blue: 0.7, alpha: 1)
        adLabel.layer.cornerRadius = 3
        adLabel.clipsToBounds = true
        adLabel.textInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        adLabel.setContentHuggingPriority(.required, for: .horizontal)
        headerRow.addArrangedSubview(adLabel)
        
        let headlineLabel = UILabel()
        headlineLabel.font = .systemFont(ofSize: 14, weight: .bold)
        headlineLabel.textColor = .black
        headlineLabel.numberOfLines = 1
        headerRow.addArrangedSubview(headlineLabel)
        
        mainStack.addArrangedSubview(headerRow)
        
        // Body
        let bodyLabel = UILabel()
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = UIColor(white: 0.46, alpha: 1)
        bodyLabel.numberOfLines = 1
        mainStack.addArrangedSubview(bodyLabel)
        
        // Media View
        let mediaView = GADMediaView()
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = 8
        mediaView.clipsToBounds = true
        mediaView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        mainStack.addArrangedSubview(mediaView)
        
        // CTA Button
        let ctaButton = UIButton(type: .system)
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
        nativeAdView.mediaView = mediaView
        nativeAdView.callToActionView = ctaButton
        
        return nativeAdView
    }
}

// Helper class for padding
class PaddingLabel: UILabel {
    var textInsets = UIEdgeInsets.zero
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
