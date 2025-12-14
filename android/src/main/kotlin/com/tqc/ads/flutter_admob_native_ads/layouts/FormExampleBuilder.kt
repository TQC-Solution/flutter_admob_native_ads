package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
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
 * EXAMPLE CUSTOM BUILDER - Card Style với Gradient Background
 *
 * Đây là ví dụ hoàn chỉnh để bạn tham khảo và phát triển.
 *
 * Layout structure:
 * NativeAdView
 * └── FrameLayout (Main Container với gradient background)
 *     ├── LinearLayout (Content - Vertical)
 *     │   ├── FrameLayout (Header)
 *     │   │   ├── MediaView (Full width với rounded corners)
 *     │   │   └── FrameLayout (Icon overlay - bottom left của media)
 *     │   │       └── ImageView (Icon - circular với border)
 *     │   ├── LinearLayout (Info Section - với padding)
 *     │   │   ├── TextView (Headline - large, bold)
 *     │   │   ├── LinearLayout (Rating + Advertiser - horizontal)
 *     │   │   │   ├── RatingBar (stars)
 *     │   │   │   └── TextView (Advertiser)
 *     │   │   ├── TextView (Body - description)
 *     │   │   └── LinearLayout (Footer - Price + Store)
 *     │   │       ├── TextView (Price - bold)
 *     │   │       └── TextView (Store - subtle)
 *     │   └── Button (CTA - gradient button với shadow)
 *     └── TextView (Ad Label - top right badge)
 *
 * Custom Features:
 * - Gradient background (blue to purple)
 * - Circular icon với white border overlay trên media
 * - Rounded corners cho tất cả elements
 * - CTA button với gradient và shadow effect
 * - Card elevation và shadow
 * - Ad badge ở góc trên phải
 */
object FormExampleBuilder {

    // Custom IDs
    private const val ID_MEDIA = 4001
    private const val ID_ICON = 4002
    private const val ID_HEADLINE = 4003
    private const val ID_RATING = 4004
    private const val ID_ADVERTISER = 4005
    private const val ID_BODY = 4006
    private const val ID_PRICE = 4007
    private const val ID_STORE = 4008
    private const val ID_CTA = 4009
    private const val ID_AD_LABEL = 4010

    // Custom dimensions
    private const val CARD_CORNER_RADIUS = 16f
    private const val MEDIA_HEIGHT_DP = 140f  // Reduced from 200 to fit in 300dp container
    private const val ICON_SIZE_DP = 50f      // Reduced from 60 to fit better
    private const val ICON_BORDER_WIDTH = 3f
    private const val CTA_CORNER_RADIUS = 24f
    private const val ELEVATION_DP = 8f

    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Main container với gradient background
        val mainContainer = createMainContainer(context)

        // Content vertical layout
        val contentLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // === HEADER SECTION (Media + Icon Overlay) ===
        val headerSection = createHeaderSection(context, styleManager)
        contentLayout.addView(headerSection)

        // === INFO SECTION (Headline, Rating, Body, Footer) ===
        val infoSection = createInfoSection(context, styleManager)
        contentLayout.addView(infoSection)

        // === CTA BUTTON ===
        val ctaButton = createCtaButton(context, styleManager)
        contentLayout.addView(ctaButton)

        // Add content to main container
        mainContainer.addView(contentLayout)

        // Add Ad Label badge (top right)
        val adLabel = createAdBadge(context)
        mainContainer.addView(adLabel)

        // Add to native ad view
        nativeAdView.addView(mainContainer)

        // Map views to NativeAdView
        mapViews(nativeAdView, headerSection, infoSection, ctaButton)

