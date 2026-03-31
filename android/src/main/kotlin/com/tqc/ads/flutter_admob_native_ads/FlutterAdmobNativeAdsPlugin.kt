package com.tqc.ads.flutter_admob_native_ads

import android.content.Context
import android.util.Log
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.nativead.NativeAd
import com.tqc.ads.flutter_admob_native_ads.ad_loader.NativeAdLoader
import com.tqc.ads.flutter_admob_native_ads.banner.BannerAdLoader
import com.tqc.ads.flutter_admob_native_ads.banner.BannerAdSizeExtensions
import com.tqc.ads.flutter_admob_native_ads.banner.BannerAdViewFactory
import com.tqc.ads.flutter_admob_native_ads.platform_view.NativeAdViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * FlutterAdmobNativeAdsPlugin
 *
 * Main plugin class that registers platform views and handles method calls
 * from Flutter for native ad management.
 */
class FlutterAdmobNativeAdsPlugin : FlutterPlugin, MethodCallHandler {

    companion object {
        private const val TAG = "FlutterAdmobNativeAds"
        private const val CHANNEL_NAME = "flutter_admob_native_ads"
        private const val BANNER_CHANNEL_NAME = "flutter_admob_banner_ads"

        // View type identifiers for all 12 forms
        private const val VIEW_TYPE_FORM_1 = "flutter_admob_native_ads_form1"
        private const val VIEW_TYPE_FORM_2 = "flutter_admob_native_ads_form2"
        private const val VIEW_TYPE_FORM_3 = "flutter_admob_native_ads_form3"
        private const val VIEW_TYPE_FORM_4 = "flutter_admob_native_ads_form4"
        private const val VIEW_TYPE_FORM_5 = "flutter_admob_native_ads_form5"
        private const val VIEW_TYPE_FORM_6 = "flutter_admob_native_ads_form6"
        private const val VIEW_TYPE_FORM_7 = "flutter_admob_native_ads_form7"
        private const val VIEW_TYPE_FORM_8 = "flutter_admob_native_ads_form8"
        private const val VIEW_TYPE_FORM_9 = "flutter_admob_native_ads_form9"
        private const val VIEW_TYPE_FORM_10 = "flutter_admob_native_ads_form10"
        private const val VIEW_TYPE_FORM_11 = "flutter_admob_native_ads_form11"
        private const val VIEW_TYPE_FORM_12 = "flutter_admob_native_ads_form12"

        // View type for banner ads
        private const val VIEW_TYPE_BANNER = "flutter_admob_banner_ads"

        // Singleton instance for accessing preloaded ads from platform views
        @Volatile
        private var instance: FlutterAdmobNativeAdsPlugin? = null

        // Static maps to persist across plugin instances (handle multiple onAttachedToEngine calls)
        private val adLoaders = mutableMapOf<String, NativeAdLoader>()
        private val adLoadedCallbacks = mutableMapOf<String, MutableList<(NativeAd) -> Unit>>()
        private val bannerAdLoaders = mutableMapOf<String, BannerAdLoader>()
        private val bannerAdCallbacks = mutableMapOf<String, (AdView) -> Unit>()
        private val loadedBannerAds = mutableMapOf<String, AdView>()

        // Maps to track active ad views for pause/resume rendering (fix GPU crashes on MediaTek)
        private val activeNativeAdViews = mutableMapOf<String, android.view.View>()
        private val activeBannerAdViews = mutableMapOf<String, android.view.View>()

        fun getInstance(): FlutterAdmobNativeAdsPlugin? = instance

        fun getAdLoaders(): Map<String, NativeAdLoader> = adLoaders
        fun setAdLoader(controllerId: String, loader: NativeAdLoader) {
            adLoaders[controllerId] = loader
        }
        fun removeAdLoader(controllerId: String) {
            adLoaders.remove(controllerId)
        }
        fun getAdLoader(controllerId: String): NativeAdLoader? = adLoaders[controllerId]

        fun getBannerAdLoaders(): Map<String, BannerAdLoader> = bannerAdLoaders
        fun setBannerAdLoader(controllerId: String, loader: BannerAdLoader) {
            bannerAdLoaders[controllerId] = loader
        }
        fun removeBannerAdLoader(controllerId: String) {
            bannerAdLoaders.remove(controllerId)
        }
        fun getLoadedBannerAd(controllerId: String): AdView? = loadedBannerAds[controllerId]
        fun setLoadedBannerAd(controllerId: String, adView: AdView) {
            loadedBannerAds[controllerId] = adView
        }

        fun registerNativeAdCallback(controllerId: String, callback: (NativeAd) -> Unit) {
            val callbacks = adLoadedCallbacks.getOrPut(controllerId) { mutableListOf() }
            callbacks.add(callback)
        }

        fun getNativeAdCallbacks(controllerId: String): MutableList<(NativeAd) -> Unit>? {
            return adLoadedCallbacks[controllerId]
        }

        fun clearNativeAdCallbacks(controllerId: String) {
            adLoadedCallbacks.remove(controllerId)
        }

        fun invokeNativeAdCallbacks(controllerId: String, nativeAd: NativeAd) {
            adLoadedCallbacks[controllerId]?.forEach { callback ->
                try {
                    callback(nativeAd)
                } catch (e: Exception) {
                    Log.e(TAG, "Error invoking ad loaded callback for controller: $controllerId", e)
                }
            }
        }

        fun registerBannerAdCallback(controllerId: String, callback: (AdView) -> Unit) {
            bannerAdCallbacks[controllerId] = callback
        }

        fun invokeBannerAdCallback(controllerId: String, adView: AdView) {
            bannerAdCallbacks[controllerId]?.invoke(adView)
        }

        fun clearBannerAdCallback(controllerId: String) {
            bannerAdCallbacks.remove(controllerId)
        }

        fun clearAllAdLoaders() {
            adLoaders.values.forEach { it.destroy() }
            adLoaders.clear()
        }

        fun clearAllBannerAdLoaders() {
            bannerAdLoaders.values.forEach { it.destroy() }
            bannerAdLoaders.clear()
            loadedBannerAds.clear()
        }

        // Methods for tracking active ad views (pause/resume rendering)
        fun registerActiveNativeAdView(controllerId: String, view: android.view.View) {
            activeNativeAdViews[controllerId] = view
        }

        fun unregisterActiveNativeAdView(controllerId: String) {
            activeNativeAdViews.remove(controllerId)
        }

        fun registerActiveBannerAdView(controllerId: String, view: android.view.View) {
            activeBannerAdViews[controllerId] = view
        }

        fun unregisterActiveBannerAdView(controllerId: String) {
            activeBannerAdViews.remove(controllerId)
        }
    }

