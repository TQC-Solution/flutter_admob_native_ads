import 'package:flutter/widgets.dart';

/// Extension on [EdgeInsets] for serialization.
extension EdgeInsetsExtension on EdgeInsets {
  /// Converts EdgeInsets to a Map for platform channel communication.
  ///
  /// Returns a Map with keys: `top`, `left`, `bottom`, `right`.
  ///
  /// Example:
  /// ```dart
  /// EdgeInsets.all(16).toMap()
  /// // Returns: {'top': 16.0, 'left': 16.0, 'bottom': 16.0, 'right': 16.0}
  /// ```
  Map<String, double> toMap() {
    return {
      'top': top,
      'left': left,
      'bottom': bottom,
      'right': right,
    };
  }

  /// Converts EdgeInsets to a list [top, left, bottom, right].
  List<double> toList() {
    return [top, left, bottom, right];
  }
}

/// Extension for creating EdgeInsets from Map.
extension EdgeInsetsFromMap on Map<String, dynamic> {
  /// Creates an [EdgeInsets] from a Map.
  ///
  /// Expects keys: `top`, `left`, `bottom`, `right`.
  /// Missing keys default to 0.
  EdgeInsets toEdgeInsets() {
    return EdgeInsets.only(
      top: (this['top'] as num?)?.toDouble() ?? 0,
      left: (this['left'] as num?)?.toDouble() ?? 0,
      bottom: (this['bottom'] as num?)?.toDouble() ?? 0,
      right: (this['right'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Extension for creating EdgeInsets from List.
extension EdgeInsetsFromList on List<num> {
  /// Creates an [EdgeInsets] from a list.
  ///
  /// List order: [top, left, bottom, right] or [vertical, horizontal].
  EdgeInsets toEdgeInsets() {
    if (length >= 4) {
      return EdgeInsets.only(
        top: this[0].toDouble(),
        left: this[1].toDouble(),
        bottom: this[2].toDouble(),
        right: this[3].toDouble(),
      );
    } else if (length >= 2) {
      return EdgeInsets.symmetric(
        vertical: this[0].toDouble(),
        horizontal: this[1].toDouble(),
      );
    } else if (length == 1) {
      return EdgeInsets.all(this[0].toDouble());
    }
    return EdgeInsets.zero;
  }
}
