package com.tqc.ads.flutter_admob_native_ads

import com.google.android.gms.ads.nativead.NativeAd
import kotlin.test.Test
import kotlin.test.assertEquals
import org.mockito.Mockito

internal class NativeAdCallbackTest {
    @Test
    fun disposingOldViewPreservesReplacementCallback() {
        val plugin = FlutterAdmobNativeAdsPlugin()
        val controllerId = "theme-change-test"
        val received = mutableListOf<String>()
        val oldCallback: (NativeAd) -> Unit = { received.add("old") }
        val replacementCallback: (NativeAd) -> Unit = { received.add("replacement") }
        try {
            FlutterAdmobNativeAdsPlugin.registerNativeAdCallback(controllerId, oldCallback)
            FlutterAdmobNativeAdsPlugin.registerNativeAdCallback(controllerId, replacementCallback)

            plugin.unregisterAdLoadedCallback(controllerId, oldCallback)
            FlutterAdmobNativeAdsPlugin.invokeNativeAdCallbacks(
                controllerId,
                Mockito.mock(NativeAd::class.java)
            )

            assertEquals(listOf("replacement"), received)
        } finally {
            FlutterAdmobNativeAdsPlugin.clearNativeAdCallbacks(controllerId)
        }
    }
}
