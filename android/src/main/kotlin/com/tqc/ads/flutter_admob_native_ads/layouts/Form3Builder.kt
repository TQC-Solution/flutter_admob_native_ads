package com.tqc.ads.flutter_admob_native_ads.layouts

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleManager
import com.tqc.ads.flutter_admob_native_ads.utils.DimensionUtils

object Form3Builder {
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
        
        val adLabel = TextView(context).apply {
            text = "Ad"
            textSize = 9f
            setTextColor(Color.BLACK)
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#FFD700"))
                cornerRadius = DimensionUtils.dpToPx(context, 3f).toFloat()
            }
            val p = DimensionUtils.dpToPx(context, 4f)
            setPadding(p, p/2, p, p/2)
        }
        mainContainer.addView(adLabel)
        
        val headline = TextView(context).apply {
            id = 3001
            textSize = 16f
            setTextColor(Color.BLACK)
            setTypeface(null, android.graphics.Typeface.BOLD)
            maxLines = 2
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT).apply {
                topMargin = DimensionUtils.dpToPx(context, 8f)
            }
        }
        mainContainer.addView(headline)
        
        val body = TextView(context).apply {
            id = 3002
            textSize = 12f
            setTextColor(Color.parseColor("#666666"))
            maxLines = 2
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT).apply {
                topMargin = DimensionUtils.dpToPx(context, 4f)
            }
        }
        mainContainer.addView(body)
        
        val media = MediaView(context).apply {
            id = 3003
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DimensionUtils.dpToPx(context, 180f)).apply {
                topMargin = DimensionUtils.dpToPx(context, 12f)
            }
            background = GradientDrawable().apply {
                setColor(Color.parseColor("#f0f0f0"))
                cornerRadius = DimensionUtils.dpToPx(context, 8f).toFloat()
            }
            clipToOutline = true
        }
        mainContainer.addView(media)
        
        val cta = Button(context).apply {
            id = 3004
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
        nativeAdView.headlineView = headline
        nativeAdView.bodyView = body
        nativeAdView.mediaView = media
        nativeAdView.callToActionView = cta
        return nativeAdView
    }
}
