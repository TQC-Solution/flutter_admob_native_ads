package com.tqc.ads.flutter_admob_native_ads.styling

import android.graphics.Color
import android.graphics.Typeface
import com.tqc.ads.flutter_admob_native_ads.utils.ColorUtils

/**
 * Data class containing all styling options for native ads.
 * Parsed from Flutter parameters.
 */
data class AdStyleOptions(
    // CTA Button
    val ctaBackgroundColor: Int = Color.parseColor("#4285F4"),
    val ctaTextColor: Int = Color.WHITE,
    val ctaFontSize: Float = 14f,
    val ctaFontWeight: Int = Typeface.BOLD,
    val ctaCornerRadius: Float = 8f,
    val ctaPaddingTop: Float = 10f,
    val ctaPaddingLeft: Float = 16f,
    val ctaPaddingBottom: Float = 10f,
    val ctaPaddingRight: Float = 16f,
    val ctaBorderColor: Int? = null,
    val ctaBorderWidth: Float? = null,
    val ctaElevation: Float? = null,

    // Container
    val containerBackgroundColor: Int = Color.WHITE,
    val containerCornerRadius: Float = 12f,
    val containerPaddingTop: Float = 12f,
    val containerPaddingLeft: Float = 12f,
    val containerPaddingBottom: Float = 12f,
    val containerPaddingRight: Float = 12f,
    val containerMarginTop: Float = 0f,
    val containerMarginLeft: Float = 0f,
    val containerMarginBottom: Float = 0f,
    val containerMarginRight: Float = 0f,
    val containerBorderColor: Int? = null,
    val containerBorderWidth: Float? = null,
    val containerShadowColor: Int? = null,
    val containerShadowRadius: Float? = null,
    val containerShadowOffsetX: Float? = null,
    val containerShadowOffsetY: Float? = null,

    // Headline
    val headlineTextColor: Int = Color.parseColor("#202124"),
    val headlineFontSize: Float = 16f,
    val headlineFontWeight: Int = Typeface.BOLD,
    val headlineFontFamily: String? = null,
    val headlineMaxLines: Int = 2,

    // Body
    val bodyTextColor: Int = Color.parseColor("#5F6368"),
    val bodyFontSize: Float = 14f,
    val bodyFontWeight: Int = Typeface.NORMAL,
    val bodyFontFamily: String? = null,
    val bodyMaxLines: Int = 3,

    // Price
    val priceTextColor: Int = Color.parseColor("#34A853"),
    val priceFontSize: Float = 12f,

    // Store
    val storeTextColor: Int = Color.parseColor("#5F6368"),
    val storeFontSize: Float = 12f,

    // Advertiser
    val advertiserTextColor: Int = Color.parseColor("#9AA0A6"),
    val advertiserFontSize: Float = 11f,

    // Media View
    val mediaViewHeight: Float = 200f,
    val mediaViewCornerRadius: Float = 8f,
    val mediaViewAspectRatio: Float? = null,
    val mediaViewBackgroundColor: Int? = null,

    // Icon
    val iconSize: Float = 48f,
    val iconCornerRadius: Float = 8f,
    val iconBorderColor: Int? = null,
    val iconBorderWidth: Float? = null,

    // Star Rating
    val starRatingSize: Float = 16f,
    val starRatingActiveColor: Int = Color.parseColor("#FBBC04"),
    val starRatingInactiveColor: Int = Color.parseColor("#DADCE0"),

    // Layout Spacing
    val itemSpacing: Float = 8f,
    val sectionSpacing: Float = 12f,

    // Ad Label
    val showAdLabel: Boolean = true,
    val adLabelText: String = "Ad",
    val adLabelBackgroundColor: Int = Color.parseColor("#FBBC04"),
    val adLabelTextColor: Int = Color.WHITE,
    val adLabelFontSize: Float = 10f,
    val adLabelCornerRadius: Float = 4f,
    val adLabelPaddingTop: Float = 2f,
    val adLabelPaddingLeft: Float = 6f,
    val adLabelPaddingBottom: Float = 2f,
    val adLabelPaddingRight: Float = 6f
) {
    companion object {
        /**
         * Parses style options from a Flutter map.
         */
        fun fromMap(map: Map<String, Any?>?): AdStyleOptions {
            if (map == null) return AdStyleOptions()

            val styleMap = (map["style"] as? Map<String, Any?>) ?: map

            return AdStyleOptions(
                // CTA Button
                ctaBackgroundColor = ColorUtils.parseColor(
                    styleMap["ctaBackgroundColor"] as? String,
                    Color.parseColor("#4285F4")
                ),
                ctaTextColor = ColorUtils.parseColor(
                    styleMap["ctaTextColor"] as? String,
                    Color.WHITE
                ),
                ctaFontSize = (styleMap["ctaFontSize"] as? Number)?.toFloat() ?: 14f,
                ctaFontWeight = fontWeightFromInt((styleMap["ctaFontWeight"] as? Number)?.toInt() ?: 600),
                ctaCornerRadius = (styleMap["ctaCornerRadius"] as? Number)?.toFloat() ?: 8f,
                ctaPaddingTop = getPaddingValue(styleMap["ctaPadding"], "top", 10f),
                ctaPaddingLeft = getPaddingValue(styleMap["ctaPadding"], "left", 16f),
                ctaPaddingBottom = getPaddingValue(styleMap["ctaPadding"], "bottom", 10f),
                ctaPaddingRight = getPaddingValue(styleMap["ctaPadding"], "right", 16f),
                ctaBorderColor = (styleMap["ctaBorderColor"] as? String)?.let { ColorUtils.parseColor(it) },
                ctaBorderWidth = (styleMap["ctaBorderWidth"] as? Number)?.toFloat(),
                ctaElevation = (styleMap["ctaElevation"] as? Number)?.toFloat(),

                // Container
                containerBackgroundColor = ColorUtils.parseColor(
                    styleMap["containerBackgroundColor"] as? String,
                    Color.WHITE
                ),
                containerCornerRadius = (styleMap["containerCornerRadius"] as? Number)?.toFloat() ?: 12f,
                containerPaddingTop = getPaddingValue(styleMap["containerPadding"], "top", 12f),
                containerPaddingLeft = getPaddingValue(styleMap["containerPadding"], "left", 12f),
                containerPaddingBottom = getPaddingValue(styleMap["containerPadding"], "bottom", 12f),
                containerPaddingRight = getPaddingValue(styleMap["containerPadding"], "right", 12f),
                containerMarginTop = getPaddingValue(styleMap["containerMargin"], "top", 0f),
                containerMarginLeft = getPaddingValue(styleMap["containerMargin"], "left", 0f),
                containerMarginBottom = getPaddingValue(styleMap["containerMargin"], "bottom", 0f),
                containerMarginRight = getPaddingValue(styleMap["containerMargin"], "right", 0f),
                containerBorderColor = (styleMap["containerBorderColor"] as? String)?.let { ColorUtils.parseColor(it) },
                containerBorderWidth = (styleMap["containerBorderWidth"] as? Number)?.toFloat(),
                containerShadowColor = (styleMap["containerShadowColor"] as? String)?.let { ColorUtils.parseColor(it) },
                containerShadowRadius = (styleMap["containerShadowRadius"] as? Number)?.toFloat(),
                containerShadowOffsetX = (styleMap["containerShadowOffsetX"] as? Number)?.toFloat(),
                containerShadowOffsetY = (styleMap["containerShadowOffsetY"] as? Number)?.toFloat(),

                // Headline
                headlineTextColor = ColorUtils.parseColor(
                    styleMap["headlineTextColor"] as? String,
                    Color.parseColor("#202124")
                ),
                headlineFontSize = (styleMap["headlineFontSize"] as? Number)?.toFloat() ?: 16f,
                headlineFontWeight = fontWeightFromInt((styleMap["headlineFontWeight"] as? Number)?.toInt() ?: 600),
                headlineFontFamily = styleMap["headlineFontFamily"] as? String,
                headlineMaxLines = (styleMap["headlineMaxLines"] as? Number)?.toInt() ?: 2,

                // Body
                bodyTextColor = ColorUtils.parseColor(
                    styleMap["bodyTextColor"] as? String,
                    Color.parseColor("#5F6368")
                ),
                bodyFontSize = (styleMap["bodyFontSize"] as? Number)?.toFloat() ?: 14f,
                bodyFontWeight = fontWeightFromInt((styleMap["bodyFontWeight"] as? Number)?.toInt() ?: 400),
                bodyFontFamily = styleMap["bodyFontFamily"] as? String,
                bodyMaxLines = (styleMap["bodyMaxLines"] as? Number)?.toInt() ?: 3,

                // Price
                priceTextColor = ColorUtils.parseColor(
                    styleMap["priceTextColor"] as? String,
                    Color.parseColor("#34A853")
                ),
                priceFontSize = (styleMap["priceFontSize"] as? Number)?.toFloat() ?: 12f,

                // Store
                storeTextColor = ColorUtils.parseColor(
                    styleMap["storeTextColor"] as? String,
                    Color.parseColor("#5F6368")
                ),
                storeFontSize = (styleMap["storeFontSize"] as? Number)?.toFloat() ?: 12f,

                // Advertiser
                advertiserTextColor = ColorUtils.parseColor(
                    styleMap["advertiserTextColor"] as? String,
                    Color.parseColor("#9AA0A6")
                ),
                advertiserFontSize = (styleMap["advertiserFontSize"] as? Number)?.toFloat() ?: 11f,

                // Media View
                mediaViewHeight = (styleMap["mediaViewHeight"] as? Number)?.toFloat() ?: 200f,
                mediaViewCornerRadius = (styleMap["mediaViewCornerRadius"] as? Number)?.toFloat() ?: 8f,
                mediaViewAspectRatio = (styleMap["mediaViewAspectRatio"] as? Number)?.toFloat(),
                mediaViewBackgroundColor = (styleMap["mediaViewBackgroundColor"] as? String)?.let { ColorUtils.parseColor(it) },

                // Icon
                iconSize = (styleMap["iconSize"] as? Number)?.toFloat() ?: 48f,
                iconCornerRadius = (styleMap["iconCornerRadius"] as? Number)?.toFloat() ?: 8f,
                iconBorderColor = (styleMap["iconBorderColor"] as? String)?.let { ColorUtils.parseColor(it) },
                iconBorderWidth = (styleMap["iconBorderWidth"] as? Number)?.toFloat(),

                // Star Rating
                starRatingSize = (styleMap["starRatingSize"] as? Number)?.toFloat() ?: 16f,
                starRatingActiveColor = ColorUtils.parseColor(
                    styleMap["starRatingActiveColor"] as? String,
                    Color.parseColor("#FBBC04")
                ),
                starRatingInactiveColor = ColorUtils.parseColor(
                    styleMap["starRatingInactiveColor"] as? String,
                    Color.parseColor("#DADCE0")
                ),

                // Layout Spacing
                itemSpacing = (styleMap["itemSpacing"] as? Number)?.toFloat() ?: 8f,
                sectionSpacing = (styleMap["sectionSpacing"] as? Number)?.toFloat() ?: 12f,

                // Ad Label
                showAdLabel = (styleMap["showAdLabel"] as? Boolean) ?: true,
                adLabelText = (styleMap["adLabelText"] as? String) ?: "Ad",
                adLabelBackgroundColor = ColorUtils.parseColor(
                    styleMap["adLabelBackgroundColor"] as? String,
                    Color.parseColor("#FBBC04")
                ),
                adLabelTextColor = ColorUtils.parseColor(
                    styleMap["adLabelTextColor"] as? String,
                    Color.WHITE
                ),
                adLabelFontSize = (styleMap["adLabelFontSize"] as? Number)?.toFloat() ?: 10f,
                adLabelCornerRadius = (styleMap["adLabelCornerRadius"] as? Number)?.toFloat() ?: 4f,
                adLabelPaddingTop = getPaddingValue(styleMap["adLabelPadding"], "top", 2f),
                adLabelPaddingLeft = getPaddingValue(styleMap["adLabelPadding"], "left", 6f),
                adLabelPaddingBottom = getPaddingValue(styleMap["adLabelPadding"], "bottom", 2f),
                adLabelPaddingRight = getPaddingValue(styleMap["adLabelPadding"], "right", 6f)
            )
        }

        private fun getPaddingValue(padding: Any?, key: String, default: Float): Float {
            return when (padding) {
                is Map<*, *> -> (padding[key] as? Number)?.toFloat() ?: default
                else -> default
            }
        }

        private fun fontWeightFromInt(weight: Int): Int {
            return when {
                weight >= 700 -> Typeface.BOLD
                else -> Typeface.NORMAL
            }
        }
    }
}
