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
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Form1 Builder - Compact Horizontal Layout
 * Based on ad_1.png template
 *
 * Layout: Icon (Left) + Title + Description + CTA (Right)
 * Height: ~80dp
 * Best for: List items, compact placements
 */
object Form1Builder {

    private const val ID_ICON = 1001
    private const val ID_HEADLINE = 1002
    private const val ID_BODY = 1003
    private const val ID_CTA = 1004
    private const val ID_AD_LABEL = 1005

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Main container
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            val padding = DimensionUtils.dpToPx(context, 12f)
            setPadding(padding, padding, padding, padding)
            setBackgroundColor(Color.WHITE)
            
            // Rounded corners
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
        }

        // Icon (Left)
        val iconView = ImageView(context).apply {
            id = ID_ICON
            scaleType = ImageView.ScaleType.CENTER_CROP
            val size = DimensionUtils.dpToPx(context, 48f)
            layoutParams = LinearLayout.LayoutParams(size, size).apply {
                marginEnd = DimensionUtils.dpToPx(context, 12f)
            }
            
            background = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.parseColor("#f0f0f0"))
            }
            clipToOutline = true
        }
        mainContainer.addView(iconView)

        // Middle content (Title + Description)
        val contentLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                0,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                1f
            )
        }

        // Ad Label (small badge)
        val adLabel = TextView(context).apply {
            id = ID_AD_LABEL
            text = "Ad"
            textSize = 9f
            setTextColor(Color.parseColor("#000000"))
            setTypeface(null, android.graphics.Typeface.BOLD)
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFD700"))
                cornerRadius = DimensionUtils.dpToPx(context, 3f).toFloat()
            }
            val padding = DimensionUtils.dpToPx(context, 4f)
            setPadding(padding, padding / 2, padding, padding / 2)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                bottomMargin = DimensionUtils.dpToPx(context, 4f)
            }
        }
        contentLayout.addView(adLabel)

        // Title
        val headlineView = TextView(context).apply {
            id = ID_HEADLINE
            textSize = 14f
            setTextColor(Color.parseColor("#000000"))
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 1
            ellipsize = android.text.TextUtils.TruncateAt.END
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }
        contentLayout.addView(headlineView)

        // Description
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

        // CTA Button (Right)
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
            
            val paddingH = DimensionUtils.dpToPx(context, 20f)
            val paddingV = DimensionUtils.dpToPx(context, 8f)
            setPadding(paddingH, paddingV, paddingH, paddingV)
            
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                marginStart = DimensionUtils.dpToPx(context, 12f)
            }
        }
        mainContainer.addView(ctaButton)

        nativeAdView.addView(mainContainer)

        // Map views
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
