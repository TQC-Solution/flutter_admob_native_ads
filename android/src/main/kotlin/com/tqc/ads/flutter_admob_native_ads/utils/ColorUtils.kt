package com.tqc.ads.flutter_admob_native_ads.utils

import android.graphics.Color

/**
 * Utility object for color parsing and manipulation.
 */
object ColorUtils {

    /**
     * Parses a hex color string and returns an Android Color int.
     *
     * Supports formats:
     * - #RGB (e.g., #F00)
     * - #RRGGBB (e.g., #FF0000)
     * - #AARRGGBB (e.g., #80FF0000)
     * - Without # prefix
     *
     * @param hex The hex color string to parse
     * @param defaultColor Color to return if parsing fails
     * @return Android Color int value
     */
    fun parseColor(hex: String?, defaultColor: Int = Color.BLACK): Int {
        if (hex.isNullOrEmpty()) return defaultColor

        return try {
            var colorHex = hex.removePrefix("#").uppercase()

            // Expand #RGB to #RRGGBB
            if (colorHex.length == 3) {
                colorHex = colorHex.map { "$it$it" }.joinToString("")
            }

            // Add alpha if missing (#RRGGBB -> #FFRRGGBB)
            if (colorHex.length == 6) {
                colorHex = "FF$colorHex"
            }

            if (colorHex.length != 8) {
                return defaultColor
            }

            Color.parseColor("#$colorHex")
        } catch (e: Exception) {
            defaultColor
        }
    }

    /**
     * Applies alpha to an existing color.
     *
     * @param color The base color
     * @param alpha Alpha value from 0.0 (transparent) to 1.0 (opaque)
     * @return Color with applied alpha
     */
    fun applyAlpha(color: Int, alpha: Float): Int {
        val alphaInt = (alpha.coerceIn(0f, 1f) * 255).toInt()
        return (color and 0x00FFFFFF) or (alphaInt shl 24)
    }

    /**
     * Extracts alpha component from a color.
     *
     * @param color The color to extract alpha from
     * @return Alpha value from 0 to 255
     */
    fun getAlpha(color: Int): Int = Color.alpha(color)

    /**
     * Checks if a color is considered dark.
     *
     * @param color The color to check
     * @return True if the color is dark, false otherwise
     */
    fun isDark(color: Int): Boolean {
        val darkness = 1 - (0.299 * Color.red(color) +
                0.587 * Color.green(color) +
                0.114 * Color.blue(color)) / 255
        return darkness >= 0.5
    }

    /**
     * Returns a contrasting text color (black or white) for the given background.
     *
     * @param backgroundColor The background color
     * @return Color.WHITE for dark backgrounds, Color.BLACK for light backgrounds
     */
    fun getContrastingTextColor(backgroundColor: Int): Int {
        return if (isDark(backgroundColor)) Color.WHITE else Color.BLACK
    }
}
