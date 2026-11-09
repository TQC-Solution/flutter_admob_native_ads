package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager

/** Layout matching ads_template_native/ad_4.png. */
object Form4Builder {
    fun build(context: Context, styleManager: AdStyleManager): NativeAdView =
        TemplateLayoutBuilder.build(4, context, styleManager)
}
