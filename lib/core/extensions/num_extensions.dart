import 'package:flutter/material.dart';

/// Extension methods for num (int and double)
extension NumExtensions on num {
  // ==================== SIZING ====================

  /// Convert to SizedBox with height
  SizedBox get heightBox => SizedBox(height: toDouble());

  /// Convert to SizedBox with width
  SizedBox get widthBox => SizedBox(width: toDouble());

  /// Convert to EdgeInsets.all
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// Convert to EdgeInsets.symmetric horizontal
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Convert to EdgeInsets.symmetric vertical
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Convert to EdgeInsets.only left
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());

  /// Convert to EdgeInsets.only right
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());

  /// Convert to EdgeInsets.only top
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());

  /// Convert to EdgeInsets.only bottom
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());

  /// Convert to BorderRadius.circular
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());

  /// Convert to Radius.circular
  Radius get radius => Radius.circular(toDouble());

  // ==================== DURATION ====================

  /// Convert to Duration in milliseconds
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Convert to Duration in seconds
  Duration get seconds => Duration(seconds: toInt());

  /// Convert to Duration in minutes
  Duration get minutes => Duration(minutes: toInt());

  /// Convert to Duration in hours
  Duration get hours => Duration(hours: toInt());

  /// Convert to Duration in days
  Duration get days => Duration(days: toInt());

  // ==================== VALIDATION ====================

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  // ==================== FORMATTING ====================

  /// Format as currency
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Format as percentage
  String toPercentage({int decimals = 1}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Format with thousand separators
  String toFormatted() {
    return toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Format as compact (1K, 1M, 1B)
  String toCompact() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    } else if (this < 1000000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    }
  }

  // ==================== MATH OPERATIONS ====================

  /// Clamp value between min and max
  num clampValue(num min, num max) {
    return clamp(min, max);
  }

  /// Check if value is between min and max (inclusive)
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Get percentage of another number
  double percentageOf(num total) {
    if (total == 0) return 0;
    return (this / total) * 100;
  }

  /// Get value from percentage
  double fromPercentage(num percentage) {
    return toDouble() * (percentage / 100);
  }

  /// Round to decimal places
  double roundToDecimal(int decimalPlaces) {
    final factor = 10.0 * decimalPlaces;
    return (this * factor).round() / factor;
  }

  // ==================== COMPARISON ====================

  /// Check if approximately equal (within tolerance)
  bool isApproximately(num other, {double tolerance = 0.001}) {
    return (this - other).abs() < tolerance;
  }

  /// Get absolute value
  num get absolute => abs();

  /// Get sign (-1, 0, or 1)
  int get signValue => sign.toInt();
}

/// Extension methods specifically for int
extension IntExtensions on int {
  /// Convert to ordinal string (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this % 100 >= 11 && this % 100 <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Convert to Roman numerals
  String get toRoman {
    if (this <= 0 || this >= 4000) return toString();

    const values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    const numerals = [
      'M',
      'CM',
      'D',
      'CD',
      'C',
      'XC',
      'L',
      'XL',
      'X',
      'IX',
      'V',
      'IV',
      'I'
    ];

    var result = '';
    var number = this;

    for (var i = 0; i < values.length; i++) {
      while (number >= values[i]) {
        result += numerals[i];
        number -= values[i];
      }
    }

    return result;
  }

  /// Execute callback n times
  void times(void Function(int index) callback) {
    for (var i = 0; i < this; i++) {
      callback(i);
    }
  }

  /// Generate list from 0 to n-1
  List<int> get range => List.generate(this, (index) => index);

  /// Check if is prime number
  bool get isPrime {
    if (this < 2) return false;
    if (this == 2) return true;
    if (isEven) return false;

    for (var i = 3; i * i <= this; i += 2) {
      if (this % i == 0) return false;
    }
    return true;
  }

  /// Get factorial
  int get factorial {
    if (this < 0) throw ArgumentError('Factorial not defined for negative numbers');
    if (this == 0 || this == 1) return 1;
    return this * (this - 1).factorial;
  }
}

/// Extension methods specifically for double
extension DoubleExtensions on double {
  /// Round to nearest 0.5
  double get roundToHalf {
    return (this * 2).round() / 2;
  }

  /// Convert to percentage (0.5 -> 50%)
  String get toPercentString {
    return '${(this * 100).toStringAsFixed(1)}%';
  }
}
