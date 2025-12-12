import UIKit

/// Data structure containing all styling options for native ads.
/// Parsed from Flutter parameters.
struct AdStyleOptions {

    // MARK: - CTA Button

    var ctaBackgroundColor: UIColor = UIColor(hex: "#4285F4")
    var ctaTextColor: UIColor = .white
    var ctaFontSize: CGFloat = 14
    var ctaFontWeight: UIFont.Weight = .semibold
    var ctaCornerRadius: CGFloat = 8
    var ctaPadding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    var ctaBorderColor: UIColor?
    var ctaBorderWidth: CGFloat?
    var ctaElevation: CGFloat?

    // MARK: - Container

    var containerBackgroundColor: UIColor = .white
    var containerCornerRadius: CGFloat = 12
    var containerPadding: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    var containerMargin: UIEdgeInsets = .zero
    var containerBorderColor: UIColor?
    var containerBorderWidth: CGFloat?
    var containerShadowColor: UIColor?
    var containerShadowRadius: CGFloat?
    var containerShadowOffset: CGSize?

    // MARK: - Headline

    var headlineTextColor: UIColor = UIColor(hex: "#202124")
    var headlineFontSize: CGFloat = 16
    var headlineFontWeight: UIFont.Weight = .semibold
    var headlineFontFamily: String?
    var headlineMaxLines: Int = 2

    // MARK: - Body

    var bodyTextColor: UIColor = UIColor(hex: "#5F6368")
    var bodyFontSize: CGFloat = 14
    var bodyFontWeight: UIFont.Weight = .regular
    var bodyFontFamily: String?
    var bodyMaxLines: Int = 3

    // MARK: - Price

    var priceTextColor: UIColor = UIColor(hex: "#34A853")
    var priceFontSize: CGFloat = 12

    // MARK: - Store

    var storeTextColor: UIColor = UIColor(hex: "#5F6368")
    var storeFontSize: CGFloat = 12

    // MARK: - Advertiser

    var advertiserTextColor: UIColor = UIColor(hex: "#9AA0A6")
    var advertiserFontSize: CGFloat = 11

    // MARK: - Media View

    var mediaViewHeight: CGFloat = 200
    var mediaViewCornerRadius: CGFloat = 8
    var mediaViewAspectRatio: CGFloat?
    var mediaViewBackgroundColor: UIColor?

    // MARK: - Icon

    var iconSize: CGFloat = 48
    var iconCornerRadius: CGFloat = 8
    var iconBorderColor: UIColor?
    var iconBorderWidth: CGFloat?

    // MARK: - Star Rating

    var starRatingSize: CGFloat = 16
    var starRatingActiveColor: UIColor = UIColor(hex: "#FBBC04")
    var starRatingInactiveColor: UIColor = UIColor(hex: "#DADCE0")

    // MARK: - Layout Spacing

    var itemSpacing: CGFloat = 8
    var sectionSpacing: CGFloat = 12

    // MARK: - Ad Label

