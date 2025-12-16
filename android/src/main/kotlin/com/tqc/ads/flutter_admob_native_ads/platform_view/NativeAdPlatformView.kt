package com.tqc.ads.flutter_admob_native_ads.platform_view

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.tqc.ads.flutter_admob_native_ads.FlutterAdmobNativeAdsPlugin
import com.tqc.ads.flutter_admob_native_ads.ad_loader.NativeAdLoader
import com.tqc.ads.flutter_admob_native_ads.layouts.AdLayoutBuilder
import com.tqc.ads.flutter_admob_native_ads.styling.AdStyleOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

/**
 * Platform view that displays a native ad.
 */
class NativeAdPlatformView(
    private val context: Context,
    private val viewId: Int,
    private val creationParams: Map<String, Any?>,
    private val messenger: BinaryMessenger,
    private val layoutType: String
) : PlatformView {

    companion object {
        private const val TAG = "NativeAdPlatformView"
    }

    private val container: FrameLayout = FrameLayout(context).apply {
        layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
    }

    private var nativeAdView: NativeAdView? = null
    private var adLoader: NativeAdLoader? = null
    private val styleOptions: AdStyleOptions
    private val enableDebugLogs: Boolean

    init {
        styleOptions = AdStyleOptions.fromMap(creationParams)
        enableDebugLogs = creationParams["enableDebugLogs"] as? Boolean ?: false

        log("Initializing platform view with layout: $layoutType")

        initializeAdLoader()
    }

    private fun initializeAdLoader() {
        val adUnitId = creationParams["adUnitId"] as? String
        val controllerId = creationParams["controllerId"] as? String
        val isPreloaded = creationParams["isPreloaded"] as? Boolean ?: false

        if (adUnitId.isNullOrEmpty() || controllerId.isNullOrEmpty()) {
            log("Invalid adUnitId or controllerId")
            return
        }

        // Check for preloaded ad first
        if (isPreloaded) {
            val preloadedAd = FlutterAdmobNativeAdsPlugin.getInstance()?.getPreloadedAd(controllerId)
            if (preloadedAd != null) {
                log("Using preloaded ad for controller: $controllerId")
                onAdLoaded(preloadedAd)
                return
            }
            log("Preloaded ad not found for controller: $controllerId, falling back to load")
        }

        // Fallback: load ad normally
        @Suppress("UNCHECKED_CAST")
        val testDeviceIds = creationParams["testDeviceIds"] as? List<String>

        adLoader = NativeAdLoader(
            context = context,
            adUnitId = adUnitId,
            controllerId = controllerId,
            messenger = messenger,
            enableDebugLogs = enableDebugLogs,
            testDeviceIds = testDeviceIds
        ).apply {
            setOnAdLoadedCallback { nativeAd ->
                onAdLoaded(nativeAd)
            }
        }

        // Load the ad
        adLoader?.loadAd()
    }

    private fun onAdLoaded(nativeAd: NativeAd) {
        log("Ad loaded, building layout")

        // Remove old view if exists
        nativeAdView?.let {
            container.removeView(it)
        }

        // Build the layout
        val layoutTypeInt = AdLayoutBuilder.getLayoutType(layoutType)
        nativeAdView = AdLayoutBuilder.buildLayout(layoutTypeInt, context, styleOptions)

        // Populate the ad
        populateAdView(nativeAd)

        // Add to container
        container.addView(nativeAdView)
    }

    private fun populateAdView(nativeAd: NativeAd) {
        val adView = nativeAdView ?: return

        // Headline (required)
        (adView.headlineView as? TextView)?.apply {
            text = nativeAd.headline
            visibility = View.VISIBLE
        }

        // Body
        nativeAd.body?.let { body ->
            (adView.bodyView as? TextView)?.apply {
                text = body
                visibility = View.VISIBLE
            }
        }

        // Call to Action (required)
        nativeAd.callToAction?.let { cta ->
            (adView.callToActionView as? Button)?.apply {
                text = cta
                visibility = View.VISIBLE
            }
        }

        // Icon
        nativeAd.icon?.let { icon ->
            (adView.iconView as? ImageView)?.apply {
                setImageDrawable(icon.drawable)
                visibility = View.VISIBLE
            }
        }

        // Star Rating
        nativeAd.starRating?.let { rating ->
            (adView.starRatingView as? RatingBar)?.apply {
                this.rating = rating.toFloat()
                visibility = View.VISIBLE
            }
        }

        // Price
        nativeAd.price?.let { price ->
            (adView.priceView as? TextView)?.apply {
                text = price
                visibility = View.VISIBLE
            }
        }

        // Store
        nativeAd.store?.let { store ->
            (adView.storeView as? TextView)?.apply {
                text = store
                visibility = View.VISIBLE
            }
        }

        // Advertiser
        nativeAd.advertiser?.let { advertiser ->
            (adView.advertiserView as? TextView)?.apply {
                text = advertiser
                visibility = View.VISIBLE
            }
        }

        // Media View
        (adView.mediaView as? MediaView)?.let { mediaView ->
            nativeAd.mediaContent?.let { mediaContent ->
                mediaView.mediaContent = mediaContent
                mediaView.setImageScaleType(ImageView.ScaleType.CENTER_CROP)
            }
        }

        // Register the native ad
        adView.setNativeAd(nativeAd)

        log("Ad view populated successfully")
    }

    override fun getView(): View = container

    override fun dispose() {
        log("Disposing platform view")
        adLoader?.destroy()
        adLoader = null
        nativeAdView = null
        container.removeAllViews()
    }

    private fun log(message: String) {
        if (enableDebugLogs) {
            Log.d(TAG, "[$viewId] $message")
        }
    }
}
