package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Form2 Builder - Compact Horizontal with Large Media
 * Based on ad_2.png template
 *
 * Layout: Large Media (Left) + Title + Description + CTA (Right)
 * Height: ~90dp
 */
object Form2Builder {

    private const val ID_MEDIA = 2001
    private const val ID_HEADLINE = 2002
    private const val ID_BODY = 2003
    private const val ID_CTA = 2004
    private const val ID_AD_LABEL = 2005

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            val padding = DimensionUtils.dpToPx(context, 12f)
            setPadding(padding, padding, padding, padding)
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
        }

        // Media (Left)
        val mediaView = MediaView(context).apply {
            id = ID_MEDIA
            val size = DimensionUtils.dpToPx(context, 64f)
            layoutParams = LinearLayout.LayoutParams(size, size).apply {
                marginEnd = DimensionUtils.dpToPx(context, 12f)
            }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#f0f0f0"))
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
            clipToOutline = true
        }
        mainContainer.addView(mediaView)

        // Content
        val contentLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                0,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                1f
            )
        }

        val adLabel = TextView(context).apply {
            id = ID_AD_LABEL
            text = "Ad"
            textSize = 9f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFD700"))
                cornerRadius = DimensionUtils.dpToPx(context, 3f).toFloat()
            }
            val p = DimensionUtils.dpToPx(context, 4f)
            setPadding(p, p / 2, p, p / 2)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = DimensionUtils.dpToPx(context, 4f)
            }
        }
        contentLayout.addView(adLabel)

        val headlineView = TextView(context).apply {
            id = ID_HEADLINE
            textSize = 14f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
        }
        contentLayout.addView(headlineView)

        val bodyView = TextView(context).apply {
            id = ID_BODY
            textSize = 12f
            setTextColor(Color.parseColor("#666666"))
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 2f)
            }
        }
        contentLayout.addView(bodyView)

        mainContainer.addView(contentLayout)

        // CTA
        val ctaButton = Button(context).apply {
            id = ID_CTA
            textSize = 12f
            setTextColor(Color.WHITE)
            setTypeface(null, android.graphics.Typeface.BOLD)
            isAllCaps = false
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#1E88E5"))
                cornerRadius = DimensionUtils.dpToPx(context, 20f).toFloat()
            }
            val pH = DimensionUtils.dpToPx(context, 20f)
            val pV = DimensionUtils.dpToPx(context, 8f)
            setPadding(pH, pV, pH, pV)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                marginStart = DimensionUtils.dpToPx(context, 12f)
            }
        }
        mainContainer.addView(ctaButton)

        nativeAdView.addView(mainContainer)

        nativeAdView.mediaView = mediaView
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
