package com.tqc.ads.flutter_admob_native_ads.platform_view

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * Factory for creating NativeAdPlatformView instances.
 */
class NativeAdViewFactory(
    private val messenger: BinaryMessenger,
    private val layoutType: String
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        val creationParams = args as? Map<String, Any?> ?: emptyMap()

        return NativeAdPlatformView(
            context = context,
            viewId = viewId,
            creationParams = creationParams,
            messenger = messenger,
            layoutType = layoutType
        )
    }
}
