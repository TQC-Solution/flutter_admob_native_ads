import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_5.png.
enum Form5Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 5, styleManager: styleManager)
    }
}
