package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Form10 Builder - Minimal Text Only (ad_10.png)
 * Layout: [Title] → [Ad badge] → [Body] → [CTA]
 * No icon, no media
 */
object Form10Builder {

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Main container - vertical linear layout
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            val containerPadding = styleManager.getContainerPaddingPx()
            setPadding(containerPadding[0], containerPadding[1], containerPadding[2], containerPadding[3])
        }
        styleManager.styleMainContainer(mainContainer)

        // Title
        val headlineView = TextView(context).apply {
            textSize = 14f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
        }
        mainContainer.addView(headlineView)

        // Ad badge
        val adLabel = TextView(context).apply {
            text = "AD"
            textSize = 8f
            setTextColor(Color.parseColor("#FFC000"))
            setTypeface(null, android.graphics.Typeface.BOLD)
            background = GradientDrawable().apply {
                setColor(Color.TRANSPARENT)
                setStroke(DimensionUtils.dpToPx(context, 1f), Color.parseColor("#FFC000"))
                cornerRadius = DimensionUtils.dpToPx(context, 2f).toFloat()
            }
            val padH = DimensionUtils.dpToPx(context, 4f)
            val padV = DimensionUtils.dpToPx(context, 2f)
            setPadding(padH, padV, padH, padV)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 4f)
            }
        }
        mainContainer.addView(adLabel)

        // Body text
        val bodyView = TextView(context).apply {
            textSize = 11f
            setTextColor(Color.parseColor("#666666"))
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 4f)
            }
        }
        mainContainer.addView(bodyView)

        // CTA button (full width)
        val ctaButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                DimensionUtils.dpToPx(context, 38f)
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 8f)
            }
        }
        styleManager.styleButton(ctaButton)
        mainContainer.addView(ctaButton)

        nativeAdView.addView(mainContainer)
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
