import UIKit
import GoogleMobileAds

/// Manager for applying styles to native ad views.
class AdStyleManager {

    let options: AdStyleOptions

    init(options: AdStyleOptions) {
        self.options = options
    }

    // MARK: - Container Styling

    /// Applies container styles to the NativeAdView.
    func applyContainerStyle(to view: GADNativeAdView) {
        view.backgroundColor = options.containerBackgroundColor
        view.layer.cornerRadius = options.containerCornerRadius
        view.clipsToBounds = true

        if let borderColor = options.containerBorderColor,
           let borderWidth = options.containerBorderWidth {
            view.layer.borderColor = borderColor.cgColor
            view.layer.borderWidth = borderWidth
        }

        if let shadowColor = options.containerShadowColor,
           let shadowRadius = options.containerShadowRadius {
            view.layer.masksToBounds = false
            view.layer.shadowColor = shadowColor.cgColor
            view.layer.shadowRadius = shadowRadius
            view.layer.shadowOpacity = 0.3
            view.layer.shadowOffset = options.containerShadowOffset ?? CGSize(width: 0, height: 2)
        }
    }

    // MARK: - Button Styling

    /// Applies styles to the CTA button.
    func styleButton(_ button: UIButton) {
        button.backgroundColor = options.ctaBackgroundColor
        button.setTitleColor(options.ctaTextColor, for: .normal)
        button.titleLabel?.font = getFont(
            size: options.ctaFontSize,
            weight: options.ctaFontWeight,
            family: nil
        )

        // Calculate estimated button height based on font size and padding
        // This ensures cornerRadius doesn't exceed half the button height (pill shape)
        let estimatedHeight = options.ctaFontSize + options.ctaPadding.top + options.ctaPadding.bottom
        let maxCornerRadius = estimatedHeight / 2
        button.layer.cornerRadius = min(options.ctaCornerRadius, maxCornerRadius)
        button.clipsToBounds = true

        button.contentEdgeInsets = options.ctaPadding

        if let borderColor = options.ctaBorderColor,
           let borderWidth = options.ctaBorderWidth {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = borderWidth
        }

        if let elevation = options.ctaElevation {
            button.layer.masksToBounds = false
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowRadius = elevation
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: elevation / 2)
        }
    }

    // MARK: - Label Styling

    /// Applies headline text styles.
    func styleHeadline(_ label: UILabel) {
        label.textColor = options.headlineTextColor
        label.font = getFont(
            size: options.headlineFontSize,
            weight: options.headlineFontWeight,
            family: options.headlineFontFamily
        )
        label.numberOfLines = options.headlineMaxLines
        label.lineBreakMode = .byTruncatingTail
    }

    /// Applies body text styles.
    func styleBody(_ label: UILabel) {
        label.textColor = options.bodyTextColor
        label.font = getFont(
            size: options.bodyFontSize,
            weight: options.bodyFontWeight,
            family: options.bodyFontFamily
        )
        label.numberOfLines = options.bodyMaxLines
        label.lineBreakMode = .byTruncatingTail
    }

    /// Applies price text styles.
    func stylePrice(_ label: UILabel) {
        label.textColor = options.priceTextColor
        label.font = .systemFont(ofSize: options.priceFontSize)
    }

    /// Applies store text styles.
    func styleStore(_ label: UILabel) {
        label.textColor = options.storeTextColor
        label.font = .systemFont(ofSize: options.storeFontSize)
    }

    /// Applies advertiser text styles.
    func styleAdvertiser(_ label: UILabel) {
        label.textColor = options.advertiserTextColor
        label.font = .systemFont(ofSize: options.advertiserFontSize)
    }

    // MARK: - Image Styling

    /// Applies icon image styles.
    func styleIcon(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = options.iconCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        if let borderColor = options.iconBorderColor,
           let borderWidth = options.iconBorderWidth {
            imageView.layer.borderColor = borderColor.cgColor
            imageView.layer.borderWidth = borderWidth
        }
    }

    /// Applies media view styles.
    func styleMediaView(_ mediaView: GADMediaView) {
        mediaView.layer.cornerRadius = options.mediaViewCornerRadius
        mediaView.clipsToBounds = true
        mediaView.contentMode = .scaleAspectFill

        if let bgColor = options.mediaViewBackgroundColor {
            mediaView.backgroundColor = bgColor
        }
    }

    // MARK: - Star Rating

    /// Creates a star rating view.
    func createStarRatingView(rating: Double) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center

        let fullStars = Int(rating)
        let hasHalfStar = rating - Double(fullStars) >= 0.5

        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit

            let config = UIImage.SymbolConfiguration(pointSize: options.starRatingSize)

            if i < fullStars {
                starImageView.image = UIImage(systemName: "star.fill", withConfiguration: config)
                starImageView.tintColor = options.starRatingActiveColor
            } else if i == fullStars && hasHalfStar {
                starImageView.image = UIImage(systemName: "star.leadinghalf.filled", withConfiguration: config)
                starImageView.tintColor = options.starRatingActiveColor
            } else {
                starImageView.image = UIImage(systemName: "star", withConfiguration: config)
                starImageView.tintColor = options.starRatingInactiveColor
            }

            stackView.addArrangedSubview(starImageView)
        }

        return stackView
    }

    // MARK: - Ad Label

    /// Creates and styles the "Ad" label view.
    func createAdLabel() -> UILabel {
        let label = PaddedLabel()
        label.text = options.adLabelText
        label.textColor = options.adLabelTextColor
        label.font = .boldSystemFont(ofSize: options.adLabelFontSize)
        label.backgroundColor = options.adLabelBackgroundColor
        label.layer.cornerRadius = options.adLabelCornerRadius
        label.clipsToBounds = true
        label.textInsets = options.adLabelPadding
        return label
    }

    // MARK: - Main Container Styling

    /// Applies styles to the main container (UIStackView).
    func styleMainContainer(_ stackView: UIStackView) {
        stackView.backgroundColor = options.containerBackgroundColor
        stackView.layer.cornerRadius = options.containerCornerRadius
        stackView.clipsToBounds = true
        stackView.layoutMargins = options.containerPadding
        stackView.isLayoutMarginsRelativeArrangement = true

        if let borderColor = options.containerBorderColor,
           let borderWidth = options.containerBorderWidth {
            stackView.layer.borderColor = borderColor.cgColor
            stackView.layer.borderWidth = borderWidth
        }
    }

    var containerCornerRadius: CGFloat {
        return options.containerCornerRadius
    }

    var containerBackgroundColor: UIColor {
        return options.containerBackgroundColor
    }

    var containerPadding: UIEdgeInsets {
        return options.containerPadding
    }

    // MARK: - Helpers

    var shouldShowAdLabel: Bool {
        return options.showAdLabel
    }

    var itemSpacing: CGFloat {
        return options.itemSpacing
    }

    var sectionSpacing: CGFloat {
        return options.sectionSpacing
    }

    var iconSize: CGFloat {
        return options.iconSize
    }

    var mediaViewHeight: CGFloat {
        return options.mediaViewHeight
    }

    private func getFont(size: CGFloat, weight: UIFont.Weight, family: String?) -> UIFont {
        if let family = family,
           let font = UIFont(name: family, size: size) {
            return font
        }
        return .systemFont(ofSize: size, weight: weight)
    }
}

// MARK: - PaddedLabel

/// A UILabel subclass that supports padding/insets.
class PaddedLabel: UILabel {

    var textInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }
}
