import UIKit

/// Extension for UIColor to support hex string parsing.
extension UIColor {

    /// Creates a UIColor from a hex string.
    ///
    /// Supports formats:
    /// - `#RGB` (e.g., `#F00`)
    /// - `#RRGGBB` (e.g., `#FF0000`)
    /// - `#AARRGGBB` (e.g., `#80FF0000`)
    /// - Without `#` prefix
    ///
    /// - Parameter hex: The hex color string
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var alpha: CGFloat = 1.0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        switch length {
        case 3: // RGB (12-bit)
            red = CGFloat((rgb & 0xF00) >> 8) / 15.0
            green = CGFloat((rgb & 0x0F0) >> 4) / 15.0
            blue = CGFloat(rgb & 0x00F) / 15.0

        case 6: // RRGGBB (24-bit)
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0

        case 8: // AARRGGBB (32-bit)
            alpha = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            red = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x000000FF) / 255.0

        default:
            break
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Returns a hex string representation of the color.
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgb = (Int)(alpha * 255) << 24 |
                  (Int)(red * 255) << 16 |
                  (Int)(green * 255) << 8 |
                  (Int)(blue * 255)

        return String(format: "#%08X", rgb)
    }

    /// Checks if the color is considered dark.
    var isDark: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let darkness = 1 - (0.299 * red + 0.587 * green + 0.114 * blue)
        return darkness >= 0.5
    }

    /// Returns a contrasting color (black or white) for text.
    var contrastingColor: UIColor {
        return isDark ? .white : .black
    }
}
