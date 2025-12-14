import UIKit
import GoogleMobileAds

/**
 * Factory for building native ad layouts.
 * Supports 12 different layout forms.
 */
enum AdLayoutBuilder {
    
    static func buildLayout(layoutType: Int, styleOptions: AdStyleOptions) -> GADNativeAdView {
        let styleManager = AdStyleManager(options: styleOptions)
        
        switch layoutType {
        case 1:
            return Form1Builder.build(styleManager: styleManager)
        case 2:
            return Form2Builder.build(styleManager: styleManager)
        case 3:
            return Form3Builder.build(styleManager: styleManager)
        case 4:
            return Form4Builder.build(styleManager: styleManager)
        case 5:
            return Form5Builder.build(styleManager: styleManager)
        case 6:
            return Form6Builder.build(styleManager: styleManager)
        case 7:
            return Form7Builder.build(styleManager: styleManager)
        case 8:
            return Form8Builder.build(styleManager: styleManager)
        case 9:
            return Form9Builder.build(styleManager: styleManager)
        case 10:
            return Form10Builder.build(styleManager: styleManager)
        case 11:
            return Form11Builder.build(styleManager: styleManager)
        case 12:
            return Form12Builder.build(styleManager: styleManager)
        default:
            return Form1Builder.build(styleManager: styleManager)
        }
    }
    
    static func getLayoutType(from name: String?) -> Int {
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
