package com.tqc.ads.flutter_admob_native_ads

import android.content.Context
import android.util.Log
import com.google.android.gms.ads.nativead.NativeAd
import com.tqc.ads.flutter_admob_native_ads.ad_loader.NativeAdLoader
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

        // Singleton instance for accessing preloaded ads from platform views
        @Volatile
        private var instance: FlutterAdmobNativeAdsPlugin? = null

        fun getInstance(): FlutterAdmobNativeAdsPlugin? = instance
    }

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var messenger: BinaryMessenger

    // Registry of active ad loaders by controller ID
    private val adLoaders = mutableMapOf<String, NativeAdLoader>()

    /**
     * Gets the preloaded native ad for the given controller ID.
     * Returns null if no ad is loaded for the controller.
     */
    fun getPreloadedAd(controllerId: String): NativeAd? {
        return adLoaders[controllerId]?.getNativeAd()
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Plugin attached to engine")

        instance = this

        context = flutterPluginBinding.applicationContext
        messenger = flutterPluginBinding.binaryMessenger

        // Setup method channel
        channel = MethodChannel(messenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

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

        Log.d(TAG, "Platform view factories registered: Form1-Form12")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "loadAd" -> handleLoadAd(call, result)
            "reloadAd" -> handleReloadAd(call, result)
            "disposeAd" -> handleDisposeAd(call, result)
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

        Log.d(TAG, "Loading ad for controller: $controllerId")

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

        adLoaders[controllerId] = loader
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

        Log.d(TAG, "Reloading ad for controller: $controllerId")

        // Destroy existing loader
        adLoaders[controllerId]?.destroy()

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

        adLoaders[controllerId] = loader
        loader.loadAd()

        result.success(null)
    }

    private fun handleDisposeAd(call: MethodCall, result: Result) {
        val controllerId = call.argument<String>("controllerId")

        if (controllerId.isNullOrEmpty()) {
            result.error("INVALID_ARGS", "controllerId is required", null)
            return
        }

        Log.d(TAG, "Disposing ad for controller: $controllerId")

        adLoaders[controllerId]?.destroy()
        adLoaders.remove(controllerId)

        result.success(null)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Plugin detached from engine")

        channel.setMethodCallHandler(null)

        // Clean up all loaders
        adLoaders.values.forEach { it.destroy() }
        adLoaders.clear()

        instance = null
    }
}
