import UIKit
import GoogleMobileAds

/**
 * EXAMPLE CUSTOM BUILDER - Card Style với Gradient Background
 *
 * Đây là ví dụ hoàn chỉnh để bạn tham khảo và phát triển.
 *
 * Layout structure:
 * GADNativeAdView
 * └── UIView (Main Container với gradient background)
 *     ├── UIStackView (Content - Vertical)
 *     │   ├── UIView (Header)
 *     │   │   ├── GADMediaView (Full width với rounded corners)
 *     │   │   └── UIView (Icon overlay - bottom left của media)
 *     │   │       └── UIImageView (Icon - circular với border)
 *     │   ├── UIStackView (Info Section - với padding)
 *     │   │   ├── UILabel (Headline - large, bold)
 *     │   │   ├── UIStackView (Rating + Advertiser - horizontal)
 *     │   │   │   ├── StarRatingView (stars)
 *     │   │   │   └── UILabel (Advertiser)
 *     │   │   ├── UILabel (Body - description)
 *     │   │   └── UIStackView (Footer - Price + Store)
 *     │   │       ├── UILabel (Price - bold)
 *     │   │       └── UILabel (Store - subtle)
 *     │   └── UIButton (CTA - gradient button với shadow)
 *     └── UILabel (Ad Label - top right badge)
 *
 * Custom Features:
 * - Gradient background (blue to purple)
 * - Circular icon với white border overlay trên media
 * - Rounded corners cho tất cả elements
 * - CTA button với gradient và shadow effect
 * - Card elevation và shadow
 * - Ad badge ở góc trên phải
 */
enum FormExampleBuilder {

    // Custom dimensions
    private static let cardCornerRadius: CGFloat = 16
    private static let mediaHeight: CGFloat = 140  // Reduced from 200 to fit in 300px container
    private static let iconSize: CGFloat = 50      // Reduced from 60 to fit better
    private static let iconBorderWidth: CGFloat = 3
    private static let ctaCornerRadius: CGFloat = 24
    private static let cardPadding: CGFloat = 8
    private static let contentPadding: CGFloat = 12  // Reduced from 16 for tighter spacing

    static func build(styleManager: AdStyleManager) -> GADNativeAdView {
        let nativeAdView = GADNativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        // Main container với gradient background
        let mainContainer = createMainContainer()

        // Content vertical stack
        let contentStack = createVerticalStack(spacing: 0, alignment: .fill)
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )

        // === HEADER SECTION (Media + Icon Overlay) ===
        let (headerView, mediaView, iconView) = createHeaderSection()
        contentStack.addArrangedSubview(headerView)

        // === INFO SECTION (Headline, Rating, Body, Footer) ===
        let (infoStack, headlineLabel, ratingContainer, advertiserLabel, bodyLabel, priceLabel, storeLabel) = createInfoSection()
        contentStack.addArrangedSubview(infoStack)

        // === CTA BUTTON (wrapped in container for margins) ===
        let ctaButton = createCtaButton()
        let ctaContainer = UIView()
        ctaContainer.translatesAutoresizingMaskIntoConstraints = false
        ctaContainer.addSubview(ctaButton)

        NSLayoutConstraint.activate([
            ctaButton.topAnchor.constraint(equalTo: ctaContainer.topAnchor, constant: 0),
            ctaButton.leadingAnchor.constraint(equalTo: ctaContainer.leadingAnchor, constant: contentPadding),
            ctaButton.trailingAnchor.constraint(equalTo: ctaContainer.trailingAnchor, constant: -contentPadding),
            ctaButton.bottomAnchor.constraint(equalTo: ctaContainer.bottomAnchor, constant: -contentPadding),
            ctaButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        contentStack.addArrangedSubview(ctaContainer)

        // Add content to main container
        mainContainer.addSubview(contentStack)

        // Add Ad Label badge (top right)
        let adBadge = createAdBadge()
        mainContainer.addSubview(adBadge)

        // Add to native ad view
        nativeAdView.addSubview(mainContainer)

        // Layout constraints
        setupConstraints(
            nativeAdView: nativeAdView,
            mainContainer: mainContainer,
            contentStack: contentStack,
            headerView: headerView,
            mediaView: mediaView,
            iconView: iconView,
            adBadge: adBadge,
            ctaButton: ctaButton
        )

        // Map views to GADNativeAdView
        mapViews(
            nativeAdView: nativeAdView,
            mediaView: mediaView,
            iconView: iconView,
            headlineLabel: headlineLabel,
            ratingContainer: ratingContainer,
            advertiserLabel: advertiserLabel,
            bodyLabel: bodyLabel,
            priceLabel: priceLabel,
            storeLabel: storeLabel,
            ctaButton: ctaButton
        )

        return nativeAdView
    }

    private static func createMainContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Gradient background layer (blue to purple)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#667eea").cgColor, // Blue
            UIColor(hex: "#764ba2").cgColor  // Purple
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = cardCornerRadius

        // Add gradient to container
        container.layer.insertSublayer(gradientLayer, at: 0)

        // Store gradient layer reference để update frame sau
        container.tag = 9999

        // Shadow effect
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.2
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowRadius = 8

        return container
    }

