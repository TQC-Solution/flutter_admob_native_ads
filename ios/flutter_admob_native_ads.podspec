#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_admob_native_ads.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_admob_native_ads'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for displaying AdMob Native Ads with customizable layouts.'
  s.description      = <<-DESC
A Flutter plugin for displaying AdMob Native Ads with customizable layouts
and SwiftUI-style declarative styling. Supports compact, standard, and
full media layout types with comprehensive styling options.
                       DESC
  s.homepage         = 'https://github.com/tqc/flutter_admob_native_ads'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'TQC' => 'dev@tqc.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK', '~> 11.0'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # Privacy manifest
  s.resource_bundles = {'flutter_admob_native_ads_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
