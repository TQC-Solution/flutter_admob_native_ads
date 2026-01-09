import Foundation
import GoogleMobileAds
import UIKit

/// Extension methods for converting banner size index to AdMob GADAdSize.
enum BannerAdSizeExtensions {

    /// Gets the GADAdSize for the given size index.
    ///
    /// - Parameters:
    ///   - sizeIndex: The index from Flutter (0=banner, 1=fullBanner, 2=leaderboard, 3=mediumRectangle, 4=smartBanner, 5=adaptiveBanner, 6=inlineAdaptiveBanner)
    ///   - customHeight: Optional custom height for adaptive banners (in points)
    /// - Returns: The corresponding GADAdSize
    static func getAdSize(sizeIndex: Int, customHeight: Int? = nil) -> GADAdSize {
        switch sizeIndex {
        case 0:
            return GADAdSizeBanner // 320x50
        case 1:
            return GADAdSizeFullBanner // 468x60
        case 2:
            return GADAdSizeLeaderboard // 728x90
        case 3:
            return GADAdSizeMediumRectangle // 300x250
        case 4:
            return getAdaptiveBannerSize(nil) // Smart banner (deprecated, use adaptive)
        case 5:
            return getAdaptiveBannerSize(customHeight) // Adaptive
        case 6:
            return getInlineAdaptiveSize(customHeight) // Inline adaptive
        default:
            return GADAdSizeBanner
        }
    }

    /// Gets an adaptive banner size that anchors to the screen width.
    private static func getAdaptiveBannerSize(_ customHeight: Int?) -> GADAdSize {
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width

        // Use SDK default height calculation
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    }

    /// Gets an inline adaptive banner size that can adjust height based on content.
    private static func getInlineAdaptiveSize(_ maxHeight: Int?) -> GADAdSize {
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width

        // GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth only takes width as parameter
        // The height will be adjusted dynamically based on ad content
        return GADCurrentOrientationInlineAdaptiveBannerAdSizeWithWidth(viewWidth)
    }
}