    private static func createHeaderSection() -> (UIView, GADMediaView, UIImageView) {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Media View với rounded corners
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        mediaView.layer.cornerRadius = cardCornerRadius
        mediaView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mediaView.clipsToBounds = true

        // Icon container (bottom left của media)
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false

        // Icon - circular với white border
        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFill
        iconView.backgroundColor = .white
        iconView.layer.cornerRadius = iconSize / 2
        iconView.layer.borderWidth = iconBorderWidth
        iconView.layer.borderColor = UIColor.white.cgColor
        iconView.clipsToBounds = true

        // Shadow cho icon
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.3
        iconView.layer.shadowOffset = CGSize(width: 0, height: 2)
        iconView.layer.shadowRadius = 4
        iconView.layer.masksToBounds = false

        iconContainer.addSubview(iconView)
        headerView.addSubview(mediaView)
        headerView.addSubview(iconContainer)

        // Constraints cho header
        NSLayoutConstraint.activate([
            // Media fills header
            mediaView.topAnchor.constraint(equalTo: headerView.topAnchor),
            mediaView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: mediaHeight),

            // Header height = media height
            headerView.heightAnchor.constraint(equalToConstant: mediaHeight),

            // Icon container bottom left
            iconContainer.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: contentPadding),
            iconContainer.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30), // Overlap
            iconContainer.widthAnchor.constraint(equalToConstant: iconSize),
            iconContainer.heightAnchor.constraint(equalToConstant: iconSize),

