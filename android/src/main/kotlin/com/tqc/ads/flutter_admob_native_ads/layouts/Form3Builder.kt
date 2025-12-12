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
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Builder for Form 3 - Full Media Layout.
 *
 * Layout structure (larger, more prominent):
 * NativeAdView
 * └── FrameLayout (Container)
 *     ├── TextView (Ad Label - top right)
 *     └── LinearLayout (Vertical)
 *         ├── MediaView (250-300dp height - prominent)
 *         ├── LinearLayout (Header - Horizontal)
 *         │   ├── ImageView (Icon - 64dp - larger)
 *         │   └── LinearLayout (Vertical)
 *         │       ├── TextView (Headline - larger)
 *         │       ├── TextView (Advertiser)
 *         │       └── RatingBar
 *         ├── TextView (Body - max 4 lines)
 *         ├── LinearLayout (Footer - Horizontal)
 *         │   ├── TextView (Price)
 *         │   └── TextView (Store)
 *         └── Button (CTA - prominent with elevation)
 */
object Form3Builder {

    // View IDs
    private const val ID_MEDIA = 3001
    private const val ID_ICON = 3002
    private const val ID_HEADLINE = 3003
    private const val ID_ADVERTISER = 3004
    private const val ID_RATING = 3005
    private const val ID_BODY = 3006
    private const val ID_PRICE = 3007
    private const val ID_STORE = 3008
    private const val ID_CTA = 3009
    private const val ID_AD_LABEL = 3010

    // Larger sizes for full media layout
    private const val MEDIA_HEIGHT_DP = 280f
    private const val ICON_SIZE_DP = 64f

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

        // Create main vertical layout
        val mainLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // === Media View (Prominent) ===
        val mediaView = MediaView(context).apply {
            id = ID_MEDIA
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                DimensionUtils.dpToPx(context, MEDIA_HEIGHT_DP)
            )
        }
        styleManager.styleMediaView(mediaView)
        mainLayout.addView(mediaView)

        // === Header Section ===
        val headerLayout = buildHeaderSection(context, styleManager)
        mainLayout.addView(headerLayout)

        // === Body Text ===
        val bodyView = TextView(context).apply {
            id = ID_BODY
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getSectionSpacingPx()
            }
            maxLines = 4
            visibility = View.GONE
        }
        styleManager.styleBody(bodyView)
        mainLayout.addView(bodyView)

        // === Footer Section ===
        val footerLayout = buildFooterSection(context, styleManager)
        mainLayout.addView(footerLayout)

        // === CTA Button (Prominent) ===
        val ctaButton = Button(context).apply {
            id = ID_CTA
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getSectionSpacingPx()
            }
            // Extra elevation for prominence
            elevation = DimensionUtils.dpToPx(context, 4f).toFloat()
        }
        styleManager.styleButton(ctaButton)
        mainLayout.addView(ctaButton)

        // Add main layout to container
        container.addView(mainLayout)

        // Add Ad label if enabled
        if (styleManager.shouldShowAdLabel()) {
            val adLabel = styleManager.createAdLabel().apply {
                id = ID_AD_LABEL
                layoutParams = FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.WRAP_CONTENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT
                ).apply {
                    gravity = Gravity.TOP or Gravity.END
                    topMargin = DimensionUtils.dpToPx(context, 8f)
                    marginEnd = DimensionUtils.dpToPx(context, 8f)
                }
            }
            container.addView(adLabel)
        }

        // Add container to NativeAdView
        nativeAdView.addView(container)

        // Map views
        mapViews(nativeAdView, mediaView, headerLayout, bodyView, footerLayout, ctaButton)

        return nativeAdView
    }

    private fun buildHeaderSection(context: Context, styleManager: AdStyleManager): LinearLayout {
        val headerLayout = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getSectionSpacingPx()
            }
        }

        // Icon (larger for full media)
        val iconView = ImageView(context).apply {
            id = ID_ICON
            scaleType = ImageView.ScaleType.CENTER_CROP
            val size = DimensionUtils.dpToPx(context, ICON_SIZE_DP)
            layoutParams = LinearLayout.LayoutParams(size, size)
        }
        styleManager.styleIcon(iconView)
        headerLayout.addView(iconView)

        // Info layout
        val infoLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                0,
                ViewGroup.LayoutParams.WRAP_CONTENT,
                1f
            ).apply {
                marginStart = styleManager.getSectionSpacingPx()
            }
        }

        // Headline (larger)
        val headlineView = TextView(context).apply {
            id = ID_HEADLINE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            textSize = 18f // Larger for full media
        }
        styleManager.styleHeadline(headlineView)
        infoLayout.addView(headlineView)

        // Advertiser (below headline)
        val advertiserView = TextView(context).apply {
            id = ID_ADVERTISER
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getItemSpacingPx() / 2
            }
            visibility = View.GONE
        }
        styleManager.styleAdvertiser(advertiserView)
        infoLayout.addView(advertiserView)

        // Rating
        val ratingBar = RatingBar(context, null, android.R.attr.ratingBarStyleSmall).apply {
            id = ID_RATING
            numStars = 5
            setIsIndicator(true)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getItemSpacingPx() / 2
            }
            visibility = View.GONE
        }
        styleManager.styleRatingBar(ratingBar)
        infoLayout.addView(ratingBar)

        headerLayout.addView(infoLayout)

        return headerLayout
    }

    private fun buildFooterSection(context: Context, styleManager: AdStyleManager): LinearLayout {
        val footerLayout = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getItemSpacingPx()
            }
            visibility = View.GONE
        }

        // Price
        val priceView = TextView(context).apply {
            id = ID_PRICE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            visibility = View.GONE
        }
        styleManager.stylePrice(priceView)
        footerLayout.addView(priceView)

        // Spacer
        val spacer = View(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                styleManager.getSectionSpacingPx(),
                1
            )
        }
        footerLayout.addView(spacer)

        // Store
        val storeView = TextView(context).apply {
            id = ID_STORE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            visibility = View.GONE
        }
        styleManager.styleStore(storeView)
        footerLayout.addView(storeView)

        return footerLayout
    }

    private fun mapViews(
        nativeAdView: NativeAdView,
        mediaView: MediaView,
        headerLayout: LinearLayout,
        bodyView: TextView,
        footerLayout: LinearLayout,
        ctaButton: Button
    ) {
        nativeAdView.mediaView = mediaView
        nativeAdView.iconView = headerLayout.findViewById(ID_ICON)
        nativeAdView.headlineView = headerLayout.findViewById(ID_HEADLINE)
        nativeAdView.advertiserView = headerLayout.findViewById(ID_ADVERTISER)
        nativeAdView.starRatingView = headerLayout.findViewById(ID_RATING)
        nativeAdView.bodyView = bodyView
        nativeAdView.priceView = footerLayout.findViewById(ID_PRICE)
        nativeAdView.storeView = footerLayout.findViewById(ID_STORE)
        nativeAdView.callToActionView = ctaButton
    }
}
