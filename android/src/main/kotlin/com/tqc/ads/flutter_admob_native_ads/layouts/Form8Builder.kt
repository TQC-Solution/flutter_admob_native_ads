package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Form8 Builder - Vertical Media Banner (ad_8.png)
 * Layout: [Wide Media Banner] → [Ad + Title] → [Body] → [CTA]
 */
object Form8Builder {

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            val padding = DimensionUtils.dpToPx(context, 12f)
            setPadding(padding, padding, padding, padding)
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = DimensionUtils.dpToPx(context, 12f).toFloat()
            }
        }

        // Media View - Wide Banner
        val mediaView = MediaView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                DimensionUtils.dpToPx(context, 100f)
            )
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#f0f0f0"))
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
            clipToOutline = true
        }
        mainContainer.addView(mediaView)

        // Content below
        val adLabel = TextView(context).apply {
            text = "Ad"
            textSize = 10f
            setTextColor(Color.parseColor("#5D4037"))
            setTypeface(null, android.graphics.Typeface.BOLD)
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFE0B2"))
                cornerRadius = DimensionUtils.dpToPx(context, 3f).toFloat()
            }
            val padH = DimensionUtils.dpToPx(context, 6f)
            val padV = DimensionUtils.dpToPx(context, 2f)
            setPadding(padH, padV, padH, padV)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = DimensionUtils.dpToPx(context, 12f) }
        }
        mainContainer.addView(adLabel)

        val headlineView = TextView(context).apply {
            textSize = 15f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = DimensionUtils.dpToPx(context, 4f) }
        }
        mainContainer.addView(headlineView)

        val bodyView = TextView(context).apply {
            textSize = 12f
            setTextColor(Color.parseColor("#757575"))
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = DimensionUtils.dpToPx(context, 4f) }
        }
        mainContainer.addView(bodyView)

        val ctaButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = DimensionUtils.dpToPx(context, 12f) }
        }
        styleManager.styleButton(ctaButton)
        mainContainer.addView(ctaButton)

        nativeAdView.addView(mainContainer)
        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
