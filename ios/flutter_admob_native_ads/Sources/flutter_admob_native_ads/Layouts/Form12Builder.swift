import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_12.png.
enum Form12Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 12, styleManager: styleManager)
    }
}
