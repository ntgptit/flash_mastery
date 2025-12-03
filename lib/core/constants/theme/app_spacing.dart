/// Centralized spacing system for the app.
///
/// Use these values for paddings, margins, gaps between widgets, etc.
/// This helps keep layout consistent across the whole application.
class AppSpacing {
  AppSpacing._(); // private constructor to prevent instantiation

  // ==================== SPACING VALUES ====================

  /// Extra small spacing (e.g. between tightly related elements).
  static const double xs = 4.0;

  /// Small spacing (e.g. between icons and text).
  static const double sm = 8.0;

  /// Medium spacing (default padding between standard widgets).
  static const double md = 12.0;

  /// Large spacing (section padding, larger gaps between groups).
  static const double lg = 16.0;

  /// Extra large spacing (page padding, big section separators).
  static const double xl = 24.0;

  /// Double extra large spacing (rare cases: hero sections, large gaps).
  static const double xxl = 32.0;

  // ==================== NAMED ALIASES ====================

  /// Extra small spacing (4.0)
  static const double extraSmall = xs;

  /// Small spacing (8.0)
  static const double small = sm;

  /// Medium spacing (12.0)
  static const double medium = md;

  /// Large spacing (16.0)
  static const double large = lg;

  /// Extra large spacing (24.0)
  static const double extraLarge = xl;

  /// Double extra large spacing (32.0)
  static const double doubleExtraLarge = xxl;

  // ==================== BORDER RADIUS ====================

  /// Small border radius
  static const double radiusSmall = 4.0;

  /// Medium border radius
  static const double radiusMedium = 8.0;

  /// Large border radius
  static const double radiusLarge = 12.0;

  /// Extra large border radius
  static const double radiusExtraLarge = 16.0;

  /// Circular border radius
  static const double radiusCircular = 999.0;

  // ==================== COMMON SIZES ====================

  /// Icon size small
  static const double iconSmall = 16.0;

  /// Icon size medium
  static const double iconMedium = 24.0;

  /// Icon size large
  static const double iconLarge = 32.0;

  /// Button height
  static const double buttonHeight = 48.0;

  /// Input field height
  static const double inputHeight = 56.0;

  /// App bar height
  static const double appBarHeight = 56.0;

  /// Bottom navigation bar height
  static const double bottomNavHeight = 56.0;
}
