import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines the global font / text style system for the app using Material 3.
class AppTypography {
  AppTypography._();

  static const double baseFontSize = 14;
  static const List<String> _fontFamilyFallback = ['Pretendard', 'sans-serif'];

  static String get primaryFontFamily =>
      GoogleFonts.inter().fontFamily ?? 'Inter';
  static List<String> get fontFallback => _fontFamilyFallback;

  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacing = -0.05,
  }) {
    final base = GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
    return base.copyWith(fontFamilyFallback: _fontFamilyFallback);
  }

  // ==================== DISPLAY STYLES ====================

  /// Display Large (57sp)
  static final TextStyle displayLarge = _inter(
    size: 57,
    weight: FontWeight.w700,
    letterSpacing: -0.06,
    height: 1.3,
  );

  /// Display Medium (45sp)
  static final TextStyle displayMedium = _inter(
    size: 45,
    weight: FontWeight.w700,
    letterSpacing: -0.06,
    height: 1.3,
  );

  /// Display Small (36sp)
  static final TextStyle displaySmall = _inter(
    size: 36,
    weight: FontWeight.w700,
    letterSpacing: -0.05,
    height: 1.3,
  );

  // ==================== HEADLINE STYLES ====================

  /// Headline Large (32sp)
  static final TextStyle headlineLarge = _inter(
    size: 32,
    weight: FontWeight.w700,
    letterSpacing: -0.04,
    height: 1.32,
  );

  /// Headline Medium (28sp)
  static final TextStyle headlineMedium = _inter(
    size: 28,
    weight: FontWeight.w700,
    letterSpacing: -0.04,
    height: 1.32,
  );

  /// Headline Small (24sp)
  static final TextStyle headlineSmall = _inter(
    size: 24,
    weight: FontWeight.w700,
    letterSpacing: -0.03,
    height: 1.32,
  );

  // ==================== TITLE STYLES ====================

  /// Title Large (22sp)
  static final TextStyle titleLarge = _inter(
    size: 22,
    weight: FontWeight.w700,
    letterSpacing: -0.03,
    height: 1.36,
  );

  /// Title Medium (16sp)
  static final TextStyle titleMedium = _inter(
    size: 16,
    weight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.4,
  );

  /// Title Small (14sp)
  static final TextStyle titleSmall = _inter(
    size: 14,
    weight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.4,
  );

  // ==================== BODY STYLES ====================

  /// Body Large (16sp)
  static final TextStyle bodyLarge = _inter(
    size: 16,
    weight: FontWeight.w500,
    letterSpacing: -0.02,
    height: 1.4,
  );

  /// Body Medium (14sp)
  static final TextStyle bodyMedium = _inter(
    size: 14,
    weight: FontWeight.w500,
    letterSpacing: -0.02,
    height: 1.4,
  );

  /// Body Small (12sp)
  static final TextStyle bodySmall = _inter(
    size: 12,
    weight: FontWeight.w500,
    letterSpacing: -0.01,
    height: 1.38,
  );

  // ==================== LABEL STYLES ====================

  /// Label Large (14sp)
  static final TextStyle labelLarge = _inter(
    size: 14,
    weight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.35,
  );

  /// Label Medium (12sp)
  static final TextStyle labelMedium = _inter(
    size: 12,
    weight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.35,
  );

  /// Label Small (11sp)
  static final TextStyle labelSmall = _inter(
    size: 11,
    weight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.34,
  );

  // ==================== TEXT THEME BUILDER ====================

  /// Base Material 3 `TextTheme`, built from the provided `ColorScheme`.
  static TextTheme textTheme(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: colorScheme.onSurface),
      displayMedium: displayMedium.copyWith(color: colorScheme.onSurface),
      displaySmall: displaySmall.copyWith(color: colorScheme.onSurface),
      headlineLarge: headlineLarge.copyWith(color: colorScheme.onSurface),
      headlineMedium: headlineMedium.copyWith(color: colorScheme.onSurface),
      headlineSmall: headlineSmall.copyWith(color: colorScheme.onSurface),
      titleLarge: titleLarge.copyWith(color: colorScheme.onSurface),
      titleMedium: titleMedium.copyWith(color: colorScheme.onSurface),
      titleSmall: titleSmall.copyWith(color: colorScheme.onSurface),
      bodyLarge: bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: bodyMedium.copyWith(color: colorScheme.onSurface),
      bodySmall: bodySmall.copyWith(color: colorScheme.onSurface),
      labelLarge: labelLarge.copyWith(color: colorScheme.onSurface),
      labelMedium: labelMedium.copyWith(color: colorScheme.onSurface),
      labelSmall: labelSmall.copyWith(color: colorScheme.onSurface),
    );
  }
}