        return nativeAdView
    }

    private fun createMainContainer(context: Context): FrameLayout {
        return FrameLayout(context).apply {
            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                if (this is ViewGroup.MarginLayoutParams) {
                    setMargins(
                        DimensionUtils.dpToPx(context, 8f),
                        DimensionUtils.dpToPx(context, 8f),
                        DimensionUtils.dpToPx(context, 8f),
                        DimensionUtils.dpToPx(context, 8f)
                    )
                }
            }

            // Gradient background (blue to purple)
            background = GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                intArrayOf(
                    Color.parseColor("#667eea"), // Blue
                    Color.parseColor("#764ba2")  // Purple
                )
            ).apply {
                cornerRadius = DimensionUtils.dpToPx(context, CARD_CORNER_RADIUS).toFloat()
            }

            // Card elevation & shadow
            elevation = DimensionUtils.dpToPx(context, ELEVATION_DP).toFloat()
        }
    }

    private fun createHeaderSection(context: Context, styleManager: AdStyleManager): FrameLayout {
        val headerContainer = FrameLayout(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
        }

        // Media View với rounded corners
        val mediaView = MediaView(context).apply {
            id = ID_MEDIA
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                DimensionUtils.dpToPx(context, MEDIA_HEIGHT_DP)
            )
            // Rounded corners cho media
            clipToOutline = true
            outlineProvider = android.view.ViewOutlineProvider.BACKGROUND
            background = GradientDrawable().apply {
                cornerRadii = floatArrayOf(
                    DimensionUtils.dpToPx(context, CARD_CORNER_RADIUS).toFloat(),
                    DimensionUtils.dpToPx(context, CARD_CORNER_RADIUS).toFloat(),
                    DimensionUtils.dpToPx(context, CARD_CORNER_RADIUS).toFloat(),
                    DimensionUtils.dpToPx(context, CARD_CORNER_RADIUS).toFloat(),
                    0f, 0f, 0f, 0f
                )
                setColor(Color.parseColor("#f0f0f0"))
            }
        }

        // Icon overlay container (bottom left của media)
        val iconContainer = FrameLayout(context).apply {
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                gravity = Gravity.BOTTOM or Gravity.START
                setMargins(
                    DimensionUtils.dpToPx(context, 16f),
                    0,
                    0,
                    DimensionUtils.dpToPx(context, -30f) // Overlap với section tiếp theo
                )
            }
        }

        // Icon - circular với white border
        val iconView = ImageView(context).apply {
            id = ID_ICON
            scaleType = ImageView.ScaleType.CENTER_CROP
            val size = DimensionUtils.dpToPx(context, ICON_SIZE_DP)
            layoutParams = FrameLayout.LayoutParams(size, size)

            // Circular mask với white border
            background = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.WHITE)
                setStroke(
                    DimensionUtils.dpToPx(context, ICON_BORDER_WIDTH),
                    Color.WHITE
                )
            }
            clipToOutline = true
            outlineProvider = android.view.ViewOutlineProvider.BACKGROUND

            // Shadow
            elevation = DimensionUtils.dpToPx(context, 4f).toFloat()
        }

        iconContainer.addView(iconView)
        headerContainer.addView(mediaView)
        headerContainer.addView(iconContainer)

        return headerContainer
    }

    private fun createInfoSection(context: Context, styleManager: AdStyleManager): LinearLayout {
        val infoLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            val padding = DimensionUtils.dpToPx(context, 12f)  // Reduced from 16 for tighter spacing
            setPadding(padding, padding, padding, padding)
        }

        // Headline - large & bold
        val headlineView = TextView(context).apply {
            id = ID_HEADLINE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            textSize = 20f
            setTextColor(Color.WHITE)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 2
            ellipsize = android.text.TextUtils.TruncateAt.END
        }
        infoLayout.addView(headlineView)

        // Rating + Advertiser row
        val ratingRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 8f)
            }
        }

        val ratingBar = RatingBar(context, null, android.R.attr.ratingBarStyleSmall).apply {
            id = ID_RATING
            numStars = 5
            setIsIndicator(true)
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            visibility = View.GONE
        }

        val advertiserView = TextView(context).apply {
            id = ID_ADVERTISER
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                marginStart = DimensionUtils.dpToPx(context, 8f)
            }
            textSize = 12f
            setTextColor(Color.parseColor("#e0e0e0"))
            visibility = View.GONE
        }

        ratingRow.addView(ratingBar)
        ratingRow.addView(advertiserView)
        infoLayout.addView(ratingRow)

        // Body text
        val bodyView = TextView(context).apply {
            id = ID_BODY
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 12f)
            }
            textSize = 14f
            setTextColor(Color.parseColor("#f0f0f0"))
            maxLines = 3
            ellipsize = android.text.TextUtils.TruncateAt.END
            visibility = View.GONE
        }
        infoLayout.addView(bodyView)

        // Footer - Price + Store
        val footerRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = DimensionUtils.dpToPx(context, 8f)
            }
            visibility = View.GONE
        }

        val priceView = TextView(context).apply {
            id = ID_PRICE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            )
            textSize = 16f
            setTextColor(Color.WHITE)
            setTypeface(null, android.graphics.Typeface.BOLD)
            visibility = View.GONE
        }

        val storeView = TextView(context).apply {
            id = ID_STORE
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                marginStart = DimensionUtils.dpToPx(context, 12f)
            }
            textSize = 12f
            setTextColor(Color.parseColor("#e0e0e0"))
            visibility = View.GONE
        }

        footerRow.addView(priceView)
        footerRow.addView(storeView)
        infoLayout.addView(footerRow)

        return infoLayout
    }

    private fun createCtaButton(context: Context, styleManager: AdStyleManager): Button {
        return Button(context).apply {
            id = ID_CTA
            layoutParams = LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                val margin = DimensionUtils.dpToPx(context, 16f)
                setMargins(margin, 0, margin, margin)
            }

            // Gradient background (yellow to orange)
            background = GradientDrawable(
                GradientDrawable.Orientation.LEFT_RIGHT,
                intArrayOf(
                    Color.parseColor("#f093fb"), // Pink
                    Color.parseColor("#f5576c")  // Red
                )
            ).apply {
                cornerRadius = DimensionUtils.dpToPx(context, CTA_CORNER_RADIUS).toFloat()
            }

            // Text styling
            textSize = 16f
            setTextColor(Color.WHITE)
            setTypeface(null, android.graphics.Typeface.BOLD)
            isAllCaps = false

            // Padding
            val paddingHorizontal = DimensionUtils.dpToPx(context, 24f)
            val paddingVertical = DimensionUtils.dpToPx(context, 12f)
            setPadding(paddingHorizontal, paddingVertical, paddingHorizontal, paddingVertical)

            // Shadow effect
            elevation = DimensionUtils.dpToPx(context, 4f).toFloat()
        }
    }

    private fun createAdBadge(context: Context): TextView {
        return TextView(context).apply {
            id = ID_AD_LABEL
            text = "Ad"
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
            ).apply {
                gravity = Gravity.TOP or Gravity.END
                setMargins(
                    0,
                    DimensionUtils.dpToPx(context, 12f),
                    DimensionUtils.dpToPx(context, 12f),
                    0
                )
            }

            // Badge styling
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#ffd700")) // Gold color
                cornerRadius = DimensionUtils.dpToPx(context, 4f).toFloat()
            }

            textSize = 10f
            setTextColor(Color.parseColor("#333333"))
            setTypeface(null, android.graphics.Typeface.BOLD)

            val padding = DimensionUtils.dpToPx(context, 6f)
            setPadding(padding, padding / 2, padding, padding / 2)

            elevation = DimensionUtils.dpToPx(context, 2f).toFloat()
        }
    }

    private fun mapViews(
        nativeAdView: NativeAdView,
        headerSection: FrameLayout,
        infoSection: LinearLayout,
        ctaButton: Button
    ) {
        // Map từ header
        nativeAdView.mediaView = headerSection.findViewById(ID_MEDIA)
        nativeAdView.iconView = headerSection.findViewById(ID_ICON)

        // Map từ info section
        nativeAdView.headlineView = infoSection.findViewById(ID_HEADLINE)
        nativeAdView.starRatingView = infoSection.findViewById(ID_RATING)
        nativeAdView.advertiserView = infoSection.findViewById(ID_ADVERTISER)
        nativeAdView.bodyView = infoSection.findViewById(ID_BODY)
        nativeAdView.priceView = infoSection.findViewById(ID_PRICE)
        nativeAdView.storeView = infoSection.findViewById(ID_STORE)

        // Map CTA
        nativeAdView.callToActionView = ctaButton
    }
}
