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
    private val styleOptions: AdStyleOptions
    private val enableDebugLogs: Boolean
    private var isLayoutBuilt = false
    private val controllerId: String?

    init {
        styleOptions = AdStyleOptions.fromMap(creationParams)
        enableDebugLogs = creationParams["enableDebugLogs"] as? Boolean ?: false
        controllerId = creationParams["controllerId"] as? String

        log("Initializing platform view with layout: $layoutType")

        // Pre-build the layout once before loading ad
        prebuildLayout()

        // Register to receive ad from plugin's centralized loader
        registerForAdUpdates()
    }

    private fun prebuildLayout() {
        log("Pre-building layout structure")
        val layoutTypeInt = AdLayoutBuilder.getLayoutType(layoutType)
        nativeAdView = AdLayoutBuilder.buildLayout(layoutTypeInt, context, styleOptions)
        isLayoutBuilt = true
    }

    private fun registerForAdUpdates() {
        if (controllerId.isNullOrEmpty()) {
            log("Invalid controllerId, cannot register for ad updates")
            return
        }

        log("Registering for ad updates for controller: $controllerId")

        // Register callback with plugin to receive ad when loaded
        FlutterAdmobNativeAdsPlugin.getInstance()?.registerAdLoadedCallback(controllerId) { nativeAd ->
            onAdLoaded(nativeAd)
        }
    }

    private fun onAdLoaded(nativeAd: NativeAd) {
        log("Ad loaded, populating view with data")

        // Layout should already be built, just populate data
        if (!isLayoutBuilt || nativeAdView == null) {
            log("Layout not pre-built, building now")
            prebuildLayout()
        }

        // Populate the ad data into existing layout
        populateAdView(nativeAd)

        // Add to container if not already added
        if (nativeAdView?.parent == null) {
            container.addView(nativeAdView)
        }
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

        // Unregister callback from plugin
        controllerId?.let {
            FlutterAdmobNativeAdsPlugin.getInstance()?.unregisterAdLoadedCallback(it)
        }

        nativeAdView = null
        container.removeAllViews()
    }

    private fun log(message: String) {
        if (enableDebugLogs) {
            Log.d(TAG, "[$viewId] $message")
        }
    }
}
