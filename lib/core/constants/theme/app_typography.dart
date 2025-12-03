import 'package:flutter/material.dart';

/// Defines the global font / text style system for the app using Material 3.
///
/// If you want to use Google Fonts (e.g. Roboto, Inter),
/// add the `google_fonts` package to `pubspec.yaml` and
/// replace the `TextTheme` below with `GoogleFonts.xxxTextTheme()`.
class AppTypography {
  AppTypography._();

  /// Base Material 3 `TextTheme`, built from the provided `ColorScheme`.
  static TextTheme textTheme(ColorScheme colorScheme) {
    // You can fine‑tune each style (titleLarge, bodyMedium, etc.) as needed.
    return Typography.material2021().black.copyWith(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
            color: colorScheme.onSurface,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: colorScheme.onSurface,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: colorScheme.onPrimary,
          ),
        );
  }
}


