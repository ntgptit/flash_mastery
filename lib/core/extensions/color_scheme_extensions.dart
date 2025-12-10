import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flutter/material.dart';

/// Extension to add success and dangerous colors to ColorScheme
extension ColorSchemeExtensions on ColorScheme {
  /// Success color for success states
  Color get success => brightness == Brightness.light
      ? AppColors.success
      : AppColors.successDark;

  /// On success color
  Color get onSuccess => brightness == Brightness.light
      ? AppColors.white
      : AppColors.onSuccessDark;

  /// Success container color
  Color get successContainer => brightness == Brightness.light
      ? AppColors.success.withAlpha(26)
      : AppColors.successContainerDark;

  /// On success container color
  Color get onSuccessContainer => brightness == Brightness.light
      ? AppColors.success
      : AppColors.onSuccessContainerDark;

  /// Dangerous color for dangerous states
  Color get dangerous => brightness == Brightness.light
      ? AppColors.dangerous
      : AppColors.dangerousDark;

  /// On dangerous color
  Color get onDangerous => brightness == Brightness.light
      ? AppColors.white
      : AppColors.onDangerousDark;

  /// Dangerous container color
  Color get dangerousContainer => brightness == Brightness.light
      ? AppColors.dangerous.withAlpha(26)
      : AppColors.dangerousContainerDark;

  /// On dangerous container color
  Color get onDangerousContainer => brightness == Brightness.light
      ? AppColors.dangerous
      : AppColors.onDangerousContainerDark;
}
