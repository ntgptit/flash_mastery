/// Centralized spacing system for the app.
///
/// Use these values for paddings, margins, gaps between widgets, etc.
/// This helps keep layout consistent across the whole application.
class AppSpacing {
  AppSpacing._(); // private constructor to prevent instantiation

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
}
