package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.Space
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

/** Geometry shared by the seven reference templates with inline ad badges. */
internal object TemplateLayoutBuilder {
    fun build(form: Int, context: Context, style: AdStyleManager): NativeAdView {
        fun dp(value: Int) = DimensionUtils.dpToPx(context, value.toFloat())
        fun params(width: Int = ViewGroup.LayoutParams.MATCH_PARENT,
                   height: Int = ViewGroup.LayoutParams.WRAP_CONTENT) = LinearLayout.LayoutParams(width, height)
        fun column() = LinearLayout(context).apply { orientation = LinearLayout.VERTICAL }
        fun row() = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val horizontal = form == 2 || form == 7
        val outlined = form == 11 || form == 12
        val gap = style.getItemSpacingPx()
        val ad = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(-1, -1)
        }
        val main = LinearLayout(context).apply {
            orientation = if (horizontal) LinearLayout.HORIZONTAL else LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = ViewGroup.LayoutParams(-1, -1)
        }
        style.styleMainContainer(main)
        val padding = style.getContainerPaddingPx()
        val extraH = dp(if (form in listOf(4, 5, 12)) 8 else if (form == 2) 0 else if (form == 7) 2 else 4)
        val extraV = dp(if (form in listOf(5, 7, 11, 12)) 4 else 0)
        main.setPadding(padding[0] + extraH, padding[1] + if (form == 7) dp(8) else extraV,
                        padding[2] + extraH, padding[3] + extraV)

        val headline = TextView(context).apply {
            style.styleHeadline(this)
            maxLines = if (form == 7) 2 else 1
            includeFontPadding = false
            ellipsize = TextUtils.TruncateAt.END
        }
        val body = TextView(context).apply {
            style.styleBody(this)
            if (form != 2 && style.options.bodyFontSize == 10f) textSize = 12f
            maxLines = if (form == 2) 2 else if (form == 7) 3 else 1
            includeFontPadding = false
            ellipsize = TextUtils.TruncateAt.END
        }
        val title = row().apply { if (form == 7) gravity = Gravity.TOP }
        if (style.shouldShowAdLabel()) {
            val badge = style.createAdLabel().apply {
                text = style.options.adLabelText.uppercase()
                textSize = if (form == 2) 8f else 10f
                includeFontPadding = false
                setPadding(dp(4), dp(1), dp(4), dp(1))
                if (outlined) {
                    setTextColor(style.options.adLabelBackgroundColor)
                    background = GradientDrawable().apply {
                        setColor(Color.TRANSPARENT)
                        setStroke(dp(1), style.options.adLabelBackgroundColor)
                        cornerRadius = dp(3).toFloat()
                    }
                }
            }
            title.addView(badge, params(-2, -2).apply { marginEnd = dp(if (form == 2) 4 else 6) })
        }
        title.addView(headline, LinearLayout.LayoutParams(0, -2, 1f))
        val text = column()
        text.addView(title, params())
        if (!outlined) text.addView(body, params().apply { topMargin = dp(2) })

        val button = Button(context).apply {
            minWidth = 0
            minimumWidth = 0
            minHeight = 0
            minimumHeight = 0
            includeFontPadding = false
            style.styleButton(this)
            if (form == 2 || form == 7) {
                if (style.options.ctaFontSize == 14f) textSize = 12f
                val verticalPadding = dp(if (form == 2) 4 else 8)
                setPadding(paddingLeft, verticalPadding, paddingRight, verticalPadding)
            }
        }
        val buttonHeight = dp(if (form == 2) 30 else if (form == 7) 34 else 40)
        button.minimumHeight = buttonHeight
        (button.background as? GradientDrawable)?.cornerRadius =
            minOf(dp(style.options.ctaCornerRadius.toInt()).toFloat(), buttonHeight / 2f)
        val icon = ImageView(context).apply {
            scaleType = ImageView.ScaleType.CENTER_CROP
            background = GradientDrawable().apply {
                setColor(Color.TRANSPARENT)
                cornerRadius = dp(if (form == 2) 6 else 8).toFloat()
            }
            clipToOutline = true
        }
        val media = MediaView(context).apply {
            background = GradientDrawable().apply {
                setColor(Color.TRANSPARENT)
                cornerRadius = dp(if (outlined) 3 else 0).toFloat()
            }
            clipToOutline = true
        }

        when (form) {
            2 -> {
                main.addView(icon, params(dp(64), dp(54)).apply { marginEnd = gap })
                main.addView(text, LinearLayout.LayoutParams(0, -2, 1f))
                main.addView(button, params(-2, -2).apply { marginStart = gap })
                button.minimumWidth = dp(80)
                ad.iconView = icon
            }
            7 -> {
                main.addView(media, LinearLayout.LayoutParams(0, -1, 1.075f).apply { marginEnd = gap })
                val right = column()
                right.addView(text, params())
                right.addView(Space(context), LinearLayout.LayoutParams(-1, 0, 1f))
                right.addView(button, params(-1, -2).apply { topMargin = gap })
                main.addView(right, LinearLayout.LayoutParams(0, -1, 1f))
                ad.mediaView = media
            }
            else -> {
                val header: View = if (outlined) title else row().apply {
                    addView(icon, params(dp(40), dp(40)).apply { marginEnd = dp(8) })
                    addView(text, LinearLayout.LayoutParams(0, -2, 1f))
                    ad.iconView = icon
                }
                val headerHeight = dp(if (outlined) { if (form == 11) 20 else 16 } else 40)
                header.minimumHeight = headerHeight
                if (form == 4) {
                    main.addView(media, LinearLayout.LayoutParams(-1, 0, 1f))
                    main.addView(header, params(-1, -2).apply { topMargin = gap })
                } else {
                    main.addView(header, params(-1, -2))
                    main.addView(media, LinearLayout.LayoutParams(-1, 0, 1f).apply { topMargin = gap })
                }
                main.addView(button, params(-1, -2).apply { topMargin = gap })
                ad.mediaView = media
            }
        }
        ad.addView(main)
        ad.headlineView = headline
        if (!outlined) ad.bodyView = body
        ad.callToActionView = button
        return ad
    }
}
