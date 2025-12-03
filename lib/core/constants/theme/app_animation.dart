/// Common animation constants used across the app.
class AppAnimation {
  AppAnimation._();

  /// Duration for the dots loading animation.
  static const Duration loadingDotsDuration = Duration(milliseconds: 1200);

  /// Minimum normalized progress for animations.
  static const double loadingProgressMin = 0.0;

  /// Maximum normalized progress for animations.
  static const double loadingProgressMax = 1.0;

  /// Delay between dot animations (in normalized progress).
  static const double loadingDotsDelayInterval = 0.2;

  /// Half cycle marker for looping dot animations.
  static const double loadingDotsHalfCycle = 0.5;

  /// Minimum scale for animated dots.
  static const double loadingDotsBaseScale = 0.5;

  /// Scale range applied to animated dots.
  static const double loadingDotsScaleRange = 0.5;

  /// Height factor (size / factor) for the dots row.
  static const double loadingDotsHeightFactor = 3.0;

  /// Size factor (size / factor) for each dot.
  static const double loadingDotsCircleFactor = 6.0;

  /// Multiplier for linear loading indicator width relative to size.
  static const double linearLoadingWidthFactor = 2.0;

  /// Number of dots in the animated indicator.
  static const int loadingDotsCount = 3;
}
