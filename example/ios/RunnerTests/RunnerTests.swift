import Flutter
import UIKit
import XCTest


@testable import flutter_admob_native_ads

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

  func testGetPlatformVersion() {
    let plugin = FlutterAdmobNativeAdsPlugin()

    let call = FlutterMethodCall(methodName: "getPlatformVersion", arguments: [])

    let resultExpectation = expectation(description: "result block must be called.")
    plugin.handle(call) { result in
      XCTAssertEqual(result as! String, "iOS " + UIDevice.current.systemVersion)
      resultExpectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }

}

extension RunnerTests {
  @MainActor
  func testExistingFormsGeometryAndContrast() {
    let heights: [(Int, CGFloat)] = [(1, 65), (6, 253), (8, 138), (9, 240), (10, 120)]
    for dark in [false, true] {
      for width: CGFloat in [320, 360] {
        for (form, height) in heights {
          let name = "form\(form) \(dark ? "dark" : "light") \(width)x\(height)"
          let options = AdStyleOptions.fromMap(["style": [
            "containerBackgroundColor": dark ? "#FF303134" : "#FFFFFFFF",
            "headlineTextColor": dark ? "#FFE8EAED" : "#FF202124",
            "bodyTextColor": dark ? "#FF9AA0A6" : "#FF5F6368",
            "ctaCornerRadius": 99,
          ]])
          let ad = AdLayoutBuilder.buildLayout(layoutType: form, styleOptions: options)
          (ad.headlineView as? UILabel)?.text = "Test mode: A New Take on Shrimp Nutrition"
          (ad.bodyView as? UILabel)?.text = "Learn how Motiv simplifies shrimp diets while supporting performance and immune response."
          (ad.callToActionView as? UIButton)?.setTitle("Learn more", for: .normal)
          ad.frame = CGRect(x: 0, y: 0, width: width, height: height)
          ad.widthAnchor.constraint(equalToConstant: width).isActive = true
          ad.heightAnchor.constraint(equalToConstant: height).isActive = true
          ad.setNeedsLayout()
          ad.layoutIfNeeded()
          for (asset, view) in [("headline", ad.headlineView), ("body", ad.bodyView), ("CTA", ad.callToActionView), ("media", ad.mediaView), ("icon", ad.iconView)] {
            guard let view = view else { continue }
            let frame = view.convert(view.bounds, to: ad)
            print("GEOMETRY \(name) \(asset) \(frame)")
            XCTAssertGreaterThan(frame.width, 0, "\(name) \(asset) width")
            XCTAssertGreaterThan(frame.height, 0, "\(name) \(asset) height")
            XCTAssertTrue(ad.bounds.insetBy(dx: -0.5, dy: -0.5).contains(frame), "\(name) \(asset) extends outside card: \(frame)")
            if let label = view as? UILabel {
              XCTAssertGreaterThanOrEqual(frame.height, label.font.lineHeight - 0.5, "\(name) \(asset) clips even one line")
              var ancestor: UIView? = label
              while let current = ancestor {
                if let background = current.backgroundColor, background.cgColor.alpha > 0.99 {
                  let contrast = contrastRatio(label.textColor, background)
                  print("CONTRAST \(name) \(asset) \(contrast)")
                  XCTAssertGreaterThanOrEqual(contrast, 4.5, "\(name) \(asset) contrast \(contrast)")
                  break
                }
                ancestor = current.superview
              }
            }
          }
        }
      }
    }
  }

  @MainActor
  func testForm6InsetPreservesLightReferenceAndHonorsCustomSurfaces() {
    for (surface, expected) in [("#FFFFFF", "#F1E9E9"), ("#303134", "#303134"), ("#123456", "#123456")] {
      let options = AdStyleOptions.fromMap(["containerBackgroundColor": surface])
      let ad = AdLayoutBuilder.buildLayout(layoutType: 6, styleOptions: options)
      var ancestor = ad.headlineView?.superview
      var actual: UIColor?
      while let current = ancestor {
        if let color = current.backgroundColor, color.cgColor.alpha > 0.99 {
          actual = color
          break
        }
        ancestor = current.superview
      }
      XCTAssertEqual(actual, UIColor(hex: expected), "Surface \(surface)")
    }
  }

  private func contrastRatio(_ foreground: UIColor, _ background: UIColor) -> CGFloat {
    func luminance(_ color: UIColor) -> CGFloat {
      var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
      color.getRed(&r, green: &g, blue: &b, alpha: &a)
      func linear(_ c: CGFloat) -> CGFloat { c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4) }
      return 0.2126 * linear(r) + 0.7152 * linear(g) + 0.0722 * linear(b)
    }
    let a = luminance(foreground), b = luminance(background)
    return (max(a, b) + 0.05) / (min(a, b) + 0.05)
  }
}
