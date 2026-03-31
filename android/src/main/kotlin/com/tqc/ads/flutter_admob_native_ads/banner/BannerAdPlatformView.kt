package com.tqc.ads.flutter_admob_native_ads.banner

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.google.android.gms.ads.AdView
import com.tqc.ads.flutter_admob_native_ads.FlutterAdmobNativeAdsPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * Platform view for displaying banner ads.
 *
 * This view uses the shared banner ad from the plugin's BannerAdLoader
 * instead of creating and loading its own ad. This prevents duplicate
 * ad requests and ensures the ad is loaded only once per controller.
 */
class BannerAdPlatformView(
    private val context: Context,
    private val viewId: Int,
    private val creationParams: Map<String, Any?>,
    private val messenger: BinaryMessenger
) : PlatformView {

    companion object {
        private const val TAG = "BannerAdPlatformView"
        private const val BANNER_CHANNEL_NAME = "flutter_admob_banner_ads"
    }

    private val container: FrameLayout = FrameLayout(context).apply {
        layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
    }

    private val enableDebugLogs: Boolean
    private val controllerId: String?
    private val channel: MethodChannel

    init {
        enableDebugLogs = creationParams["enableDebugLogs"] as? Boolean ?: false
        controllerId = creationParams["controllerId"] as? String
        channel = MethodChannel(messenger, BANNER_CHANNEL_NAME)

        log("Initializing banner platform view for controller: $controllerId")

        // Register to receive the shared banner ad from the loader
        registerForBannerAd()
    }

    /**
     * Registers a callback to receive the banner ad from the shared loader.
     * Also checks if an ad is already loaded and uses it immediately.
     */
    private fun registerForBannerAd() {
        val plugin = FlutterAdmobNativeAdsPlugin.getInstance()

        if (controllerId == null) {
            log("Invalid controllerId")
            return
        }

        log("Registering for banner ad with controller: $controllerId")

        // Register callback to receive ad when it loads
        plugin?.registerBannerAdCallback(controllerId!!) { bannerView ->
            onBannerLoaded(bannerView)
        }

        // Check if ad is already loaded
        val existingBanner = plugin?.getBannerAd(controllerId!!)
        if (existingBanner != null) {
            log("Banner already loaded, using existing ad view")
            onBannerLoaded(existingBanner)
        } else {
            log("No banner loaded yet, waiting for callback")
        }
    }

    /**
     * Called when the banner ad is loaded.
     * Adds the ad view to the container.
     */
    private fun onBannerLoaded(bannerView: AdView) {
        log("Banner received, adding to container")

        // Remove from previous parent if any
        (bannerView.parent as? ViewGroup)?.removeView(bannerView)

        // Clear container and add the banner view
        container.removeAllViews()
        container.addView(bannerView, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))

        // Register this view for pause/resume rendering (fix GPU crashes on MediaTek)
        controllerId?.let { id ->
            FlutterAdmobNativeAdsPlugin.registerActiveBannerAdView(id, bannerView)
            log("Registered banner view for pause/resume rendering")
        }

        log("Banner view added to container")
    }

    /**
     * Sends an event to Flutter via method channel.
     */
    private fun sendEvent(method: String, arguments: Map<String, Any?>) {
        try {
            channel.invokeMethod(method, arguments)
        } catch (e: Exception) {
            log("Error sending event $method: ${e.message}")
        }
    }

    override fun getView(): View = container

    override fun dispose() {
        log("Disposing banner platform view")

        // Unregister from pause/resume tracking
        controllerId?.let { id: String ->
            FlutterAdmobNativeAdsPlugin.unregisterActiveBannerAdView(id)
        }

        // Unregister callback
        controllerId?.let { id: String ->
            FlutterAdmobNativeAdsPlugin.getInstance()?.unregisterBannerAdCallback(id)
        }

        // Remove view from container but don't destroy the ad
        // (it's managed by the BannerAdLoader)
        container.removeAllViews()
    }

    private fun log(message: String) {
        if (enableDebugLogs) {
            Log.d(TAG, "[$viewId] $message")
        }
    }
}
