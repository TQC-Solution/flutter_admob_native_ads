import Flutter
import UIKit
import GoogleMobileAds

/// FlutterAdmobNativeAdsPlugin
///
/// Main plugin class that registers platform views and handles method calls
/// from Flutter for native ad management.
public class FlutterAdmobNativeAdsPlugin: NSObject, FlutterPlugin {

    private static let channelName = "flutter_admob_native_ads"

    // View type identifiers
    private static let viewTypeCompact = "flutter_admob_native_ads_compact"
    private static let viewTypeStandard = "flutter_admob_native_ads_standard"
    private static let viewTypeFullMedia = "flutter_admob_native_ads_fullMedia"

    private var channel: FlutterMethodChannel?
    private var adLoaders: [String: NativeAdLoader] = [:]

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger()
        )

        let instance = FlutterAdmobNativeAdsPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Register platform view factories
        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "compact"),
            withId: viewTypeCompact
        )

        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "standard"),
            withId: viewTypeStandard
        )

        registrar.register(
            NativeAdViewFactory(messenger: registrar.messenger(), layoutType: "fullMedia"),
            withId: viewTypeFullMedia
        )

        print("[FlutterAdmobNativeAds] Plugin registered")
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
    }
}
