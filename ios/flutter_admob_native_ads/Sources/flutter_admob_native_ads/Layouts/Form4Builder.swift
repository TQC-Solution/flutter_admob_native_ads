import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_4.png.
enum Form4Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 4, styleManager: styleManager)
    }
}
