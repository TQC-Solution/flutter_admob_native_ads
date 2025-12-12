package com.tqc.ads.flutter_admob_native_ads

import android.content.Context
import android.util.Log
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

        // View type identifiers
        private const val VIEW_TYPE_COMPACT = "flutter_admob_native_ads_compact"
        private const val VIEW_TYPE_STANDARD = "flutter_admob_native_ads_standard"
        private const val VIEW_TYPE_FULL_MEDIA = "flutter_admob_native_ads_fullMedia"
    }

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var messenger: BinaryMessenger

    // Registry of active ad loaders by controller ID
    private val adLoaders = mutableMapOf<String, NativeAdLoader>()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Plugin attached to engine")

        context = flutterPluginBinding.applicationContext
        messenger = flutterPluginBinding.binaryMessenger

        // Setup method channel
        channel = MethodChannel(messenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        // Register platform view factories
        registerPlatformViews(flutterPluginBinding)
    }

    private fun registerPlatformViews(binding: FlutterPlugin.FlutterPluginBinding) {
        // Register compact layout factory
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_COMPACT,
            NativeAdViewFactory(messenger, "compact")
        )

        // Register standard layout factory
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_STANDARD,
            NativeAdViewFactory(messenger, "standard")
        )

        // Register full media layout factory
        binding.platformViewRegistry.registerViewFactory(
            VIEW_TYPE_FULL_MEDIA,
            NativeAdViewFactory(messenger, "fullMedia")
        )

        Log.d(TAG, "Platform view factories registered")
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
    }
}
