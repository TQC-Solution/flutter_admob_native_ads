import 'dart:ui';

/// Extension on [Color] for converting to hex string formats.
extension ColorExtension on Color {
  /// Converts the color to a hex string with alpha channel.
  ///
  /// Returns format: `#AARRGGBB`
  ///
  /// Example:
  /// ```dart
  /// Colors.red.toHexWithAlpha() // Returns '#FFFF0000'
  /// Colors.blue.withOpacity(0.5).toHexWithAlpha() // Returns '#7F0000FF'
  /// ```
  String toHexWithAlpha() {
    final a = (this.a * 255).round().toRadixString(16).padLeft(2, '0');
    final r = (this.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (this.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (this.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$a$r$g$b'.toUpperCase();
  }

  /// Converts the color to a hex string without alpha channel.
  ///
  /// Returns format: `#RRGGBB`
  ///
  /// Example:
  /// ```dart
  /// Colors.red.toHex() // Returns '#FF0000'
  /// Colors.blue.toHex() // Returns '#0000FF'
  /// ```
  String toHex() {
    final r = (this.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (this.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (this.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  /// Converts the color to a hex string without the leading `#`.
  ///
  /// Returns format: `RRGGBB`
  ///
  /// Example:
  /// ```dart
  /// Colors.red.toHexWithoutHash() // Returns 'FF0000'
  /// ```
  String toHexWithoutHash() {
    final r = (this.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (this.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (this.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '$r$g$b'.toUpperCase();
  }

  /// Converts the color to a hex string without hash and with alpha.
  ///
  /// Returns format: `AARRGGBB`
  String toHexWithAlphaWithoutHash() {
    final a = (this.a * 255).round().toRadixString(16).padLeft(2, '0');
    final r = (this.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (this.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (this.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '$a$r$g$b'.toUpperCase();
  }
}

/// Extension for parsing hex color strings.
extension HexColorParsing on String {
  /// Parses a hex color string and returns a [Color].
  ///
  /// Supports formats:
  /// - `#RGB` (e.g., `#F00` for red)
  /// - `#RRGGBB` (e.g., `#FF0000` for red)
  /// - `#AARRGGBB` (e.g., `#80FF0000` for semi-transparent red)
  /// - Without `#` prefix (e.g., `FF0000`)
  ///
  /// Returns [Color] with parsed values, or [defaultColor] if parsing fails.
  Color toColor({Color defaultColor = const Color(0xFF000000)}) {
    try {
      String hex = replaceFirst('#', '').toUpperCase();

      if (hex.length == 3) {
        // Expand #RGB to #RRGGBB
        hex = hex.split('').map((c) => '$c$c').join();
      }

      if (hex.length == 6) {
        // Add alpha channel
        hex = 'FF$hex';
      }

      if (hex.length != 8) {
        return defaultColor;
      }

      final int value = int.parse(hex, radix: 16);
      return Color(value);
    } catch (_) {
      return defaultColor;
    }
  }
}
