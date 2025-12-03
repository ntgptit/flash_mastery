import 'package:flutter/material.dart';

/// Defines the primary brand color palette following Material 3 guidelines.
/// You can tweak these values once your design guideline is finalized.
class AppColors {
  AppColors._(); // private constructor to prevent instantiation

  // ==================== PRIMARY COLORS ====================

  /// Main seed color for the ColorScheme (e.g. modern blue).
  static const Color primary = Color(0xFF1565C0);

  /// Light variant of primary color
  static const Color primaryLight = Color(0xFF5E92F3);

  /// Dark variant of primary color
  static const Color primaryDark = Color(0xFF003C8F);

  // ==================== SECONDARY COLORS ====================

  /// Secondary accent color – can be used for icons, chips, etc.
  static const Color secondary = Color(0xFF00BFA5);

  /// Light variant of secondary color
  static const Color secondaryLight = Color(0xFF5DF2D6);

  /// Dark variant of secondary color
  static const Color secondaryDark = Color(0xFF008E76);

  // ==================== SEMANTIC COLORS ====================

  /// Error color for error states and messages
  static const Color error = Color(0xFFD32F2F);

  /// Warning color for warnings
  static const Color warning = Color(0xFFF57C00);

  /// Success color for success states
  static const Color success = Color(0xFF388E3C);

  /// Info color for informational messages
  static const Color info = Color(0xFF1976D2);

  // ==================== NEUTRAL COLORS ====================

  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  static const Color black = Color(0xFF000000);

  /// Light background color
  static const Color backgroundLight = Color(0xFFF5F7FB);

  /// Dark background color
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface color for cards, sheets, app bars (light mode)
  static const Color surface = Colors.white;

  /// Surface color for dark mode
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // ==================== GREY SCALE ====================

  /// Grey 50
  static const Color grey50 = Color(0xFFFAFAFA);

  /// Grey 100
  static const Color grey100 = Color(0xFFF5F5F5);

  /// Grey 200
  static const Color grey200 = Color(0xFFEEEEEE);

  /// Grey 300
  static const Color grey300 = Color(0xFFE0E0E0);

  /// Grey 400
  static const Color grey400 = Color(0xFFBDBDBD);

  /// Grey 500
  static const Color grey500 = Color(0xFF9E9E9E);

  /// Grey 600
  static const Color grey600 = Color(0xFF757575);

  /// Grey 700
  static const Color grey700 = Color(0xFF616161);

  /// Grey 800
  static const Color grey800 = Color(0xFF424242);

  /// Grey 900
  static const Color grey900 = Color(0xFF212121);

  // ==================== TEXT COLORS ====================

  /// Primary text color (dark)
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary text color (medium)
  static const Color textSecondary = Color(0xFF757575);

  /// Disabled text color (light)
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Text on primary color background
  static const Color textOnPrimary = Colors.white;

  // ==================== DIVIDER COLORS ====================

  /// Divider color
  static const Color divider = Color(0xFFE0E0E0);

  /// Border color
  static const Color border = Color(0xFFE0E0E0);

  // ==================== OVERLAY COLORS ====================

  /// Overlay color for dialogs, modals
  static const Color overlay = Color(0x80000000);

  /// Shimmer base color
  static const Color shimmerBase = Color(0xFFE0E0E0);

  /// Shimmer highlight color
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}