            // Icon fills container
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize)
        ])

        return (headerView, mediaView, iconView)
    }

    private static func createInfoSection() -> (UIStackView, UILabel, UIView, UILabel, UILabel, UILabel, UILabel) {
        let infoStack = createVerticalStack(spacing: 8, alignment: .fill)
        infoStack.isLayoutMarginsRelativeArrangement = true
        infoStack.layoutMargins = UIEdgeInsets(
            top: contentPadding + 30, // Extra space cho icon overlap
            left: contentPadding,
            bottom: contentPadding,
            right: contentPadding
        )

        // Headline - large & bold
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headlineLabel.textColor = .white
        headlineLabel.numberOfLines = 2

        infoStack.addArrangedSubview(headlineLabel)

        // Rating + Advertiser row
        let ratingRow = createHorizontalStack(spacing: 8, alignment: .center)

        let ratingContainer = UIView()
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.isHidden = true
        ratingContainer.tag = 1001 // Tag để tìm sau

        let advertiserLabel = UILabel()
        advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
        advertiserLabel.font = .systemFont(ofSize: 12)
        advertiserLabel.textColor = UIColor(white: 0.9, alpha: 1)
        advertiserLabel.isHidden = true

        ratingRow.addArrangedSubview(ratingContainer)
        ratingRow.addArrangedSubview(advertiserLabel)

        // Spacer để đẩy về trái
        let spacer1 = UIView()
        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer1.setContentHuggingPriority(.defaultLow, for: .horizontal)
        ratingRow.addArrangedSubview(spacer1)

        infoStack.addArrangedSubview(ratingRow)

        // Body text
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = UIColor(white: 0.94, alpha: 1)
        bodyLabel.numberOfLines = 3
        bodyLabel.isHidden = true

        infoStack.addArrangedSubview(bodyLabel)

        // Footer - Price + Store
        let footerRow = createHorizontalStack(spacing: 12, alignment: .center)
        footerRow.isHidden = true

        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
        priceLabel.textColor = .white
        priceLabel.isHidden = true

        let storeLabel = UILabel()
        storeLabel.translatesAutoresizingMaskIntoConstraints = false
        storeLabel.font = .systemFont(ofSize: 12)
        storeLabel.textColor = UIColor(white: 0.9, alpha: 1)
        storeLabel.isHidden = true

        footerRow.addArrangedSubview(priceLabel)
        footerRow.addArrangedSubview(storeLabel)

        // Spacer để đẩy về trái
        let spacer2 = UIView()
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer2.setContentHuggingPriority(.defaultLow, for: .horizontal)
        footerRow.addArrangedSubview(spacer2)

        infoStack.addArrangedSubview(footerRow)

        return (infoStack, headlineLabel, ratingContainer, advertiserLabel, bodyLabel, priceLabel, storeLabel)
    }

    private static func createCtaButton() -> UIButton {
        let ctaButton = UIButton(type: .system)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false

        // Gradient background (pink to red)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#f093fb").cgColor, // Pink
            UIColor(hex: "#f5576c").cgColor  // Red
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = ctaCornerRadius

        // Create container view cho gradient
        let gradientContainer = UIView()
        gradientContainer.layer.insertSublayer(gradientLayer, at: 0)
        gradientContainer.layer.cornerRadius = ctaCornerRadius
        gradientContainer.clipsToBounds = true

        // Store gradient layer để update frame sau
        ctaButton.tag = 8888

        // Text styling
        ctaButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        ctaButton.setTitleColor(.white, for: .normal)

        // Background color fallback
        ctaButton.backgroundColor = UIColor(hex: "#f5576c")
        ctaButton.layer.cornerRadius = ctaCornerRadius
        ctaButton.clipsToBounds = true

        // Shadow effect
        ctaButton.layer.shadowColor = UIColor.black.cgColor
        ctaButton.layer.shadowOpacity = 0.3
        ctaButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        ctaButton.layer.shadowRadius = 4
        ctaButton.layer.masksToBounds = false

        return ctaButton
    }

    private static func createAdBadge() -> UILabel {
        let adBadge = UILabel()
        adBadge.translatesAutoresizingMaskIntoConstraints = false
        adBadge.text = "Ad"
        adBadge.font = .systemFont(ofSize: 10, weight: .bold)
        adBadge.textColor = UIColor(hex: "#333333")
        adBadge.backgroundColor = UIColor(hex: "#ffd700") // Gold
        adBadge.textAlignment = .center
        adBadge.layer.cornerRadius = 4
        adBadge.clipsToBounds = true

        // Padding
        adBadge.layoutMargins = UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6)

        // Shadow
        adBadge.layer.shadowColor = UIColor.black.cgColor
        adBadge.layer.shadowOpacity = 0.2
        adBadge.layer.shadowOffset = CGSize(width: 0, height: 1)
        adBadge.layer.shadowRadius = 2
        adBadge.layer.masksToBounds = false

        return adBadge
    }

    private static func setupConstraints(
        nativeAdView: GADNativeAdView,
        mainContainer: UIView,
        contentStack: UIStackView,
        headerView: UIView,
        mediaView: GADMediaView,
        iconView: UIImageView,
        adBadge: UILabel,
        ctaButton: UIButton
    ) {
        NSLayoutConstraint.activate([
            // Main container với margin
            mainContainer.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: cardPadding),
            mainContainer.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: cardPadding),
            mainContainer.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -cardPadding),
            mainContainer.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -cardPadding),

            // Content stack fills container
            contentStack.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor),

            // Ad badge (top right)
            adBadge.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 12),
            adBadge.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -12),
            adBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            adBadge.heightAnchor.constraint(equalToConstant: 20)
        ])

        // Update gradient layer frames khi layout thay đổi
        DispatchQueue.main.async {
            if let gradientLayer = mainContainer.layer.sublayers?.first as? CAGradientLayer {
                gradientLayer.frame = mainContainer.bounds
            }
        }
    }

    private static func mapViews(
        nativeAdView: GADNativeAdView,
        mediaView: GADMediaView,
        iconView: UIImageView,
        headlineLabel: UILabel,
        ratingContainer: UIView,
        advertiserLabel: UILabel,
        bodyLabel: UILabel,
        priceLabel: UILabel,
        storeLabel: UILabel,
        ctaButton: UIButton
    ) {
        nativeAdView.mediaView = mediaView
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineLabel
        nativeAdView.advertiserView = advertiserLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.priceView = priceLabel
        nativeAdView.storeView = storeLabel
        nativeAdView.callToActionView = ctaButton

        // Rating sẽ được handle riêng khi ad load
    }
}

// MARK: - Helper Extensions

extension FormExampleBuilder {
    /// Create vertical stack view
    static func createVerticalStack(spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = .fill
        return stack
    }

    /// Create horizontal stack view
    static func createHorizontalStack(spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.alignment = alignment
        stack.distribution = .fill
        return stack
    }
}
