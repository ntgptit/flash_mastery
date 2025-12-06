import 'package:flutter/material.dart';

/// Defines the primary brand color palette following Material 3 guidelines.
/// Light palette follows brand seed; dark palette is anti-eye-strain (warm, low-glare).
class AppColors {
  AppColors._(); // private constructor to prevent instantiation

  // ==================== PRIMARY COLORS (LIGHT) ====================

  /// Main seed color for the ColorScheme (H?a tone).
  static const Color primary = Color(0xFFFF6A3D);

  /// Light variant / container of primary color
  static const Color primaryLight = Color(0xFFFFE2D8);

  /// Dark/on-container variant of primary
  static const Color primaryDark = Color(0xFF7F2F15);

  /// On primary color
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Color on top of primary container
  static const Color onPrimaryContainer = Color(0xFF7F2F15);

  // ==================== PRIMARY COLORS (DARK / ANTI-EYE-STRAIN) ====================

  /// Dark theme primary (coral soft)
  static const Color primaryDarkMode = Color(0xFFFF8A65);

  /// On primary for dark theme
  static const Color onPrimaryDarkMode = Color(0xFF3A1A12);

  /// Primary container for dark theme
  static const Color primaryContainerDark = Color(0xFF7A3F2D);

  /// On primary container for dark theme
  static const Color onPrimaryContainerDark = Color(0xFFFFD8CC);

  // ==================== SECONDARY COLORS ====================

  /// Secondary accent color (light)
  static const Color secondary = Color(0xFFFF9F6E);

  /// Light variant of secondary color
  static const Color secondaryLight = Color(0xFFFFC9AE);

  /// Dark variant of secondary color
  static const Color secondaryDark = Color(0xFF9F5536);

  /// Secondary (dark theme)
  static const Color secondaryDarkMode = Color(0xFFFFAF87);

  /// On secondary (dark theme)
  static const Color onSecondaryDarkMode = Color(0xFF3A1A12);

  /// Secondary container (dark theme)
  static const Color secondaryContainerDark = Color(0xFF7A4A32);

  /// On secondary container (dark theme)
  static const Color onSecondaryContainerDark = Color(0xFFFFD8CC);

  // ==================== TERTIARY COLORS ====================

  /// Tertiary color (light)
  static const Color tertiary = Color(0xFFE75461);

  /// On tertiary color (light)
  static const Color onTertiary = Color(0xFFFFFFFF);

  /// Tertiary (dark theme)
  static const Color tertiaryDarkMode = Color(0xFFFF6F7D);

  /// On tertiary (dark theme)
  static const Color onTertiaryDarkMode = Color(0xFF3A1A12);

  /// Tertiary container (dark theme)
  static const Color tertiaryContainerDark = Color(0xFF7A2F3A);

  /// On tertiary container (dark theme)
  static const Color onTertiaryContainerDark = Color(0xFFFFD8CC);

  // ==================== SEMANTIC COLORS ====================

  /// Error color for error states and messages
  static const Color error = Color(0xFFD32F2F);

  /// Error color for dark theme
  static const Color errorDark = Color(0xFFFF6F6F);

  /// On error for dark theme
  static const Color onErrorDark = Color(0xFF3A1A12);

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
  static const Color backgroundLight = Color(0xFFFFF9F6);

  /// Dark background color (anti-eye-strain)
  static const Color backgroundDark = Color(0xFF101823);

  /// Surface color for cards, sheets, app bars (light mode)
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface variant for light mode
  static const Color surfaceVariant = Color(0xFFF5E7E2);

  /// Surface color for dark mode (warm gray)
  static const Color surfaceDark = Color(0xFF182233);

  /// Surface variant for dark mode (deep warm)
  static const Color surfaceVariantDark = Color(0xFF202C3F);

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
  static const Color border = Color(0xFFD2B9B0);

  /// Outline color for dark surfaces
  static const Color outlineDark = Color(0xFF8C756B);

  // ==================== OVERLAY COLORS ====================

  /// Overlay color for dialogs, modals
  static const Color overlay = Color(0x80000000);

  /// Shimmer base color
  static const Color shimmerBase = Color(0xFFE0E0E0);

  /// Shimmer highlight color
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
