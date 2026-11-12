import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_11.png.
enum Form11Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 11, styleManager: styleManager)
    }
}
