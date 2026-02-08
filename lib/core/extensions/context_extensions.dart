import 'package:flash_mastery/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Extension methods for BuildContext
extension ContextExtensions on BuildContext {
  // ==================== LOCALIZATION ====================

  /// Get AppLocalizations instance
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // ==================== THEME ACCESS ====================

  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Get current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Check if current theme is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if current theme is light mode
  bool get isLightMode => theme.brightness == Brightness.light;

  // ==================== MEDIA QUERY ====================

  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get screen pixel ratio
  double get pixelRatio => mediaQuery.devicePixelRatio;

  /// Get status bar height
  double get statusBarHeight => mediaQuery.padding.top;

  /// Get bottom padding (safe area)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Get keyboard height
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Check if device is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Get screen orientation
  Orientation get orientation => mediaQuery.orientation;

  // ==================== RESPONSIVE BREAKPOINTS ====================

  /// Check if screen is mobile (<600dp)
  bool get isMobile => screenWidth < 600;

  /// Check if screen is tablet (600dp - 1024dp)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Check if screen is desktop (>=1024dp)
  bool get isDesktop => screenWidth >= 1024;

  /// Check if screen is small mobile (<360dp)
  bool get isSmallMobile => screenWidth < 360;

  /// Check if screen is large mobile (>=600dp)
  bool get isLargeMobile => screenWidth >= 600;

  // ==================== NAVIGATION ====================

  /// Get navigator
  NavigatorState get navigator => Navigator.of(this);

  /// Push new route
  Future<T?> push<T>(Widget page) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push replacement route
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push and remove until
  Future<T?> pushAndRemoveUntil<T>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  /// Pop current route
  void pop<T>([T? result]) {
    navigator.pop(result);
  }

  /// Pop until first route
  void popUntilFirst() {
    navigator.popUntil((route) => route.isFirst);
  }

  /// Check if can pop
  bool get canPop => navigator.canPop();

  // ==================== DIALOGS & SNACKBARS ====================

  /// Show snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }

  /// Show dialog
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }

  /// Show bottom sheet
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (_) => child,
    );
  }

  // ==================== FOCUS ====================

  /// Unfocus current focus node (hide keyboard)
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }

  // ==================== LOCALE ====================

  /// Get current locale
  Locale get locale => Localizations.localeOf(this);

  /// Get language code
  String get languageCode => locale.languageCode;

  // ==================== SCAFFOLD ====================

  /// Show loading indicator
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Hide loading indicator
  void hideLoadingDialog() {
    if (canPop) pop();
  }
}
