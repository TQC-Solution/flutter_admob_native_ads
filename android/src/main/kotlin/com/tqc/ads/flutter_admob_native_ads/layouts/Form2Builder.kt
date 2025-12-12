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
 * Builder for Form 2 - Standard Layout.
 *
 * Layout structure:
 * NativeAdView
 * └── FrameLayout (Container)
 *     ├── TextView (Ad Label - top right)
 *     └── LinearLayout (Vertical)
 *         ├── LinearLayout (Header - Horizontal)
 *         │   ├── ImageView (Icon - 48dp)
 *         │   └── LinearLayout (Vertical)
 *         │       ├── TextView (Headline)
 *         │       └── RatingBar
 *         ├── MediaView (200dp height)
 *         ├── TextView (Body - max 3 lines)
 *         ├── LinearLayout (Footer - Horizontal)
 *         │   ├── TextView (Price)
 *         │   ├── TextView (Store)
 *         │   └── TextView (Advertiser)
 *         └── Button (CTA - full width)
 */
object Form2Builder {

    // View IDs
    private const val ID_ICON = 2001
    private const val ID_HEADLINE = 2002
    private const val ID_RATING = 2003
    private const val ID_MEDIA = 2004
    private const val ID_BODY = 2005
    private const val ID_PRICE = 2006
    private const val ID_STORE = 2007
    private const val ID_ADVERTISER = 2008
    private const val ID_CTA = 2009
    private const val ID_AD_LABEL = 2010

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

        // === Header Section ===
        val headerLayout = buildHeaderSection(context, styleManager)
        mainLayout.addView(headerLayout)

        // === Media View ===
        val mediaView = MediaView(context).apply {
            id = ID_MEDIA
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                DimensionUtils.dpToPx(context, 200f)
            ).apply {
                topMargin = styleManager.getSectionSpacingPx()
            }
        }
        styleManager.styleMediaView(mediaView)
        mainLayout.addView(mediaView)

        // === Body Text ===
        val bodyView = TextView(context).apply {
            id = ID_BODY
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getSectionSpacingPx()
            }
            visibility = View.GONE
        }
        styleManager.styleBody(bodyView)
        mainLayout.addView(bodyView)

        // === Footer Section ===
        val footerLayout = buildFooterSection(context, styleManager)
        mainLayout.addView(footerLayout)

        // === CTA Button ===
        val ctaButton = Button(context).apply {
            id = ID_CTA
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = styleManager.getSectionSpacingPx()
            }
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
                }
            }
            container.addView(adLabel)
        }

        // Add container to NativeAdView
        nativeAdView.addView(container)

        // Map views to NativeAdView
        mapViews(nativeAdView, headerLayout, mediaView, bodyView, footerLayout, ctaButton)

        return nativeAdView
    }

    private fun buildHeaderSection(context: Context, styleManager: AdStyleManager): LinearLayout {
        val headerLayout = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
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
        headerLayout.addView(iconView)

        // Info layout (headline + rating)
        val infoLayout = LinearLayout(context).apply {
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
        infoLayout.addView(headlineView)

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
        val spacer1 = View(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                styleManager.getItemSpacingPx(),
                1
            )
        }
        footerLayout.addView(spacer1)

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

        // Spacer for expansion
        val spacerFlex = View(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                0,
                1,
                1f
            )
        }
        footerLayout.addView(spacerFlex)

        // Advertiser
        val advertiserView = TextView(context).apply {
            id = ID_ADVERTISER
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            visibility = View.GONE
        }
        styleManager.styleAdvertiser(advertiserView)
        footerLayout.addView(advertiserView)

        return footerLayout
    }

    private fun mapViews(
        nativeAdView: NativeAdView,
        headerLayout: LinearLayout,
        mediaView: MediaView,
        bodyView: TextView,
        footerLayout: LinearLayout,
        ctaButton: Button
    ) {
        nativeAdView.iconView = headerLayout.findViewById(ID_ICON)
        nativeAdView.headlineView = headerLayout.findViewById(ID_HEADLINE)
        nativeAdView.starRatingView = headerLayout.findViewById(ID_RATING)
        nativeAdView.mediaView = mediaView
        nativeAdView.bodyView = bodyView
        nativeAdView.priceView = footerLayout.findViewById(ID_PRICE)
        nativeAdView.storeView = footerLayout.findViewById(ID_STORE)
        nativeAdView.advertiserView = footerLayout.findViewById(ID_ADVERTISER)
        nativeAdView.callToActionView = ctaButton
    }
}
