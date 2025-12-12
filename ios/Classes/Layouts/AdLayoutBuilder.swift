import UIKit
import GoogleMobileAds

/// Factory for building native ad layouts based on form type.
enum AdLayoutBuilder {

    static let layoutCompact = 1
    static let layoutStandard = 2
    static let layoutFullMedia = 3

    /// Builds a GADNativeAdView based on the specified layout type.
    ///
    /// - Parameters:
    ///   - layoutType: The layout type (1 = compact, 2 = standard, 3 = full media)
    ///   - styleOptions: Style options for the layout
    /// - Returns: Configured GADNativeAdView
    static func buildLayout(
        layoutType: Int,
        styleOptions: AdStyleOptions
    ) -> GADNativeAdView {
        let styleManager = AdStyleManager(options: styleOptions)

        switch layoutType {
        case layoutCompact:
            return Form1Builder.build(styleManager: styleManager)
        case layoutStandard:
            return Form2Builder.build(styleManager: styleManager)
        case layoutFullMedia:
            return Form3Builder.build(styleManager: styleManager)
        default:
            return Form2Builder.build(styleManager: styleManager)
        }
    }

    /// Gets the layout type from a string name.
    static func getLayoutType(from name: String?) -> Int {
        switch name?.lowercased() {
        case "compact":
            return layoutCompact
        case "standard":
            return layoutStandard
        case "fullmedia", "full_media":
            return layoutFullMedia
        default:
            return layoutStandard
        }
    }
}
