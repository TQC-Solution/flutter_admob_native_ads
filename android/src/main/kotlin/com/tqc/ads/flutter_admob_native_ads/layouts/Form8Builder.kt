package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.Space
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Form8 Builder - Compact Horizontal Layout (ad_8.png)
 * Layout: Row[Media (left) + Column[Row[Ad Badge + Title] + Body + CTA Button]]
 * Compact layout optimized for mobile
 */
object Form8Builder {

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Main horizontal container with media (left) and content column (right)
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            gravity = Gravity.CENTER_VERTICAL
            val containerPadding = styleManager.getContainerPaddingPx()
            setPadding(containerPadding[0], containerPadding[1], containerPadding[2], containerPadding[3])
        }
        styleManager.styleMainContainer(mainContainer)

        // Left section: Media view (120x120dp)
        val mediaView = MediaView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                DimensionUtils.dpToPx(context, 120f),
                DimensionUtils.dpToPx(context, 120f)
            ).apply {
                marginEnd = DimensionUtils.dpToPx(context, 12f)
            }
            background = GradientDrawable().apply {
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
            clipToOutline = true
        }
        mainContainer.addView(mediaView)

        // Right section: Vertical column containing header row, body text, and CTA button with equal spacing
        val contentColumn = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                0,
                DimensionUtils.dpToPx(context, 100f),
                1f
            )
            gravity = Gravity.TOP
        }

        // Header row: Ad badge + headline
        val headerRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            gravity = Gravity.CENTER_VERTICAL
        }

        // Ad Badge label with "Ad" text
        val adLabel = TextView(context).apply {
            text = "Ad"
            textSize = 10f
            setTextColor(Color.parseColor("#5D4037")) // Brown text
            setTypeface(null, android.graphics.Typeface.BOLD)
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFE0B2")) // Light orange background
                cornerRadius = DimensionUtils.dpToPx(context, 3f).toFloat()
            }
            val padH = DimensionUtils.dpToPx(context, 6f)
            val padV = DimensionUtils.dpToPx(context, 2f)
            setPadding(padH, padV, padH, padV)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                marginEnd = DimensionUtils.dpToPx(context, 8f)
            }
        }
        headerRow.addView(adLabel)

        // Headline text (truncates to 1 line)
        val headlineView = TextView(context).apply {
            textSize = 14f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                0,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                1f
            )
        }
        headerRow.addView(headlineView)
        contentColumn.addView(headerRow)

        // Spacer 1: Equal spacing between header and body
        val spacer1 = Space(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                0,
                1f
            )
        }
        contentColumn.addView(spacer1)

        // Body text (2 lines max)
        val bodyView = TextView(context).apply {
            textSize = 12f
            setTextColor(Color.parseColor("#757575")) // Gray text
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }
        contentColumn.addView(bodyView)

        // Spacer 2: Equal spacing between body and CTA button
        val spacer2 = Space(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                0,
                1f
            )
        }
        contentColumn.addView(spacer2)

        // CTA button (full width)
        val ctaButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }
        styleManager.styleButton(ctaButton)
        contentColumn.addView(ctaButton)

        mainContainer.addView(contentColumn)
        nativeAdView.addView(mainContainer)

        // Bind ad components to views
        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
