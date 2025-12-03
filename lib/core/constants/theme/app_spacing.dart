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

  /// Large-plus spacing (between large and extra large).
  static const double lgPlus = 20.0;

  /// Extra large spacing (page padding, big section separators).
  static const double xl = 24.0;

  /// Double extra large spacing (rare cases: hero sections, large gaps).
  static const double xxl = 32.0;

  /// Triple extra large spacing (wide gutters, larger layout padding).
  static const double xxxl = 40.0;

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

  /// Tiny border radius (e.g. drag handles).
  static const double radiusTiny = 2.0;

  /// Small border radius
  static const double radiusSmall = 4.0;

  /// Medium border radius
  static const double radiusMedium = 8.0;

  /// Large border radius
  static const double radiusLarge = 12.0;

  /// Extra large border radius
  static const double radiusExtraLarge = 16.0;

  /// Jumbo border radius (e.g. sheets).
  static const double radiusJumbo = 20.0;

  /// Circular border radius
  static const double radiusCircular = 999.0;

  // ==================== COMMON SIZES ====================

  /// Icon size extra small
  static const double iconExtraSmall = 14.0;

  /// Icon size small
  static const double iconSmall = 16.0;

  /// Icon size small-medium
  static const double iconSmallMedium = 20.0;

  /// Icon size medium
  static const double iconMedium = 24.0;

  /// Icon size large
  static const double iconLarge = 32.0;

  /// Icon size extra large
  static const double iconExtraLarge = 48.0;

  /// Icon size huge
  static const double iconHuge = 64.0;

  /// Icon size hero (e.g. empty/error states)
  static const double iconHero = 72.0;

  /// Compact loader size (e.g. inside buttons)
  static const double loaderSizeSmall = 20.0;

  /// Default loader size
  static const double loaderSizeDefault = 50.0;

  /// Thin stroke width (e.g. borders, spinners)
  static const double strokeWidthThin = 2.0;

  /// Regular stroke width (e.g. larger spinners)
  static const double strokeWidthRegular = 3.0;

  /// Feature/media section height
  static const double featureMediaHeight = 150.0;

  /// Illustration height/width (large placeholders)
  static const double illustrationSizeLarge = 200.0;

  /// Button height
  static const double buttonHeight = 48.0;

  /// Input field height
  static const double inputHeight = 56.0;

  /// App bar height
  static const double appBarHeight = 56.0;

  /// Bottom app bar height
  static const double bottomAppBarHeight = 60.0;

  /// Bottom navigation bar height
  static const double bottomNavHeight = 56.0;

  /// Sliver app bar expanded height
  static const double sliverExpandedHeight = 200.0;

  /// Sliver app bar expanded height (large variant)
  static const double sliverExpandedHeightLarge = 250.0;

  /// Bottom sheet drag handle width
  static const double dragHandleWidth = 40.0;

  /// Bottom sheet drag handle height
  static const double dragHandleHeight = 4.0;

  // ==================== BORDER WIDTHS ====================

  /// Hairline border width
  static const double borderWidthThin = 1.0;

  /// Medium border width
  static const double borderWidthMedium = 2.0;

  // ==================== ELEVATION ====================

  /// No elevation
  static const double elevationNone = 0.0;

  /// Low elevation level
  static const double elevationLow = 2.0;
}
