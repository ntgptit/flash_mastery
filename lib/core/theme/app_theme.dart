import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  // ==================== LIGHT THEME ====================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      fontFamily: AppTypography.primaryFontFamily,
      fontFamilyFallback: AppTypography.fontFallback,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: _lightAppBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      textTheme: _lightTextTheme,
      iconTheme: _lightIconTheme,
      floatingActionButtonTheme: _fabTheme,
      chipTheme: _chipTheme,
      dividerTheme: _dividerTheme,
      bottomNavigationBarTheme: _lightBottomNavTheme,
      navigationBarTheme: _lightNavigationBarTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  // ==================== DARK THEME ====================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      fontFamily: AppTypography.primaryFontFamily,
      fontFamilyFallback: AppTypography.fontFallback,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: _darkAppBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      textTheme: _darkTextTheme,
      iconTheme: _darkIconTheme,
      floatingActionButtonTheme: _fabTheme,
      chipTheme: _chipTheme,
      dividerTheme: _dividerTheme,
      bottomNavigationBarTheme: _darkBottomNavTheme,
      navigationBarTheme: _darkNavigationBarTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  // ==================== COLOR SCHEMES ====================

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onPrimary,
    secondaryContainer: AppColors.secondaryLight,
    onSecondaryContainer: AppColors.primaryDark,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    outline: AppColors.border,
    surfaceContainerHighest: AppColors.surfaceVariant,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryDarkMode,
    onPrimary: AppColors.onPrimaryDarkMode,
    primaryContainer: AppColors.primaryContainerDark,
    onPrimaryContainer: AppColors.onPrimaryContainerDark,
    secondary: AppColors.secondaryDarkMode,
    onSecondary: AppColors.onSecondaryDarkMode,
    secondaryContainer: AppColors.secondaryContainerDark,
    onSecondaryContainer: AppColors.onSecondaryContainerDark,
    tertiary: AppColors.tertiaryDarkMode,
    onTertiary: AppColors.onTertiaryDarkMode,
    error: AppColors.errorDark,
    onError: AppColors.onErrorDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.white,
    outline: AppColors.outlineDark,
    surfaceContainerHighest: AppColors.surfaceVariantDark,
  );

  // ==================== APP BAR THEMES ====================

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.textPrimary,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02,
      height: 1.35,
    ),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.white,
    iconTheme: IconThemeData(color: AppColors.white),
    titleTextStyle: TextStyle(
      color: AppColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02,
      height: 1.35,
    ),
  );

  // ==================== CARD THEME ====================

  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    ),
    margin: const EdgeInsets.all(AppSpacing.small),
  );

  // ==================== BUTTON THEMES ====================

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  // ==================== INPUT DECORATION THEMES ====================

  static final InputDecorationTheme _lightInputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.medium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      );

  static final InputDecorationTheme _darkInputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey800,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.medium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      );

  // ==================== TEXT THEME ====================

  static TextTheme get _lightTextTheme =>
      AppTypography.textTheme(_lightColorScheme);

  static TextTheme get _darkTextTheme =>
      AppTypography.textTheme(_darkColorScheme);

  // ==================== ICON THEMES ====================

  static const IconThemeData _lightIconTheme = IconThemeData(
    color: AppColors.textPrimary,
    size: 24,
  );

  static const IconThemeData _darkIconTheme = IconThemeData(
    color: AppColors.white,
    size: 24,
  );

  // ==================== FAB THEME ====================

  static final FloatingActionButtonThemeData _fabTheme =
      FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        ),
      );

  // ==================== CHIP THEME ====================

  static final ChipThemeData _chipTheme = ChipThemeData(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.small,
      vertical: AppSpacing.extraSmall,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
    ),
  );

  // ==================== DIVIDER THEME ====================

  static const DividerThemeData _dividerTheme = DividerThemeData(
    thickness: 1,
    space: 1,
    color: AppColors.divider,
  );

  // ==================== BOTTOM NAVIGATION BAR THEMES ====================

  static const BottomNavigationBarThemeData _lightBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static const BottomNavigationBarThemeData _darkBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  // ==================== NAVIGATION BAR THEMES ====================

  static final NavigationBarThemeData _lightNavigationBarTheme =
      NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primaryLight,
        elevation: 3,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );

  static final NavigationBarThemeData _darkNavigationBarTheme =
      NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primaryDark,
        elevation: 3,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      );

  // ==================== DIALOG THEME ====================

  static final DialogThemeData _dialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
    ),
    elevation: 8,
  );

  // ==================== SNACKBAR THEME ====================

  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
    ),
  );
}
