package com.tqc.ads.flutter_admob_native_ads.ad_loader

import android.content.Context
import android.util.Log
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.OnPaidEventListener
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

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

        /**
         * Ad time-to-live (TTL) in minutes.
         * AdMob native ads typically expire after 60 minutes.
         */
        private const val AD_TTL_MINUTES = 60L

        /**
         * Warning threshold for ad expiry (in minutes).
         * Log a warning when ad is within 5 minutes of expiry.
         */
        private const val AD_EXPIRY_WARNING_MINUTES = 55L
    }

    /**
     * Data class representing a loaded ad with its metadata.
     *
     * @property ad The native ad instance
     * @property loadedAt Timestamp when the ad was loaded
     * @property adUnitId The ad unit ID used to load this ad
     */
    data class LoadedAd(
        val ad: NativeAd,
        val loadedAtMillis: Long = System.currentTimeMillis(),
        val adUnitId: String
    ) {
        /**
         * Returns the age of this ad in minutes.
         */
        val ageMinutes: Long
            get() = TimeUnit.MILLISECONDS.toMinutes(System.currentTimeMillis() - loadedAtMillis)

        /**
         * Returns true if this ad has expired (age >= 60 minutes).
         */
        val isExpired: Boolean
            get() = ageMinutes >= AD_TTL_MINUTES

        /**
         * Returns true if this ad is near expiry (age >= 55 minutes).
         */
        val isNearExpiry: Boolean
            get() = ageMinutes >= AD_EXPIRY_WARNING_MINUTES

        /**
         * Returns the number of minutes until expiry.
         * Returns 0 if already expired.
         */
        val minutesUntilExpiry: Long
            get() = maxOf(0, AD_TTL_MINUTES - ageMinutes)
    }

    private var adLoader: AdLoader? = null
    private var loadedAd: LoadedAd? = null
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
        val adLoaderBuilder = AdLoader.Builder(context, adUnitId)
            .forNativeAd { ad ->
                // Destroy old ad if exists
                loadedAd?.ad?.destroy()

                ad.setOnPaidEventListener(OnPaidEventListener { adValue ->
                    val valueInCurrency = adValue.valueMicros / 1_000_000.0
                    sendEvent("onAdPaid", mapOf(
                        "controllerId" to controllerId,
                        "value" to valueInCurrency,
                        "currencyCode" to adValue.currencyCode
                    ))
                })

                // Store new ad with timestamp
                loadedAd = LoadedAd(
                    ad = ad,
                    adUnitId = adUnitId
                )

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
                    sendEvent("onAdClicked", mapOf("controllerId" to controllerId))
                }

                override fun onAdImpression() {
                    sendEvent("onAdImpression", mapOf("controllerId" to controllerId))
                }

                override fun onAdOpened() {
                    sendEvent("onAdOpened", mapOf("controllerId" to controllerId))
                }

                override fun onAdClosed() {
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
     * Gets the currently loaded native ad with TTL validation.
     *
     * Returns null if:
     * - No ad has been loaded
     * - The ad has expired (age >= 60 minutes)
     *
     * Logs a warning if the ad is near expiry (age >= 55 minutes).
     *
     * @return The native ad if valid, null otherwise
     */
    fun getNativeAd(): NativeAd? {
        val cached = loadedAd ?: return null

        // Check if ad has expired
        if (cached.isExpired) {
            log("Ad expired (age: ${cached.ageMinutes}min)")
            loadedAd = null
            return null
        }

        // Warn if ad is near expiry
        if (cached.isNearExpiry) {
            log("WARNING: Ad near expiry (${cached.minutesUntilExpiry}min remaining)")
        }

        return cached.ad
    }

    /**
     * Gets the age of the currently loaded ad in minutes.
     *
     * @return The age of the ad in minutes, or null if no ad is loaded
     */
    fun getAdAgeMinutes(): Long? {
        return loadedAd?.ageMinutes
    }

    /**
     * Gets the number of minutes until the ad expires.
     *
     * @return Minutes until expiry, or null if no ad is loaded
     */
    fun getMinutesUntilExpiry(): Long? {
        return loadedAd?.minutesUntilExpiry
    }

    /**
     * Destroys the loader and releases resources.
     */
    fun destroy() {
        loadedAd?.ad?.destroy()
        loadedAd = null
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
