import UIKit
import GoogleMobileAds

/// Factory for building native ad layouts.
/// Now only supports FormExample layout.
enum AdLayoutBuilder {

    static let layoutFormExample = 1

    /// Builds a GADNativeAdView using FormExample layout.
    ///
    /// - Parameters:
    ///   - layoutType: The layout type (currently only supports FormExample)
    ///   - styleOptions: Style options for the layout
    /// - Returns: Configured GADNativeAdView
    static func buildLayout(
        layoutType: Int,
        styleOptions: AdStyleOptions
    ) -> GADNativeAdView {
        let styleManager = AdStyleManager(options: styleOptions)
        return FormExampleBuilder.build(styleManager: styleManager)
    }

    /// Gets the layout type from a string name.
    /// All names now map to FormExample layout.
    static func getLayoutType(from name: String?) -> Int {
        return layoutFormExample
    }
}
