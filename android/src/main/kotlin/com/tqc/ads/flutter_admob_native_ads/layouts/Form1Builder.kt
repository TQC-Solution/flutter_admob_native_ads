package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Builder for Form 1 - Compact Layout.
 *
 * Layout structure:
 * NativeAdView
 * └── FrameLayout (Container)
 *     ├── TextView (Ad Label - top left)
 *     └── LinearLayout (Horizontal)
 *         ├── ImageView (Icon - 48dp)
 *         └── LinearLayout (Vertical - Content)
 *             ├── TextView (Headline - max 2 lines)
 *             ├── RatingBar (optional)
 *             └── Button (CTA)
 */
object Form1Builder {

    // View IDs for mapping
    private const val ID_ICON = 1001
    private const val ID_HEADLINE = 1002
    private const val ID_RATING = 1003
    private const val ID_CTA = 1004
    private const val ID_AD_LABEL = 1005

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Apply container styles
        styleManager.applyContainerStyle(nativeAdView)

        // Create main container
        val container = FrameLayout(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Create horizontal layout
        val horizontalLayout = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Icon
        val iconView = ImageView(context).apply {
            id = ID_ICON
            scaleType = ImageView.ScaleType.CENTER_CROP
            val size = DimensionUtils.dpToPx(context, 48f)
            layoutParams = LinearLayout.LayoutParams(size, size)
        }
        styleManager.styleIcon(iconView)

        // Content layout
        val contentLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                0,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                1f
            ).apply {
                marginStart = styleManager.getItemSpacingPx()
            }
        }

        // Headline
        val headlineView = TextView(context).apply {
            id = ID_HEADLINE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }
        styleManager.styleHeadline(headlineView)

        // Rating bar
        val ratingBar = RatingBar(context, null, android.R.attr.ratingBarStyleSmall).apply {
            id = ID_RATING
            numStars = 5
            isIndicator = true
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getItemSpacingPx() / 2
            }
            visibility = View.GONE
        }
        styleManager.styleRatingBar(ratingBar)

        // CTA Button
        val ctaButton = Button(context).apply {
            id = ID_CTA
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getItemSpacingPx()
            }
        }
        styleManager.styleButton(ctaButton)

        // Assemble content layout
        contentLayout.addView(headlineView)
        contentLayout.addView(ratingBar)
        contentLayout.addView(ctaButton)

        // Assemble horizontal layout
        horizontalLayout.addView(iconView)
        horizontalLayout.addView(contentLayout)

        // Add main layout to container
        container.addView(horizontalLayout)

        // Add Ad label if enabled
        if (styleManager.shouldShowAdLabel()) {
            val adLabel = styleManager.createAdLabel().apply {
                id = ID_AD_LABEL
                layoutParams = FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
                ).apply {
                    gravity = Gravity.TOP or Gravity.END
                }
            }
            container.addView(adLabel)
        }

        // Add container to NativeAdView
        nativeAdView.addView(container)

        // Map views to NativeAdView
        nativeAdView.iconView = iconView
        nativeAdView.headlineView = headlineView
        nativeAdView.starRatingView = ratingBar
        nativeAdView.callToActionView = ctaButton

        return nativeAdView
    }
}
