import Flutter
import UIKit

/// Factory for creating NativeAdPlatformView instances.
class NativeAdViewFactory: NSObject, FlutterPlatformViewFactory {

    private let messenger: FlutterBinaryMessenger
    private let layoutType: String

    init(messenger: FlutterBinaryMessenger, layoutType: String) {
        self.messenger = messenger
        self.layoutType = layoutType
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let creationParams = args as? [String: Any] ?? [:]

        return NativeAdPlatformView(
            frame: frame,
            viewId: viewId,
            creationParams: creationParams,
            messenger: messenger,
            layoutType: layoutType
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
