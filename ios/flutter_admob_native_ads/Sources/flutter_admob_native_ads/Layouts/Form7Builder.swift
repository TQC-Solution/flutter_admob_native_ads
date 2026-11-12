import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_7.png.
enum Form7Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 7, styleManager: styleManager)
    }
}
