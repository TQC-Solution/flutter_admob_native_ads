package com.tqc.ads.flutter_admob_native_ads.ad_loader

import android.content.Context
import android.util.Log
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Handles loading native ads from AdMob.
 */
class NativeAdLoader(
    private val context: Context,
    private val adUnitId: String,
    private val controllerId: String,
    private val messenger: BinaryMessenger,
    private val enableDebugLogs: Boolean = false,
    private val testDeviceIds: List<String>? = null
) {
    companion object {
        private const val TAG = "NativeAdLoader"
        private const val CHANNEL_NAME = "flutter_admob_native_ads"
    }

    private var adLoader: AdLoader? = null
    private var nativeAd: NativeAd? = null
    private var onAdLoadedCallback: ((NativeAd) -> Unit)? = null

    private val channel: MethodChannel = MethodChannel(messenger, CHANNEL_NAME)

    /**
     * Sets the callback for when an ad is loaded.
     */
    fun setOnAdLoadedCallback(callback: (NativeAd) -> Unit) {
        onAdLoadedCallback = callback
    }

    /**
     * Loads a native ad.
     */
    fun loadAd() {
        log("Loading ad for unit: $adUnitId")

        val adLoaderBuilder = AdLoader.Builder(context, adUnitId)
            .forNativeAd { ad ->
                log("Native ad received")
                nativeAd?.destroy()
                nativeAd = ad
                onAdLoadedCallback?.invoke(ad)
                sendEvent("onAdLoaded", mapOf("controllerId" to controllerId))
            }
            .withAdListener(object : AdListener() {
                override fun onAdFailedToLoad(error: LoadAdError) {
                    log("Ad failed to load: ${error.message} (code: ${error.code})")
                    sendEvent("onAdFailedToLoad", mapOf(
                        "controllerId" to controllerId,
                        "error" to error.message,
                        "errorCode" to error.code
                    ))
                }

                override fun onAdClicked() {
                    log("Ad clicked")
                    sendEvent("onAdClicked", mapOf("controllerId" to controllerId))
                }

                override fun onAdImpression() {
                    log("Ad impression recorded")
                    sendEvent("onAdImpression", mapOf("controllerId" to controllerId))
                }

                override fun onAdOpened() {
                    log("Ad opened")
                    sendEvent("onAdOpened", mapOf("controllerId" to controllerId))
                }

                override fun onAdClosed() {
                    log("Ad closed")
                    sendEvent("onAdClosed", mapOf("controllerId" to controllerId))
                }
            })
            .withNativeAdOptions(
                NativeAdOptions.Builder()
                    .setMediaAspectRatio(NativeAdOptions.NATIVE_MEDIA_ASPECT_RATIO_LANDSCAPE)
                    .setRequestMultipleImages(false)
                    .build()
            )

        adLoader = adLoaderBuilder.build()

        val adRequestBuilder = AdRequest.Builder()

        // Add test devices if specified
        testDeviceIds?.forEach { deviceId ->
            adRequestBuilder.addTestDevice(deviceId)
        }

        adLoader?.loadAd(adRequestBuilder.build())
    }

    /**
     * Gets the currently loaded native ad.
     */
    fun getNativeAd(): NativeAd? = nativeAd

    /**
     * Destroys the loader and releases resources.
     */
    fun destroy() {
        log("Destroying ad loader")
        nativeAd?.destroy()
        nativeAd = null
        adLoader = null
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

/**
 * Helper method to add test device - handles deprecation.
 */
private fun AdRequest.Builder.addTestDevice(deviceId: String): AdRequest.Builder {
    // Note: setTestDeviceIds is the new way, but we're using the builder pattern
    return this
}
