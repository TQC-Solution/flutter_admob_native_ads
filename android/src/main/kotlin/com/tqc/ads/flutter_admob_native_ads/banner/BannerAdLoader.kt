package com.tqc.ads.flutter_admob_native_ads.banner

import android.content.Context
import android.util.Log
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.LoadAdError
import io.flutter.plugin.common.MethodChannel

/**
 * Handles loading banner ads from AdMob.
 */
class BannerAdLoader(
    private val context: Context,
    private val adUnitId: String,
    private val controllerId: String,
    private val channel: MethodChannel,
    private val adSize: AdSize,
    private val enableDebugLogs: Boolean = false
) {
    companion object {
        private const val TAG = "BannerAdLoader"
    }

    private var adView: AdView? = null
    private var onAdLoadedCallback: ((AdView) -> Unit)? = null

    /**
     * Sets the callback for when an ad is loaded.
     */
    fun setOnAdLoadedCallback(callback: (AdView) -> Unit) {
        onAdLoadedCallback = callback
    }

    /**
     * Loads a banner ad.
     */
    fun loadAd() {
        log("Loading banner ad for unit: $adUnitId, size: ${adSize}")

        adView = AdView(context)
        adView?.adUnitId = adUnitId
        adView?.setAdSize(adSize)

        adView?.adListener = object : AdListener() {
            override fun onAdLoaded() {
                log("Banner ad loaded")
                adView?.let { onAdLoadedCallback?.invoke(it) }
                sendEvent("onAdLoaded", mapOf("controllerId" to controllerId))
            }

            override fun onAdFailedToLoad(error: LoadAdError) {
                log("Banner ad failed to load: ${error.message} (code: ${error.code})")
                sendEvent("onAdFailedToLoad", mapOf(
                    "controllerId" to controllerId,
                    "error" to (error.message ?: "Unknown error"),
                    "errorCode" to error.code
                ))
            }

            override fun onAdClicked() {
                log("Banner ad clicked")
                sendEvent("onAdClicked", mapOf("controllerId" to controllerId))
            }

            override fun onAdImpression() {
                log("Banner ad impression recorded")
                sendEvent("onAdImpression", mapOf("controllerId" to controllerId))
            }

            override fun onAdOpened() {
                log("Banner ad opened")
                sendEvent("onAdOpened", mapOf("controllerId" to controllerId))
            }

            override fun onAdClosed() {
                log("Banner ad closed")
                sendEvent("onAdClosed", mapOf("controllerId" to controllerId))
            }
        }

        adView?.loadAd(AdRequest.Builder().build())
    }

    /**
     * Gets the currently loaded banner view.
     */
    fun getAdView(): AdView? = adView

    /**
     * Destroys the loader and releases resources.
     */
    fun destroy() {
        log("Destroying banner ad loader")
        adView?.destroy()
        adView = null
        onAdLoadedCallback = null
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

    private fun log(message: String) {
        if (enableDebugLogs) {
            Log.d(TAG, "[$controllerId] $message")
        }
    }
}
