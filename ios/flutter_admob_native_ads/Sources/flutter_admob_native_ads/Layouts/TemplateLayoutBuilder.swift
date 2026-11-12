import UIKit
import GoogleMobileAds

/// Shared geometry for the reference templates that use an inline badge/title.
/// Other forms retain their independent builders.
enum TemplateLayoutBuilder {
    static func build(form: Int, styleManager: AdStyleManager) -> NativeAdView {
        let ad = NativeAdView()
        ad.translatesAutoresizingMaskIntoConstraints = false
        let horizontal = form == 2 || form == 7
        let outlined = form == 11 || form == 12
        let main = UIStackView()
        main.translatesAutoresizingMaskIntoConstraints = false
        main.axis = horizontal ? .horizontal : .vertical
        main.alignment = horizontal ? .center : .fill
        main.spacing = styleManager.itemSpacing
        styleManager.styleMainContainer(main)
        // Template-specific gutters are added to the caller's container padding.
        let extraH: CGFloat = [4, 5, 12].contains(form) ? 8 : (form == 2 ? 0 : (form == 7 ? 2 : 4))
        let extraV: CGFloat = [5, 7, 11, 12].contains(form) ? 4 : 0
        var padding = styleManager.containerPadding
        padding.left += extraH
        padding.right += extraH
        padding.top += form == 7 ? 8 : extraV
        padding.bottom += extraV
        main.layoutMargins = padding

        let headline = UILabel()
        styleManager.styleHeadline(headline)
        headline.numberOfLines = form == 7 ? 2 : 1
        headline.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let body = UILabel()
        styleManager.styleBody(body)
        if form != 2 && styleManager.options.bodyFontSize == 10 {
            body.font = .systemFont(ofSize: 12, weight: styleManager.options.bodyFontWeight)
        }
        body.numberOfLines = form == 2 ? 2 : (form == 7 ? 3 : 1)
        body.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let title = UIStackView()
        title.axis = .horizontal
        title.spacing = form == 2 ? 4 : 6
        title.alignment = form == 7 ? .top : .center
        if styleManager.shouldShowAdLabel {
            let badge = styleManager.createAdLabel()
            badge.text = styleManager.options.adLabelText.uppercased()
            badge.font = .systemFont(ofSize: form == 2 ? 8 : 10, weight: .medium)
            if let padded = badge as? PaddedLabel {
                padded.textInsets = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
            }
            badge.layer.cornerRadius = 3
            if outlined {
                badge.backgroundColor = .clear
                badge.textColor = styleManager.options.adLabelBackgroundColor
                badge.layer.borderColor = styleManager.options.adLabelBackgroundColor.cgColor
                badge.layer.borderWidth = 0.75
            }
            badge.setContentHuggingPriority(.required, for: .horizontal)
            badge.setContentCompressionResistancePriority(.required, for: .horizontal)
            title.addArrangedSubview(badge)
        }
        title.addArrangedSubview(headline)

        let text = UIStackView()
        text.axis = .vertical
        text.spacing = 2
        text.alignment = .fill
        text.addArrangedSubview(title)
        if !outlined { text.addArrangedSubview(body) }

        let button = UIButton(type: .system)
        styleManager.styleButton(button)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        // The reference CTA is a 40pt pill (30pt for the compact horizontal form).
        // Allow larger custom fonts/padding to increase its intrinsic height.
        let buttonHeight: CGFloat = form == 2 ? 30 : (form == 7 ? 34 : 40)
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: buttonHeight).isActive = true
        if #available(iOS 15.0, *), var configuration = button.configuration {
            if form == 2 || form == 7 {
                configuration.contentInsets.top = form == 2 ? 4 : 8
                configuration.contentInsets.bottom = form == 2 ? 4 : 8
            }
            configuration.baseForegroundColor = styleManager.options.ctaTextColor
            let size = (form == 2 || form == 7) && styleManager.options.ctaFontSize == 14 ? CGFloat(12) : styleManager.options.ctaFontSize
            let font = UIFont.systemFont(ofSize: size, weight: styleManager.options.ctaFontWeight)
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var result = incoming
                result.font = font
                return result
            }
            configuration.cornerStyle = .capsule
            button.configuration = configuration
        }
        button.layer.cornerRadius = min(styleManager.options.ctaCornerRadius, buttonHeight / 2)

        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = form == 2 ? 6 : 8
        icon.clipsToBounds = true
        let iconWidth: CGFloat = form == 2 ? 64 : 40
        icon.widthAnchor.constraint(equalToConstant: iconWidth).isActive = true
        icon.heightAnchor.constraint(equalToConstant: form == 2 ? 54 : 40).isActive = true

        let media = MediaView()
        media.clipsToBounds = true
        // Template media is rectangular; its flexible height absorbs card resizing.
        media.layer.cornerRadius = outlined ? 3 : 0
        media.contentMode = .scaleAspectFill
        media.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        media.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)

        if form == 2 {
            main.addArrangedSubview(icon)
            main.addArrangedSubview(text)
            main.addArrangedSubview(button)
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            ad.iconView = icon
        } else if form == 7 {
            main.alignment = .fill
            main.addArrangedSubview(media)
            let right = UIStackView()
            right.axis = .vertical
            right.spacing = 8
            right.alignment = .fill
            right.addArrangedSubview(text)
            let spacer = UIView()
            spacer.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
            right.addArrangedSubview(spacer)
            right.addArrangedSubview(button)
            main.addArrangedSubview(right)
            // Match the roughly equal media/content columns, including custom gutters.
            media.widthAnchor.constraint(equalTo: right.widthAnchor, multiplier: 1.075).isActive = true
            ad.mediaView = media
        } else {
            let header: UIView
            if outlined {
                header = title
                title.heightAnchor.constraint(greaterThanOrEqualToConstant: form == 11 ? 20 : 16).isActive = true
            } else {
                let row = UIStackView(arrangedSubviews: [icon, text])
                row.axis = .horizontal
                row.spacing = 8
                row.alignment = .center
                header = row
                ad.iconView = icon
            }
            if form == 4 { main.addArrangedSubview(media) }
            main.addArrangedSubview(header)
            if form != 4 { main.addArrangedSubview(media) }
            main.addArrangedSubview(button)
            ad.mediaView = media
        }

        ad.addSubview(main)
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: ad.topAnchor),
            main.leadingAnchor.constraint(equalTo: ad.leadingAnchor),
            main.trailingAnchor.constraint(equalTo: ad.trailingAnchor),
            main.bottomAnchor.constraint(equalTo: ad.bottomAnchor)
        ])
        ad.headlineView = headline
        if !outlined { ad.bodyView = body }
        ad.callToActionView = button
        return ad
    }
}
