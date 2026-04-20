package com.tqc.ads.flutter_admob_native_ads.banner

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.OnPaidEventListener
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
    private val mainHandler = Handler(Looper.getMainLooper())

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
        adView = AdView(context)
        adView?.adUnitId = adUnitId
        adView?.setAdSize(adSize)

        adView?.setOnPaidEventListener(OnPaidEventListener { adValue ->
            val valueInCurrency = adValue.valueMicros / 1_000_000.0
            sendEvent("onAdPaid", mapOf(
                "controllerId" to controllerId,
                "value" to valueInCurrency,
                "currencyCode" to adValue.currencyCode
            ))
        })

        adView?.adListener = object : AdListener() {
            override fun onAdLoaded() {
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
        adView?.destroy()
        adView = null
        onAdLoadedCallback = null
    }

    /**
     * Sends an event to Flutter via method channel.
     */
    private fun sendEvent(method: String, arguments: Map<String, Any?>) {
        val emit = {
            try {
                channel.invokeMethod(method, arguments)
            } catch (e: Exception) {
                log("Error sending event $method: ${e.message}")
            }
        }
        if (Looper.myLooper() == Looper.getMainLooper()) {
            emit()
        } else {
            mainHandler.post { emit() }
        }
    }

    private fun log(message: String) {
        if (enableDebugLogs) {
            Log.d(TAG, "[$controllerId] $message")
        }
    }
}
