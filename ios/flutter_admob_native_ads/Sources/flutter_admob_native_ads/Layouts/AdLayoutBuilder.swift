import UIKit
import GoogleMobileAds

/**
 * Factory for building native ad layouts.
 * Supports 12 different layout forms.
 */
public enum AdLayoutBuilder {
    
    public static func buildLayout(layoutType: Int, styleOptions: AdStyleOptions) -> NativeAdView {
        let styleManager = AdStyleManager(options: styleOptions)
        
        let adView: NativeAdView
        switch layoutType {
        case 1:
            adView = Form1Builder.build(styleManager: styleManager)
        case 2:
            adView = Form2Builder.build(styleManager: styleManager)
        case 3:
            adView = Form3Builder.build(styleManager: styleManager)
        case 4:
            adView = Form4Builder.build(styleManager: styleManager)
        case 5:
            adView = Form5Builder.build(styleManager: styleManager)
        case 6:
            adView = Form6Builder.build(styleManager: styleManager)
        case 7:
            adView = Form7Builder.build(styleManager: styleManager)
        case 8:
            adView = Form8Builder.build(styleManager: styleManager)
        case 9:
            adView = Form9Builder.build(styleManager: styleManager)
        case 10:
            adView = Form10Builder.build(styleManager: styleManager)
        case 11:
            adView = Form11Builder.build(styleManager: styleManager)
        case 12:
            adView = Form12Builder.build(styleManager: styleManager)
        default:
            adView = Form1Builder.build(styleManager: styleManager)
        }
        // Apply colors after layout defaults so Flutter styles win in every form.
        (adView.headlineView as? UILabel)?.textColor = styleOptions.headlineTextColor
        (adView.bodyView as? UILabel)?.textColor = styleOptions.bodyTextColor
        (adView.priceView as? UILabel)?.textColor = styleOptions.priceTextColor
        (adView.storeView as? UILabel)?.textColor = styleOptions.storeTextColor
        (adView.advertiserView as? UILabel)?.textColor = styleOptions.advertiserTextColor
        return adView
    }
    
    public static func getLayoutType(from name: String?) -> Int {
        guard let name = name?.lowercased() else { return 1 }
        
        switch name {
        case "form1": return 1
        case "form2": return 2
        case "form3": return 3
        case "form4": return 4
        case "form5": return 5
        case "form6": return 6
        case "form7": return 7
        case "form8": return 8
        case "form9": return 9
        case "form10": return 10
        case "form11": return 11
        case "form12": return 12
        default: return 1
        }
    }
}
