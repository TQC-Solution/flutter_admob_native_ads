package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Form6 Builder - Vertical with Smaller Media (ad_6.png)
 * Layout: [Icon + Ad + Title] → [Body] → [Smaller Media] → [CTA]
 */
object Form6Builder {

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

        val headerRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val iconView = ImageView(context).apply {
            scaleType = ImageView.ScaleType.CENTER_CROP
            val size = DimensionUtils.dpToPx(context, 36f)
            layoutParams = LinearLayout.LayoutParams(size, size).apply {
                marginEnd = DimensionUtils.dpToPx(context, 8f)
            }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#f0f0f0"))
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
        }
        headerRow.addView(iconView)

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
            ).apply { marginEnd = DimensionUtils.dpToPx(context, 8f) }
        }
        headerRow.addView(adLabel)

        val headlineView = TextView(context).apply {
            textSize = 14f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f)
        }
        headerRow.addView(headlineView)
        mainContainer.addView(headerRow)

        val bodyView = TextView(context).apply {
            textSize = 12f
            setTextColor(Color.parseColor("#757575"))
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = DimensionUtils.dpToPx(context, 4f) }
        }
        mainContainer.addView(bodyView)

        val mediaView = MediaView(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                DimensionUtils.dpToPx(context, 120f)
            ).apply { topMargin = DimensionUtils.dpToPx(context, 12f) }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#f0f0f0"))
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
            clipToOutline = true
        }
        mainContainer.addView(mediaView)

        val ctaButton = Button(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply { topMargin = DimensionUtils.dpToPx(context, 12f) }
        }
        styleManager.styleButton(ctaButton)
        mainContainer.addView(ctaButton)

        nativeAdView.addView(mainContainer)
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.mediaView = mediaView
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
