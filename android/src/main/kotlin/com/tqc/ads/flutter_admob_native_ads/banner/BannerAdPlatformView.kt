package com.tqc.ads.flutter_admob_native_ads.banner

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.google.android.gms.ads.AdView
import com.tqc.ads.flutter_admob_native_ads.FlutterAdmobNativeAdsPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

/**
 * Platform view for displaying banner ads.
 */
class BannerAdPlatformView(
    private val context: Context,
    private val viewId: Int,
    private val creationParams: Map<String, Any?>,
    private val messenger: BinaryMessenger
) : PlatformView {

    companion object {
        private const val TAG = "BannerAdPlatformView"
    }

    private val container: FrameLayout = FrameLayout(context).apply {
        layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
    }

    private var adView: AdView? = null
    private val enableDebugLogs: Boolean
    private val controllerId: String?

    init {
        enableDebugLogs = creationParams["enableDebugLogs"] as? Boolean ?: false
        controllerId = creationParams["controllerId"] as? String

        log("Initializing banner platform view")

        registerForAdUpdates()
    }

    /**
     * Registers with the plugin to receive ad updates.
     */
    private fun registerForAdUpdates() {
        if (controllerId.isNullOrEmpty()) {
            log("Invalid controllerId, cannot register for ad updates")
            return
        }

        log("Registering for banner ad updates for controller: $controllerId")

        // Check if ad is already loaded
        val existingAdView = FlutterAdmobNativeAdsPlugin.getInstance()?.getBannerAd(controllerId)
        if (existingAdView != null) {
            log("Banner ad already loaded, adding to container immediately")
            onAdLoaded(existingAdView)
        }

        FlutterAdmobNativeAdsPlugin.getInstance()?.registerBannerAdCallback(controllerId) { adView ->
            onAdLoaded(adView)
        }
    }

    /**
     * Called when an ad is loaded by the loader.
     */
    private fun onAdLoaded(view: AdView) {
        log("Banner ad loaded, adding to container")

        adView?.let { container.removeView(it) }
        adView = view

        container.addView(view, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))
    }

    override fun getView(): View = container

    override fun dispose() {
        log("Disposing banner platform view")
        controllerId?.let {
            FlutterAdmobNativeAdsPlugin.getInstance()?.unregisterBannerAdCallback(it)
        }
        container.removeAllViews()
        adView = null
    }

    private fun log(message: String) {
        if (enableDebugLogs) {
            Log.d(TAG, "[$viewId] $message")
        }
    }
}
