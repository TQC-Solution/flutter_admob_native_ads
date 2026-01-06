import Flutter
import UIKit
import GoogleMobileAds

/// FlutterAdmobNativeAdsPlugin
///
/// Main plugin class that registers platform views and handles method calls
/// from Flutter for native ad management.
public class FlutterAdmobNativeAdsPlugin: NSObject, FlutterPlugin {

    private static let channelName = "flutter_admob_native_ads"

    /// Singleton instance for accessing preloaded ads from platform views
    private static var sharedInstance: FlutterAdmobNativeAdsPlugin?

    /// Gets the shared plugin instance
    public static func shared() -> FlutterAdmobNativeAdsPlugin? {
        return sharedInstance
    }

    // View type identifiers for all 12 forms
    private static let viewTypeForm1 = "flutter_admob_native_ads_form1"
    private static let viewTypeForm2 = "flutter_admob_native_ads_form2"
    private static let viewTypeForm3 = "flutter_admob_native_ads_form3"
    private static let viewTypeForm4 = "flutter_admob_native_ads_form4"
    private static let viewTypeForm5 = "flutter_admob_native_ads_form5"
    private static let viewTypeForm6 = "flutter_admob_native_ads_form6"
    private static let viewTypeForm7 = "flutter_admob_native_ads_form7"
    private static let viewTypeForm8 = "flutter_admob_native_ads_form8"
    private static let viewTypeForm9 = "flutter_admob_native_ads_form9"
    private static let viewTypeForm10 = "flutter_admob_native_ads_form10"
    private static let viewTypeForm11 = "flutter_admob_native_ads_form11"
    private static let viewTypeForm12 = "flutter_admob_native_ads_form12"

    private var channel: FlutterMethodChannel?
    private var adLoaders: [String: NativeAdLoader] = [:]

    /// Registry of ad loaded callbacks by controller ID (for platform views)
    private var adLoadedCallbacks: [String: (GADNativeAd) -> Void] = [:]

    /// Gets the preloaded native ad for the given controller ID.
    /// Returns nil if no ad is loaded for the controller.
    public func getPreloadedAd(controllerId: String) -> GADNativeAd? {
        return adLoaders[controllerId]?.nativeAd
    }

    /// Registers a callback to be invoked when an ad is loaded for the given controller.
    /// This allows platform views to receive ads without creating their own loaders.
    public func registerAdLoadedCallback(controllerId: String, callback: @escaping (GADNativeAd) -> Void) {
        adLoadedCallbacks[controllerId] = callback

        // If ad is already loaded, invoke callback immediately
        if let ad = getPreloadedAd(controllerId: controllerId) {
            callback(ad)
        }
    }

    /// Unregisters the ad loaded callback for the given controller.
    public func unregisterAdLoadedCallback(controllerId: String) {
        adLoadedCallbacks.removeValue(forKey: controllerId)
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )

        let instance = FlutterAdmobNativeAdsPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Set singleton instance
        FlutterAdmobNativeAdsPlugin.sharedInstance = instance

        // Register all 12 form platform view factories
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form1"),
            withId: viewTypeForm1
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form2"),
            withId: viewTypeForm2
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form3"),
            withId: viewTypeForm3
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form4"),
            withId: viewTypeForm4
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form5"),
            withId: viewTypeForm5
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form6"),
            withId: viewTypeForm6
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form7"),
            withId: viewTypeForm7
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form8"),
            withId: viewTypeForm8
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form9"),
            withId: viewTypeForm9
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form10"),
            withId: viewTypeForm10
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form11"),
            withId: viewTypeForm11
        )
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "form12"),
            withId: viewTypeForm12
        )

        print("[FlutterAdmobNativeAds] Plugin registered with Form1-Form12 layouts")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "loadAd":
            handleLoadAd(call, result: result)
        case "reloadAd":
            handleReloadAd(call, result: result)
        case "disposeAd":
            handleDisposeAd(call, result: result)
        case "getPlatformVersion":
            result("iOS \(UIDevice.current.systemVersion)")
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Method Handlers

    private func handleLoadAd(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let controllerId = args["controllerId"] as? String,
              let adUnitId = args["adUnitId"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "controllerId and adUnitId are required",
                details: nil
            ))
            return
        }

        let enableDebugLogs = args["enableDebugLogs"] as? Bool ?? false

        print("[FlutterAdmobNativeAds] Loading ad for controller: \(controllerId)")

        guard let channel = channel else {
            result(FlutterError(
                code: "CHANNEL_ERROR",
                message: "Method channel not available",
                details: nil
            ))
            return
        }

        let loader = NativeAdLoader(
            adUnitId: adUnitId,
            controllerId: controllerId,
            channel: channel,
            enableDebugLogs: enableDebugLogs
        )

        // Set delegate to receive ad loaded events
        loader.delegate = self

        adLoaders[controllerId] = loader
        loader.loadAd()

        result(nil)
    }

    private func handleReloadAd(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let controllerId = args["controllerId"] as? String,
              let adUnitId = args["adUnitId"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "controllerId and adUnitId are required",
                details: nil
            ))
            return
        }

        let enableDebugLogs = args["enableDebugLogs"] as? Bool ?? false

        print("[FlutterAdmobNativeAds] Reloading ad for controller: \(controllerId)")

        // Destroy existing loader
        adLoaders[controllerId]?.destroy()

        guard let channel = channel else {
            result(FlutterError(
                code: "CHANNEL_ERROR",
                message: "Method channel not available",
                details: nil
            ))
            return
        }

        let loader = NativeAdLoader(
            adUnitId: adUnitId,
            controllerId: controllerId,
            channel: channel,
            enableDebugLogs: enableDebugLogs
        )

        // Set delegate to receive ad loaded events
        loader.delegate = self

        adLoaders[controllerId] = loader
        loader.loadAd()

        result(nil)
    }

    private func handleDisposeAd(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let controllerId = args["controllerId"] as? String else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "controllerId is required",
                details: nil
            ))
            return
        }

        print("[FlutterAdmobNativeAds] Disposing ad for controller: \(controllerId)")

        adLoaders[controllerId]?.destroy()
        adLoaders.removeValue(forKey: controllerId)

        result(nil)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        print("[FlutterAdmobNativeAds] Plugin detached from engine")

        // Clean up all loaders
        adLoaders.values.forEach { $0.destroy() }
        adLoaders.removeAll()

        // Clear callbacks
        adLoadedCallbacks.removeAll()

        // Clear singleton instance
        FlutterAdmobNativeAdsPlugin.sharedInstance = nil
    }
}

// MARK: - NativeAdLoaderDelegate

extension FlutterAdmobNativeAdsPlugin: NativeAdLoaderDelegate {

    func adLoader(_ loader: NativeAdLoader, didReceiveNativeAd nativeAd: GADNativeAd) {
        // Notify registered callbacks for this controller
        if let callback = adLoadedCallbacks[loader.controllerId] {
            DispatchQueue.main.async {
                callback(nativeAd)
            }
        }
    }

    func adLoader(_ loader: NativeAdLoader, didFailWithError error: Error) {
        // Error is already sent via method channel by the loader
        print("[FlutterAdmobNativeAds] Ad failed to load: \(error.localizedDescription)")
    }
}