    var showAdLabel: Bool = true
    var adLabelText: String = "Ad"
    var adLabelBackgroundColor: UIColor = UIColor(hex: "#FBBC04")
    var adLabelTextColor: UIColor = .white
    var adLabelFontSize: CGFloat = 10
    var adLabelCornerRadius: CGFloat = 4
    var adLabelPadding: UIEdgeInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)

    // MARK: - Initialization

    init() {}

    /// Creates AdStyleOptions from a Flutter map.
    static func fromMap(_ map: [String: Any]?) -> AdStyleOptions {
        guard let map = map else { return AdStyleOptions() }

        let styleMap = (map["style"] as? [String: Any]) ?? map

        var options = AdStyleOptions()

        // CTA Button
        if let color = styleMap["ctaBackgroundColor"] as? String {
            options.ctaBackgroundColor = UIColor(hex: color)
        }
        if let color = styleMap["ctaTextColor"] as? String {
            options.ctaTextColor = UIColor(hex: color)
        }
        if let size = styleMap["ctaFontSize"] as? NSNumber {
            options.ctaFontSize = CGFloat(truncating: size)
        }
        if let weight = styleMap["ctaFontWeight"] as? NSNumber {
            options.ctaFontWeight = fontWeightFromInt(weight.intValue)
        }
        if let radius = styleMap["ctaCornerRadius"] as? NSNumber {
            options.ctaCornerRadius = CGFloat(truncating: radius)
        }
        options.ctaPadding = parsePadding(styleMap["ctaPadding"], default: options.ctaPadding)
        if let color = styleMap["ctaBorderColor"] as? String {
            options.ctaBorderColor = UIColor(hex: color)
        }
        if let width = styleMap["ctaBorderWidth"] as? NSNumber {
            options.ctaBorderWidth = CGFloat(truncating: width)
        }
        if let elevation = styleMap["ctaElevation"] as? NSNumber {
            options.ctaElevation = CGFloat(truncating: elevation)
        }

        // Container
        if let color = styleMap["containerBackgroundColor"] as? String {
            options.containerBackgroundColor = UIColor(hex: color)
        }
        if let radius = styleMap["containerCornerRadius"] as? NSNumber {
            options.containerCornerRadius = CGFloat(truncating: radius)
        }
        options.containerPadding = parsePadding(styleMap["containerPadding"], default: options.containerPadding)
        options.containerMargin = parsePadding(styleMap["containerMargin"], default: options.containerMargin)
        if let color = styleMap["containerBorderColor"] as? String {
            options.containerBorderColor = UIColor(hex: color)
        }
        if let width = styleMap["containerBorderWidth"] as? NSNumber {
            options.containerBorderWidth = CGFloat(truncating: width)
        }
        if let color = styleMap["containerShadowColor"] as? String {
            options.containerShadowColor = UIColor(hex: color)
        }
        if let radius = styleMap["containerShadowRadius"] as? NSNumber {
            options.containerShadowRadius = CGFloat(truncating: radius)
        }
        if let x = styleMap["containerShadowOffsetX"] as? NSNumber,
           let y = styleMap["containerShadowOffsetY"] as? NSNumber {
            options.containerShadowOffset = CGSize(width: CGFloat(truncating: x), height: CGFloat(truncating: y))
        }

        // Headline
        if let color = styleMap["headlineTextColor"] as? String {
            options.headlineTextColor = UIColor(hex: color)
        }
        if let size = styleMap["headlineFontSize"] as? NSNumber {
            options.headlineFontSize = CGFloat(truncating: size)
        }
        if let weight = styleMap["headlineFontWeight"] as? NSNumber {
            options.headlineFontWeight = fontWeightFromInt(weight.intValue)
        }
        if let family = styleMap["headlineFontFamily"] as? String {
            options.headlineFontFamily = family
        }
        if let maxLines = styleMap["headlineMaxLines"] as? NSNumber {
            options.headlineMaxLines = maxLines.intValue
        }

        // Body
        if let color = styleMap["bodyTextColor"] as? String {
            options.bodyTextColor = UIColor(hex: color)
        }
        if let size = styleMap["bodyFontSize"] as? NSNumber {
            options.bodyFontSize = CGFloat(truncating: size)
        }
        if let weight = styleMap["bodyFontWeight"] as? NSNumber {
            options.bodyFontWeight = fontWeightFromInt(weight.intValue)
        }
        if let family = styleMap["bodyFontFamily"] as? String {
            options.bodyFontFamily = family
        }
        if let maxLines = styleMap["bodyMaxLines"] as? NSNumber {
            options.bodyMaxLines = maxLines.intValue
        }

        // Price
        if let color = styleMap["priceTextColor"] as? String {
            options.priceTextColor = UIColor(hex: color)
        }
        if let size = styleMap["priceFontSize"] as? NSNumber {
            options.priceFontSize = CGFloat(truncating: size)
        }

        // Store
        if let color = styleMap["storeTextColor"] as? String {
            options.storeTextColor = UIColor(hex: color)
        }
        if let size = styleMap["storeFontSize"] as? NSNumber {
            options.storeFontSize = CGFloat(truncating: size)
        }

        // Advertiser
        if let color = styleMap["advertiserTextColor"] as? String {
            options.advertiserTextColor = UIColor(hex: color)
        }
        if let size = styleMap["advertiserFontSize"] as? NSNumber {
            options.advertiserFontSize = CGFloat(truncating: size)
        }

        // Media View
        if let height = styleMap["mediaViewHeight"] as? NSNumber {
            options.mediaViewHeight = CGFloat(truncating: height)
        }
        if let radius = styleMap["mediaViewCornerRadius"] as? NSNumber {
            options.mediaViewCornerRadius = CGFloat(truncating: radius)
        }
        if let ratio = styleMap["mediaViewAspectRatio"] as? NSNumber {
            options.mediaViewAspectRatio = CGFloat(truncating: ratio)
        }
        if let color = styleMap["mediaViewBackgroundColor"] as? String {
            options.mediaViewBackgroundColor = UIColor(hex: color)
        }

        // Icon
        if let size = styleMap["iconSize"] as? NSNumber {
            options.iconSize = CGFloat(truncating: size)
        }
        if let radius = styleMap["iconCornerRadius"] as? NSNumber {
            options.iconCornerRadius = CGFloat(truncating: radius)
        }
        if let color = styleMap["iconBorderColor"] as? String {
            options.iconBorderColor = UIColor(hex: color)
        }
        if let width = styleMap["iconBorderWidth"] as? NSNumber {
            options.iconBorderWidth = CGFloat(truncating: width)
        }

        // Star Rating
        if let size = styleMap["starRatingSize"] as? NSNumber {
            options.starRatingSize = CGFloat(truncating: size)
        }
        if let color = styleMap["starRatingActiveColor"] as? String {
            options.starRatingActiveColor = UIColor(hex: color)
        }
        if let color = styleMap["starRatingInactiveColor"] as? String {
            options.starRatingInactiveColor = UIColor(hex: color)
        }

        // Layout Spacing
        if let spacing = styleMap["itemSpacing"] as? NSNumber {
            options.itemSpacing = CGFloat(truncating: spacing)
        }
        if let spacing = styleMap["sectionSpacing"] as? NSNumber {
            options.sectionSpacing = CGFloat(truncating: spacing)
        }

        // Ad Label
        if let show = styleMap["showAdLabel"] as? Bool {
            options.showAdLabel = show
        }
        if let text = styleMap["adLabelText"] as? String {
            options.adLabelText = text
        }
        if let color = styleMap["adLabelBackgroundColor"] as? String {
            options.adLabelBackgroundColor = UIColor(hex: color)
        }
        if let color = styleMap["adLabelTextColor"] as? String {
            options.adLabelTextColor = UIColor(hex: color)
        }
        if let size = styleMap["adLabelFontSize"] as? NSNumber {
            options.adLabelFontSize = CGFloat(truncating: size)
        }
        if let radius = styleMap["adLabelCornerRadius"] as? NSNumber {
            options.adLabelCornerRadius = CGFloat(truncating: radius)
        }
        options.adLabelPadding = parsePadding(styleMap["adLabelPadding"], default: options.adLabelPadding)

        return options
    }

    // MARK: - Private Helpers

    private static func parsePadding(_ padding: Any?, default defaultValue: UIEdgeInsets) -> UIEdgeInsets {
        guard let paddingMap = padding as? [String: Any] else {
            return defaultValue
        }

        return UIEdgeInsets(
            top: (paddingMap["top"] as? NSNumber).map { CGFloat(truncating: $0) } ?? defaultValue.top,
            left: (paddingMap["left"] as? NSNumber).map { CGFloat(truncating: $0) } ?? defaultValue.left,
            bottom: (paddingMap["bottom"] as? NSNumber).map { CGFloat(truncating: $0) } ?? defaultValue.bottom,
            right: (paddingMap["right"] as? NSNumber).map { CGFloat(truncating: $0) } ?? defaultValue.right
        )
    }

    private static func fontWeightFromInt(_ weight: Int) -> UIFont.Weight {
        switch weight {
        case 100: return .ultraLight
        case 200: return .thin
        case 300: return .light
        case 400: return .regular
        case 500: return .medium
        case 600: return .semibold
        case 700: return .bold
        case 800: return .heavy
        case 900: return .black
        default: return weight >= 600 ? .semibold : .regular
        }
    }
}
