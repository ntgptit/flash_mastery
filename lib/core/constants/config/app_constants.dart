/// General application constants.
///
/// Contains app-wide configuration values, limits, and feature flags.
class AppConstants {
  AppConstants._();

  // ==================== APP INFORMATION ====================

  /// Application name.
  static const String appName = 'Flash Mastery';

  /// Application version.
  static const String appVersion = '1.0.0';

  /// Application build number.
  static const String buildNumber = '1';

  /// Application package name (Android).
  static const String packageName = 'com.example.flashmastery';

  /// Application bundle ID (iOS).
  static const String bundleId = 'com.example.flashmastery';

  // ==================== ENVIRONMENT ====================

  /// Current environment (dev, staging, production).
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Is development mode.
  static bool get isDevelopment => environment == 'development';

  /// Is staging mode.
  static bool get isStaging => environment == 'staging';

  /// Is production mode.
  static bool get isProduction => environment == 'production';

  // ==================== FEATURE FLAGS ====================

  /// Enable debug logging.
  static const bool enableDebugLogging = true;

  /// Enable crash reporting.
  static const bool enableCrashReporting = false;

  /// Enable analytics.
  static const bool enableAnalytics = false;

  /// Enable push notifications.
  static const bool enablePushNotifications = true;

  /// Enable dark mode.
  static const bool enableDarkMode = true;

  /// Enable biometric authentication.
  static const bool enableBiometricAuth = true;

  // ==================== LIMITS & CONSTRAINTS ====================

  /// Maximum username length.
  static const int maxUsernameLength = 50;

  /// Minimum username length.
  static const int minUsernameLength = 3;

  /// Maximum password length.
  static const int maxPasswordLength = 128;

  /// Minimum password length.
  static const int minPasswordLength = 8;

  /// Maximum email length.
  static const int maxEmailLength = 255;

  /// Maximum flashcard question length.
  static const int maxQuestionLength = 500;

  /// Maximum flashcard answer length.
  static const int maxAnswerLength = 1000;

  /// Maximum deck name length.
  static const int maxDeckNameLength = 100;

  /// Maximum deck description length.
  static const int maxDeckDescriptionLength = 500;

  /// Maximum folder name length.
  static const int maxFolderNameLength = 100;

  /// Maximum folder description length.
  static const int maxFolderDescriptionLength = 500;

  /// Maximum number of flashcards per deck.
  static const int maxFlashcardsPerDeck = 1000;

  /// Minimum folder name length.
  static const int minFolderNameLength = 2;

  /// Minimum deck name length.
  static const int minDeckNameLength = 2;

  /// Minimum study cards per session.
  static const int minStudyCardsPerSession = 5;

  /// Maximum study cards per session.
  static const int maxStudyCardsPerSession = 100;

  /// Default study cards per session.
  static const int defaultStudyCardsPerSession = 20;

  // ==================== INPUT DEFAULTS ====================

  /// Default OTP length.
  static const int otpLength = 6;

  /// Default minimum lines for multiline text fields.
  static const int defaultMultilineMinLines = 3;

  /// Default maximum lines for multiline text fields.
  static const int defaultMultilineMaxLines = 5;

  /// Default maximum lines for single-line text fields.
  static const int singleLineMaxLines = 1;

  // ==================== UI DEFAULTS ====================

  /// Maximum lines for confirmation dialogs to avoid overflow.
  static const int confirmationDialogMaxLines = 3;

  /// Default cross axis count for grid-based cards (folders/decks).
  static const int defaultGridCrossAxisCount = 2;

  /// Default aspect ratio for grid-based cards.
  static const double folderGridAspectRatio = 1.2;

  // ==================== TIMING CONSTANTS ====================

  /// Splash screen duration in milliseconds.
  static const int splashScreenDuration = 2000;

  /// Debounce duration for search in milliseconds.
  static const int searchDebounceDuration = 500;

  /// Auto-save interval in milliseconds.
  static const int autoSaveInterval = 30000;

  /// Session timeout in minutes.
  static const int sessionTimeout = 30;

  /// OTP expiry time in minutes.
  static const int otpExpiryTime = 5;

  /// Token refresh threshold in minutes (refresh 5 mins before expiry).
  static const int tokenRefreshThreshold = 5;

  // ==================== PAGINATION ====================

  /// Items per page for lists.
  static const int itemsPerPage = 20;

  /// Initial page number.
  static const int initialPage = 1;

  // ==================== ANIMATION DURATIONS ====================

  /// Default animation duration in milliseconds.
  static const int defaultAnimationDuration = 300;

  /// Fast animation duration in milliseconds.
  static const int fastAnimationDuration = 150;

  /// Slow animation duration in milliseconds.
  static const int slowAnimationDuration = 600;

  // ==================== SHEET DEFAULTS ====================

  /// Initial child size for draggable bottom sheets.
  static const double draggableSheetInitialChildSize = 0.5;

  /// Minimum child size for draggable bottom sheets.
  static const double draggableSheetMinChildSize = 0.25;

  /// Maximum child size for draggable bottom sheets.
  static const double draggableSheetMaxChildSize = 0.95;

  // ==================== FILE UPLOAD ====================

  /// Maximum file size in bytes (10 MB).
  static const int maxFileSize = 10 * 1024 * 1024;

  /// Allowed image extensions.
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];

  /// Allowed document extensions.
  static const List<String> allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];

  // ==================== STUDY MODES ====================

  /// Study mode: Standard review.
  static const String studyModeStandard = 'standard';

  /// Study mode: Quick review.
  static const String studyModeQuick = 'quick';

  /// Study mode: Comprehensive review.
  static const String studyModeComprehensive = 'comprehensive';

  // ==================== DIFFICULTY LEVELS ====================

  /// Difficulty: Easy.
  static const String difficultyEasy = 'easy';

  /// Difficulty: Medium.
  static const String difficultyMedium = 'medium';

  /// Difficulty: Hard.
  static const String difficultyHard = 'hard';

  // ==================== CARD RATINGS ====================

  /// Rating: Again (forgot).
  static const int ratingAgain = 1;

  /// Rating: Hard (remembered with difficulty).
  static const int ratingHard = 2;

  /// Rating: Good (remembered).
  static const int ratingGood = 3;

  /// Rating: Easy (remembered easily).
  static const int ratingEasy = 4;

  // ==================== URLS ====================

  /// Privacy policy URL.
  static const String privacyPolicyUrl = 'https://example.com/privacy';

  /// Terms of service URL.
  static const String termsOfServiceUrl = 'https://example.com/terms';

  /// Support email.
  static const String supportEmail = 'support@example.com';

  /// Website URL.
  static const String websiteUrl = 'https://example.com';

  // ==================== DATE FORMATS ====================

  /// Standard date format (YYYY-MM-DD).
  static const String standardDateFormat = 'yyyy-MM-dd';

  /// Display date format (DD/MM/YYYY).
  static const String displayDateFormat = 'dd/MM/yyyy';

  /// Date time format (DD/MM/YYYY HH:mm).
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  /// Time format (HH:mm:ss).
  static const String timeFormat = 'HH:mm:ss';
}
