# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-12

### Added
- Initial release of Flutter AdMob Native Ads plugin
- Three layout types: compact, standard, and fullMedia
- Comprehensive styling options for all ad components
- SwiftUI-style declarative styling API
- Full native rendering via Platform Views
- Event callbacks: onAdLoaded, onAdFailed, onAdClicked, onAdImpression, onAdOpened, onAdClosed
- Built-in theme presets: light, dark, minimal
- NativeAdController for advanced lifecycle management
- Support for custom loading and error widgets
- Test ad unit ID helpers
- Android support (minSdk 21, Google Mobile Ads SDK 23.0.0)
- iOS support (iOS 13.0+, Google Mobile Ads SDK 11.0)

### Features by Layout Type

#### Compact Layout
- Horizontal layout with icon, headline, rating, and CTA button
- Height: 120-150dp
- Best for: List items, feed integration

#### Standard Layout
- Vertical layout with header, media view, body, footer, and CTA
- Height: 250-300dp
- Best for: General purpose, most use cases

#### Full Media Layout
- Prominent media view with larger icon and enhanced styling
- Height: 350-400dp
- Best for: Premium placements, high engagement

### Styling Options
- CTA button: background color, text color, font, corner radius, padding, border, elevation
- Container: background, corner radius, padding, margin, border, shadow
- Text: headline, body, price, store, advertiser styling
- Media view: height, corner radius, aspect ratio, background
- Icon: size, corner radius, border
- Star rating: size, active/inactive colors
- Ad label: visibility, text, colors, corner radius, padding
- Layout spacing: item spacing, section spacing
