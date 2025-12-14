package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleOptions

/**
 * Factory for building native ad layouts.
 * Supports 12 different layout forms.
 */
object AdLayoutBuilder {

    const val LAYOUT_FORM_1 = 1
    const val LAYOUT_FORM_2 = 2
    const val LAYOUT_FORM_3 = 3
    const val LAYOUT_FORM_4 = 4
    const val LAYOUT_FORM_5 = 5
    const val LAYOUT_FORM_6 = 6
    const val LAYOUT_FORM_7 = 7
    const val LAYOUT_FORM_8 = 8
    const val LAYOUT_FORM_9 = 9
    const val LAYOUT_FORM_10 = 10
    const val LAYOUT_FORM_11 = 11
    const val LAYOUT_FORM_12 = 12

    /**
     * Builds a NativeAdView using the specified layout type.
     *
     * @param layoutType The layout type (1-12)
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
            LAYOUT_FORM_1 -> Form1Builder.build(context, styleManager)
            LAYOUT_FORM_2 -> Form2Builder.build(context, styleManager)
            LAYOUT_FORM_3 -> Form3Builder.build(context, styleManager)
            LAYOUT_FORM_4 -> Form4Builder.build(context, styleManager)
            LAYOUT_FORM_5 -> Form5Builder.build(context, styleManager)
            LAYOUT_FORM_6 -> Form6Builder.build(context, styleManager)
            LAYOUT_FORM_7 -> Form7Builder.build(context, styleManager)
            LAYOUT_FORM_8 -> Form8Builder.build(context, styleManager)
            LAYOUT_FORM_9 -> Form9Builder.build(context, styleManager)
            LAYOUT_FORM_10 -> Form10Builder.build(context, styleManager)
            LAYOUT_FORM_11 -> Form11Builder.build(context, styleManager)
            LAYOUT_FORM_12 -> Form12Builder.build(context, styleManager)
            else -> Form1Builder.build(context, styleManager) // Default to Form1
        }
    }

    /**
     * Gets the layout type from a string name.
     */
    fun getLayoutType(name: String?): Int {
        return when (name?.lowercase()) {
            "form1" -> LAYOUT_FORM_1
            "form2" -> LAYOUT_FORM_2
            "form3" -> LAYOUT_FORM_3
            "form4" -> LAYOUT_FORM_4
            "form5" -> LAYOUT_FORM_5
            "form6" -> LAYOUT_FORM_6
            "form7" -> LAYOUT_FORM_7
            "form8" -> LAYOUT_FORM_8
            "form9" -> LAYOUT_FORM_9
            "form10" -> LAYOUT_FORM_10
            "form11" -> LAYOUT_FORM_11
            "form12" -> LAYOUT_FORM_12
            else -> LAYOUT_FORM_1 // Default
        }
    }
}
