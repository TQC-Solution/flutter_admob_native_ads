package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleOptions

/**
 * Factory for building native ad layouts based on form type.
 */
object AdLayoutBuilder {

    const val LAYOUT_COMPACT = 1
    const val LAYOUT_STANDARD = 2
    const val LAYOUT_FULL_MEDIA = 3

    /**
     * Builds a NativeAdView based on the specified layout type.
     *
     * @param layoutType The layout type (1 = compact, 2 = standard, 3 = full media)
     * @param context Android context
     * @param styleOptions Style options for the layout
     * @return Configured NativeAdView
     */
    fun buildLayout(
        layoutType: Int,
        context: Context,
        styleOptions: AdStyleOptions
    ): NativeAdView {
        val styleManager = AdStyleManager(context, styleOptions)

        return when (layoutType) {
            LAYOUT_COMPACT -> Form1Builder.build(context, styleManager)
            LAYOUT_STANDARD -> Form2Builder.build(context, styleManager)
            LAYOUT_FULL_MEDIA -> Form3Builder.build(context, styleManager)
            else -> Form2Builder.build(context, styleManager)
        }
    }

    /**
     * Gets the layout type from a string name.
     */
    fun getLayoutType(name: String?): Int {
        return when (name?.lowercase()) {
            "compact" -> LAYOUT_COMPACT
            "standard" -> LAYOUT_STANDARD
            "fullmedia", "full_media" -> LAYOUT_FULL_MEDIA
            else -> LAYOUT_STANDARD
        }
    }
}
