package com.tqc.ads.flutter_admob_native_ads.utils

import android.content.Context
import android.util.TypedValue

/**
 * Utility object for dimension conversions with caching.
 */
object DimensionUtils {

    // Cache for dp to px conversions to avoid repeated calculations
    private val dpToPxCache = mutableMapOf<Pair<Float, Float>, Int>()

    /**
     * Converts density-independent pixels (dp) to pixels (px) with caching.
     *
     * @param context Android context
     * @param dp Value in density-independent pixels
     * @return Value in pixels
     */
    fun dpToPx(context: Context, dp: Float): Int {
        val density = context.resources.displayMetrics.density
        val cacheKey = Pair(dp, density)

        return dpToPxCache.getOrPut(cacheKey) {
            TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                dp,
                context.resources.displayMetrics
            ).toInt()
        }
    }

    /**
     * Converts pixels (px) to density-independent pixels (dp).
     *
     * @param context Android context
     * @param px Value in pixels
     * @return Value in density-independent pixels
     */
    fun pxToDp(context: Context, px: Int): Float {
        return px / context.resources.displayMetrics.density
    }

    /**
     * Converts scale-independent pixels (sp) to pixels (px).
     *
     * @param context Android context
     * @param sp Value in scale-independent pixels
     * @return Value in pixels
     */
    fun spToPx(context: Context, sp: Float): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_SP,
            sp,
            context.resources.displayMetrics
        ).toInt()
    }

    /**
     * Converts pixels (px) to scale-independent pixels (sp).
     *
     * @param context Android context
     * @param px Value in pixels
     * @return Value in scale-independent pixels
     */
    fun pxToSp(context: Context, px: Int): Float {
        return px / context.resources.displayMetrics.scaledDensity
    }
}