    private lateinit var channel: MethodChannel
    private lateinit var bannerChannel: MethodChannel
    private lateinit var context: Context
    private lateinit var messenger: BinaryMessenger

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Plugin attached to engine")

        instance = this

        context = flutterPluginBinding.applicationContext
        messenger = flutterPluginBinding.binaryMessenger

        // Setup method channel for native ads
        channel = MethodChannel(messenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        // Setup method channel for banner ads
        bannerChannel = MethodChannel(messenger, BANNER_CHANNEL_NAME)
        bannerChannel.setMethodCallHandler(this)

        // Register platform view factories
        registerPlatformViews(flutterPluginBinding)
    }

    private fun registerPlatformViews(binding: FlutterPlugin.FlutterPluginBinding) {
        // Register all 12 form layout factories
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_1,
            NativeAdViewFactory(messenger, "form1")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_2,
            NativeAdViewFactory(messenger, "form2")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_3,
            NativeAdViewFactory(messenger, "form3")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_4,
            NativeAdViewFactory(messenger, "form4")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_5,
            NativeAdViewFactory(messenger, "form5")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_6,
            NativeAdViewFactory(messenger, "form6")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_7,
            NativeAdViewFactory(messenger, "form7")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_8,
            NativeAdViewFactory(messenger, "form8")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_9,
            NativeAdViewFactory(messenger, "form9")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_10,
            NativeAdViewFactory(messenger, "form10")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_11,
            NativeAdViewFactory(messenger, "form11")
        )
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FORM_12,
            NativeAdViewFactory(messenger, "form12")
        )

        // Register banner ad view factory
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_BANNER,
            BannerAdViewFactory(messenger)
        )

        Log.d(TAG, "Platform view factories registered: Form1-Form12, Banner")
    }

    /**
     * Gets the preloaded native ad for the given controller ID.
     * Returns null if no ad is loaded for the controller.
     */
    fun getPreloadedAd(controllerId: String): NativeAd? {
        val loader = getAdLoader(controllerId)
        val ad = loader?.getNativeAd()

        Log.d(TAG, "getPreloadedAd($controllerId): loader exists=${loader != null}, ad=$ad")

        return ad
    }

    /**
     * Registers a callback to be invoked when an ad is loaded for the given controller.
     * This allows platform views to receive ads without creating their own loaders.
     *
     * Supports multiple callbacks for the same controllerId (e.g., multiple widgets
     * sharing the same controller).
     */
    fun registerAdLoadedCallback(controllerId: String, callback: (NativeAd) -> Unit) {
        registerNativeAdCallback(controllerId, callback)

        Log.d(TAG, "Registered callback for controller: $controllerId")

        // If ad is already loaded, invoke callback immediately
        getPreloadedAd(controllerId)?.let { ad ->
            callback(ad)
        }
    }

    /**
     * Unregisters the ad loaded callback for the given controller.
     */
    fun unregisterAdLoadedCallback(controllerId: String) {
        clearNativeAdCallbacks(controllerId)
    }

    /**
     * Gets the preloaded banner ad view for the given controller ID.
     * Returns null if no ad is loaded for the controller.
     * Checks the cache first, then falls back to the loader.
     */
    fun getBannerAd(controllerId: String): AdView? {
        val fromCache = getLoadedBannerAd(controllerId)
        val fromLoader = getBannerAdLoaders()[controllerId]?.getAdView()

        Log.d(TAG, "getBannerAd($controllerId): fromCache=$fromCache, fromLoader=$fromLoader")

        return fromCache ?: fromLoader
    }

    /**
     * Registers a callback to be invoked when a banner ad is loaded for the given controller.
     * This allows platform views to receive ads without creating their own loaders.
     */
    fun registerBannerAdCallback(controllerId: String, callback: (AdView) -> Unit) {
        // Call companion object method
        Companion.registerBannerAdCallback(controllerId, callback)

        // If ad is already loaded, invoke callback immediately
        getBannerAd(controllerId)?.let { adView ->
            callback(adView)
        }
    }

    /**
     * Unregisters the banner ad loaded callback for the given controller.
     */
    fun unregisterBannerAdCallback(controllerId: String) {
        clearBannerAdCallback(controllerId)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "loadAd" -> handleLoadAd(call, result)
            "reloadAd" -> handleReloadAd(call, result)
            "disposeAd" -> handleDisposeAd(call, result)
            "loadBannerAd" -> handleLoadBannerAd(call, result)
            "reloadBannerAd" -> handleReloadBannerAd(call, result)
            "disposeBannerAd" -> handleDisposeBannerAd(call, result)
            "pauseAdRendering" -> handlePauseAdRendering(call, result)
            "resumeAdRendering" -> handleResumeAdRendering(call, result)
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            else -> result.notImplemented()
        }
    }

    private fun handleLoadAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")
        val adUnitId = call.argument<String>("adUnitId")
        val enableDebugLogs = call.argument<Boolean>("enableDebugLogs") ?: false

        if (controllerId.isNullOrEmpty() || adUnitId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId and adUnitId are required", null)
            return
        }

        @Suppress("UNCHECKED_CAST")
        val testDeviceIds = call.argument<List<String>>("testDeviceIds")

        // Create and store the loader
        val loader = NativeAdLoader(
            context = context,
            adUnitId = adUnitId,
            controllerId = controllerId,
            messenger = messenger,
            enableDebugLogs = enableDebugLogs,
            testDeviceIds = testDeviceIds
        )

        // Set callback to notify registered platform views
        loader.setOnAdLoadedCallback { nativeAd ->
            invokeNativeAdCallbacks(controllerId, nativeAd)
        }

        setAdLoader(controllerId, loader)
        loader.loadAd()

        result.success(null)
    }

    private fun handleReloadAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")
        val adUnitId = call.argument<String>("adUnitId")
        val enableDebugLogs = call.argument<Boolean>("enableDebugLogs") ?: false

        if (controllerId.isNullOrEmpty() || adUnitId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId and adUnitId are required", null)
            return
        }

        // Destroy existing loader
        getAdLoader(controllerId)?.destroy()

        @Suppress("UNCHECKED_CAST")
        val testDeviceIds = call.argument<List<String>>("testDeviceIds")

        // Create new loader
        val loader = NativeAdLoader(
            context = context,
            adUnitId = adUnitId,
            controllerId = controllerId,
            messenger = messenger,
            enableDebugLogs = enableDebugLogs,
            testDeviceIds = testDeviceIds
        )

        // Set callback to notify registered platform views
        loader.setOnAdLoadedCallback { nativeAd ->
            invokeNativeAdCallbacks(controllerId, nativeAd)
        }

        setAdLoader(controllerId, loader)
        loader.loadAd()

        result.success(null)
    }

    private fun handleDisposeAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")

        if (controllerId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId is required", null)
            return
        }

        getAdLoader(controllerId)?.destroy()
        removeAdLoader(controllerId)

        result.success(null)
    }

    private fun handleLoadBannerAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")
        val adUnitId = call.argument<String>("adUnitId")
        val sizeIndex = call.argument<Int>("size") ?: 5
        val enableDebugLogs = call.argument<Boolean>("enableDebugLogs") ?: false
        val customHeight = call.argument<Int>("adaptiveBannerHeight")

        if (controllerId.isNullOrEmpty() || adUnitId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId and adUnitId are required", null)
            return
        }

        val adSize = BannerAdSizeExtensions.getAdSize(sizeIndex, context, customHeight)

        val loader = BannerAdLoader(
            context = context,
            adUnitId = adUnitId,
            controllerId = controllerId,
            channel = bannerChannel,
            adSize = adSize,
            enableDebugLogs = enableDebugLogs
        )

        loader.setOnAdLoadedCallback { adView ->
            setLoadedBannerAd(controllerId, adView)
            invokeBannerAdCallback(controllerId, adView)
        }

        setBannerAdLoader(controllerId, loader)
        loader.loadAd()

        result.success(null)
    }

    private fun handleReloadBannerAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")
        val adUnitId = call.argument<String>("adUnitId")
        val sizeIndex = call.argument<Int>("size") ?: 5
        val enableDebugLogs = call.argument<Boolean>("enableDebugLogs") ?: false
        val customHeight = call.argument<Int>("adaptiveBannerHeight")

        if (controllerId.isNullOrEmpty() || adUnitId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId and adUnitId are required", null)
            return
        }

        getBannerAdLoaders()[controllerId]?.destroy()

        val adSize = BannerAdSizeExtensions.getAdSize(sizeIndex, context, customHeight)

        val loader = BannerAdLoader(
            context = context,
            adUnitId = adUnitId,
            controllerId = controllerId,
            channel = bannerChannel,
            adSize = adSize,
            enableDebugLogs = enableDebugLogs
        )

        loader.setOnAdLoadedCallback { adView ->
            setLoadedBannerAd(controllerId, adView)
            invokeBannerAdCallback(controllerId, adView)
        }

        setBannerAdLoader(controllerId, loader)
        loader.loadAd()

        result.success(null)
    }

    private fun handleDisposeBannerAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")

        if (controllerId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId is required", null)
            return
        }

        getBannerAdLoaders()[controllerId]?.destroy()
        removeBannerAdLoader(controllerId)
        clearBannerAdCallback(controllerId)

        result.success(null)
    }

    private fun handlePauseAdRendering(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")

        if (controllerId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId is required", null)
            return
        }

        // Pause native ad view rendering
        activeNativeAdViews[controllerId]?.let { view ->
            view.visibility = android.view.View.INVISIBLE
            Log.d(TAG, "Paused rendering for native ad controller: $controllerId")
        }

        // Pause banner ad view rendering
        activeBannerAdViews[controllerId]?.let { view ->
            view.visibility = android.view.View.INVISIBLE
            Log.d(TAG, "Paused rendering for banner ad controller: $controllerId")
        }

        result.success(null)
    }

    private fun handleResumeAdRendering(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")

        if (controllerId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId is required", null)
            return
        }

        // Resume native ad view rendering
        activeNativeAdViews[controllerId]?.let { view ->
            view.visibility = android.view.View.VISIBLE
            Log.d(TAG, "Resumed rendering for native ad controller: $controllerId")
        }

        // Resume banner ad view rendering
        activeBannerAdViews[controllerId]?.let { view ->
            view.visibility = android.view.View.VISIBLE
            Log.d(TAG, "Resumed rendering for banner ad controller: $controllerId")
        }

        result.success(null)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        bannerChannel.setMethodCallHandler(null)

        // Clean up all loaders
        clearAllAdLoaders()
        clearAllBannerAdLoaders()

        instance = null
    }
}
