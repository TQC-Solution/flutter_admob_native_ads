package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleOptions

/**
 * Factory for building native ad layouts.
 * Now only supports FormExample layout.
 */
object AdLayoutBuilder {

    const val LAYOUT_FORM_EXAMPLE = 1

    /**
     * Builds a NativeAdView using FormExample layout.
     *
     * @param layoutType The layout type (currently only supports FormExample)
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
        return FormExampleBuilder.build(context, styleManager)
    }

    /**
     * Gets the layout type from a string name.
     * All names now map to FormExample layout.
     */
    fun getLayoutType(name: String?): Int {
        return LAYOUT_FORM_EXAMPLE
    }
}
