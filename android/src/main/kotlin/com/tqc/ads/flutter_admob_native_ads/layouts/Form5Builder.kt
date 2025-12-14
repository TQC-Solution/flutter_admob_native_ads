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
 * Form5 Builder
 * Based on ad_5.png template
 */
object Form5Builder {
    fun build(context: Context, styleManager: AdStyleManager): NativeAdView {
        val nativeAdView = NativeAdView(context).apply {
            layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
        }
        
        val mainContainer = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
            val p = DimensionUtils.dpToPx(context, 12f)
            setPadding(p, p, p, p)
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = DimensionUtils.dpToPx(context, 12f).toFloat()
            }
        }
        
        val media = MediaView(context).apply {
            id = 5001
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DimensionUtils.dpToPx(context, 160f))
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#f0f0f0"))
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
            clipToOutline = true
        }
        mainContainer.addView(media)
        
        val icon = ImageView(context).apply {
            id = 5002
            scaleType = ImageView.ScaleType.CENTER_CROP
            val size = DimensionUtils.dpToPx(context, 40f)
            layoutParams = LinearLayout.LayoutParams(size, size).apply {
                topMargin = DimensionUtils.dpToPx(context, 12f)
            }
            background = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.parseColor("#f0f0f0"))
            }
            clipToOutline = true
        }
        mainContainer.addView(icon)
        
        val headline = TextView(context).apply {
            id = 5003
            textSize = 15f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 2
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT).apply {
                topMargin = DimensionUtils.dpToPx(context, 8f)
            }
        }
        mainContainer.addView(headline)
        
        val body = TextView(context).apply {
            id = 5004
            textSize = 12f
            setTextColor(Color.parseColor("#666666"))
            maxLines = 2
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT).apply {
                topMargin = DimensionUtils.dpToPx(context, 4f)
            }
        }
        mainContainer.addView(body)
        
        val cta = Button(context).apply {
            id = 5005
            textSize = 14f
            setTextColor(Color.WHITE)
            setTypeface(null, android.graphics.Typeface.BOLD)
            isAllCaps = false
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#1E88E5"))
                cornerRadius = DimensionUtils.dpToPx(context, 24f).toFloat()
            }
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT).apply {
                topMargin = DimensionUtils.dpToPx(context, 12f)
            }
            val pV = DimensionUtils.dpToPx(context, 12f)
            setPadding(0, pV, 0, pV)
        }
        mainContainer.addView(cta)
        
        nativeAdView.addView(mainContainer)
        nativeAdView.mediaView = media
        nativeAdView.iconView = icon
        nativeAdView.headlineView = headline
        nativeAdView.bodyView = body
        nativeAdView.callToActionView = cta
        return nativeAdView
    }
}
