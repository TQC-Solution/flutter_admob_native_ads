import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_3.png.
enum Form3Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 3, styleManager: styleManager)
    }
}
