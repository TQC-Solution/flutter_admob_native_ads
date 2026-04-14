import Foundation
import GoogleMobileAds
import UIKit

/// Extension methods for converting banner size index to AdMob AdSize.
enum BannerAdSizeExtensions {

    /// Gets the AdSize for the given size index.
    ///
    /// - Parameters:
    ///   - sizeIndex: The index from Flutter (0=banner, 1=fullBanner, 2=leaderboard, 3=mediumRectangle, 4=smartBanner, 5=adaptiveBanner, 6=inlineAdaptiveBanner)
    ///   - customHeight: Optional custom height for adaptive banners (in points)
    /// - Returns: The corresponding AdSize
    static func getAdSize(sizeIndex: Int, customHeight: Int? = nil) -> AdSize {
        switch sizeIndex {
        case 0:
            return AdSizeBanner // 320x50
        case 1:
            return AdSizeFullBanner // 468x60
        case 2:
            return AdSizeLeaderboard // 728x90
        case 3:
            return AdSizeMediumRectangle // 300x250
        case 4:
            return getAdaptiveBannerSize(nil) // Smart banner (deprecated, use adaptive)
        case 5:
            return getAdaptiveBannerSize(customHeight) // Adaptive
        case 6:
            return getInlineAdaptiveSize(customHeight) // Inline adaptive
        default:
            return AdSizeBanner
        }
    }

    /// Gets an adaptive banner size that anchors to the screen width.
    private static func getAdaptiveBannerSize(_ customHeight: Int?) -> AdSize {
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width

        // Use SDK default height calculation
        return currentOrientationAnchoredAdaptiveBanner(width: viewWidth)
    }

    /// Gets an inline adaptive banner size that can adjust height based on content.
    private static func getInlineAdaptiveSize(_ maxHeight: Int?) -> AdSize {
        let frame = UIScreen.main.bounds
        let viewWidth = frame.size.width

        // currentOrientationInlineAdaptiveBanner(width:) only takes width as parameter
        // The height will be adjusted dynamically based on ad content
        return currentOrientationInlineAdaptiveBanner(width: viewWidth)
    }
}
