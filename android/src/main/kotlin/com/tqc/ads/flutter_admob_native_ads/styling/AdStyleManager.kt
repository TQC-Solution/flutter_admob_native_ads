package com.tqc.ads.flutter_admob_native_ads.styling

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/**
 * Manager for applying styles to native ad views.
 */
class AdStyleManager(
    private val context: Context,
    private val options: AdStyleOptions
) {
    /**
     * Applies container styles to the NativeAdView.
     */
    fun applyContainerStyle(view: NativeAdView) {
        val background = GradientDrawable().apply {
            setColor(options.containerBackgroundColor)
            cornerRadius = DimensionUtils.dpToPx(context, options.containerCornerRadius).toFloat()

            options.containerBorderColor?.let { borderColor ->
                options.containerBorderWidth?.let { borderWidth ->
                    setStroke(DimensionUtils.dpToPx(context, borderWidth), borderColor)
                }
            }
        }
        view.background = background

        view.setPadding(
            DimensionUtils.dpToPx(context, options.containerPaddingLeft),
            DimensionUtils.dpToPx(context, options.containerPaddingTop),
            DimensionUtils.dpToPx(context, options.containerPaddingRight),
            DimensionUtils.dpToPx(context, options.containerPaddingBottom)
        )

        // Apply shadow/elevation
        options.containerShadowRadius?.let { radius ->
            view.elevation = DimensionUtils.dpToPx(context, radius).toFloat()
        }
    }

    /**
     * Applies styles to the CTA button.
     */
    fun styleButton(button: Button) {
        val background = GradientDrawable().apply {
            setColor(options.ctaBackgroundColor)
            cornerRadius = DimensionUtils.dpToPx(context, options.ctaCornerRadius).toFloat()

            options.ctaBorderColor?.let { borderColor ->
                options.ctaBorderWidth?.let { borderWidth ->
                    setStroke(DimensionUtils.dpToPx(context, borderWidth), borderColor)
                }
            }
        }
        button.background = background

        button.setTextColor(options.ctaTextColor)
        button.textSize = options.ctaFontSize
        button.setTypeface(button.typeface, options.ctaFontWeight)
        button.isAllCaps = false

        button.setPadding(
            DimensionUtils.dpToPx(context, options.ctaPaddingLeft),
            DimensionUtils.dpToPx(context, options.ctaPaddingTop),
            DimensionUtils.dpToPx(context, options.ctaPaddingRight),
            DimensionUtils.dpToPx(context, options.ctaPaddingBottom)
        )

        options.ctaElevation?.let { elevation ->
            button.elevation = DimensionUtils.dpToPx(context, elevation).toFloat()
        }
    }

    /**
     * Applies headline text styles.
     */
    fun styleHeadline(textView: TextView) {
        textView.setTextColor(options.headlineTextColor)
        textView.textSize = options.headlineFontSize
        textView.setTypeface(getTypeface(options.headlineFontFamily), options.headlineFontWeight)
        textView.maxLines = options.headlineMaxLines
        textView.ellipsize = android.text.TextUtils.TruncateAt.END
    }

    /**
     * Applies body text styles.
     */
    fun styleBody(textView: TextView) {
        textView.setTextColor(options.bodyTextColor)
        textView.textSize = options.bodyFontSize
        textView.setTypeface(getTypeface(options.bodyFontFamily), options.bodyFontWeight)
        textView.maxLines = options.bodyMaxLines
        textView.ellipsize = android.text.TextUtils.TruncateAt.END
    }

    /**
     * Applies price text styles.
     */
    fun stylePrice(textView: TextView) {
        textView.setTextColor(options.priceTextColor)
        textView.textSize = options.priceFontSize
    }

    /**
     * Applies store text styles.
     */
    fun styleStore(textView: TextView) {
        textView.setTextColor(options.storeTextColor)
        textView.textSize = options.storeFontSize
    }

    /**
     * Applies advertiser text styles.
     */
    fun styleAdvertiser(textView: TextView) {
        textView.setTextColor(options.advertiserTextColor)
        textView.textSize = options.advertiserFontSize
    }

    /**
     * Applies icon image styles.
     */
    fun styleIcon(imageView: ImageView) {
        val size = DimensionUtils.dpToPx(context, options.iconSize)
        imageView.layoutParams?.let { params ->
            params.width = size
            params.height = size
        }

        if (options.iconCornerRadius > 0) {
            imageView.clipToOutline = true
            imageView.outlineProvider = RoundedOutlineProvider(
                DimensionUtils.dpToPx(context, options.iconCornerRadius).toFloat()
            )
        }

        options.iconBorderColor?.let { borderColor ->
            options.iconBorderWidth?.let { borderWidth ->
                val border = GradientDrawable().apply {
                    setColor(Color.TRANSPARENT)
                    setStroke(DimensionUtils.dpToPx(context, borderWidth), borderColor)
                    cornerRadius = DimensionUtils.dpToPx(context, options.iconCornerRadius).toFloat()
                }
                imageView.foreground = border
            }
        }
    }

    /**
     * Applies media view styles.
     */
    fun styleMediaView(mediaView: MediaView) {
        val height = DimensionUtils.dpToPx(context, options.mediaViewHeight)
        mediaView.layoutParams?.let { params ->
            params.height = height
        }

        if (options.mediaViewCornerRadius > 0) {
            mediaView.clipToOutline = true
            mediaView.outlineProvider = RoundedOutlineProvider(
                DimensionUtils.dpToPx(context, options.mediaViewCornerRadius).toFloat()
            )
        }

        options.mediaViewBackgroundColor?.let { color ->
            mediaView.setBackgroundColor(color)
        }
    }

    /**
     * Applies star rating styles.
     */
    fun styleRatingBar(ratingBar: RatingBar) {
        val scale = options.starRatingSize / 16f
        ratingBar.scaleX = scale
        ratingBar.scaleY = scale
        ratingBar.pivotX = 0f
        ratingBar.pivotY = 0f

        // Apply colors via PorterDuff
        ratingBar.progressTintList = android.content.res.ColorStateList.valueOf(options.starRatingActiveColor)
        ratingBar.secondaryProgressTintList = android.content.res.ColorStateList.valueOf(options.starRatingInactiveColor)
        ratingBar.progressBackgroundTintList = android.content.res.ColorStateList.valueOf(options.starRatingInactiveColor)
    }

    /**
     * Creates and styles the "Ad" label view.
     */
    fun createAdLabel(): TextView {
        return TextView(context).apply {
            text = options.adLabelText
            setTextColor(options.adLabelTextColor)
            textSize = options.adLabelFontSize
            setTypeface(typeface, Typeface.BOLD)

            val background = GradientDrawable().apply {
                setColor(options.adLabelBackgroundColor)
                cornerRadius = DimensionUtils.dpToPx(context, options.adLabelCornerRadius).toFloat()
            }
            this.background = background

            setPadding(
                DimensionUtils.dpToPx(context, options.adLabelPaddingLeft),
                DimensionUtils.dpToPx(context, options.adLabelPaddingTop),
                DimensionUtils.dpToPx(context, options.adLabelPaddingRight),
                DimensionUtils.dpToPx(context, options.adLabelPaddingBottom)
            )
        }
    }

    /**
     * Gets item spacing in pixels.
     */
    fun getItemSpacingPx(): Int = DimensionUtils.dpToPx(context, options.itemSpacing)

    /**
     * Gets section spacing in pixels.
     */
    fun getSectionSpacingPx(): Int = DimensionUtils.dpToPx(context, options.sectionSpacing)

    /**
     * Whether to show the ad label.
     */
    fun shouldShowAdLabel(): Boolean = options.showAdLabel

    private fun getTypeface(fontFamily: String?): Typeface {
        return fontFamily?.let {
            try {
                Typeface.create(it, Typeface.NORMAL)
            } catch (e: Exception) {
                Typeface.DEFAULT
            }
        } ?: Typeface.DEFAULT
    }
}

/**
 * OutlineProvider for rounded corners.
 */
class RoundedOutlineProvider(private val radius: Float) : android.view.ViewOutlineProvider() {
    override fun getOutline(view: View, outline: android.graphics.Outline) {
        outline.setRoundRect(0, 0, view.width, view.height, radius)
    }
}
