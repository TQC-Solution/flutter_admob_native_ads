import UIKit
import GoogleMobileAds

/// Layout matching ads_template_native/ad_2.png.
enum Form2Builder {
    static func build(styleManager: AdStyleManager) -> NativeAdView {
        return TemplateLayoutBuilder.build(form: 2, styleManager: styleManager)
    }
}
