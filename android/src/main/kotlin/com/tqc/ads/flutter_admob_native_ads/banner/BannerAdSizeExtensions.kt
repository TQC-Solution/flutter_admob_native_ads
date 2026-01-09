package com.tqc.ads.flutter_admob_native_ads.banner

import android.content.Context
import android.util.DisplayMetrics
import android.view.WindowManager
import com.google.android.gms.ads.AdSize

/**
 * Extension methods for converting banner size index to AdMob AdSize.
 */
object BannerAdSizeExtensions {
    /**
     * Gets the AdSize for the given size index.
     *
     * @param sizeIndex The index from Flutter (0=banner, 1=fullBanner, 2=leaderboard, 3=mediumRectangle, 4=smartBanner, 5=adaptiveBanner)
     * @param context Application context for adaptive banner calculation
     * @param customHeight Optional custom height (not used, kept for future compatibility)
     * @return The corresponding AdSize
     */
    fun getAdSize(sizeIndex: Int, context: Context, customHeight: Int? = null): AdSize {
        return when (sizeIndex) {
            0 -> AdSize.BANNER            // 320x50
            1 -> AdSize.FULL_BANNER       // 468x60
            2 -> AdSize.LEADERBOARD       // 728x90
            3 -> AdSize.MEDIUM_RECTANGLE  // 300x250
            4 -> AdSize.SMART_BANNER      // Smart banner
            5 -> getAdaptiveBannerSize(context)  // Adaptive
            6 -> getInlineAdaptiveSize(context)  // Inline adaptive
            else -> AdSize.BANNER
        }
    }

    /**
     * Gets an adaptive banner size that anchors to the screen width.
     */
    private fun getAdaptiveBannerSize(context: Context): AdSize {
        val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val displayMetrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(displayMetrics)

        val density = displayMetrics.density
        val adWidth = (displayMetrics.widthPixels / density).toInt()

        // Use SDK default height calculation
        return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(context, adWidth)
    }

    /**
     * Gets an inline adaptive banner size that can adjust height based on content.
     * For now, this uses the same approach as adaptive banner.
     */
    private fun getInlineAdaptiveSize(context: Context): AdSize {
        // For inline adaptive, we use the same adaptive banner size
        // The banner will adjust its height based on the ad content
        return getAdaptiveBannerSize(context)
    }
}
