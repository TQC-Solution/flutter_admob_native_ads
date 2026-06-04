// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_admob_native_ads",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        // The Flutter tool requires a library product whose name matches the
        // plugin name (with `-` instead of `_`).
        .library(name: "flutter-admob-native-ads", targets: ["flutter_admob_native_ads"])
    ],
    dependencies: [
        // Provided locally by the Flutter tool during the build (Flutter 3.44+).
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Keep in sync with the `Google-Mobile-Ads-SDK` version in the podspec.
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            "13.4.0"..<"14.0.0"
        )
    ],
    targets: [
        .target(
            name: "flutter_admob_native_ads",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            resources: [
                // Privacy manifest required for iOS 17+.
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
