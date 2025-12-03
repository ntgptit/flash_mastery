/// Local storage keys constants.
///
/// Contains keys used for storing data in SharedPreferences,
/// Flutter Secure Storage, and Hive boxes.
class StorageConstants {
  StorageConstants._();

  // ==================== SHARED PREFERENCES KEYS ====================

  /// Key for storing user authentication token.
  static const String authToken = 'auth_token';

  /// Key for storing refresh token.
  static const String refreshToken = 'refresh_token';

  /// Key for storing user ID.
  static const String userId = 'user_id';

  /// Key for storing user email.
  static const String userEmail = 'user_email';

  /// Key for storing user name.
  static const String userName = 'user_name';

  /// Key for storing user avatar URL.
  static const String userAvatar = 'user_avatar';

  /// Key for storing user role.
  static const String userRole = 'user_role';

  // ==================== AUTHENTICATION STATE ====================

  /// Key for tracking if user is logged in.
  static const String isLoggedIn = 'is_logged_in';

  /// Key for tracking if user completed onboarding.
  static const String hasCompletedOnboarding = 'has_completed_onboarding';

  /// Key for storing last login timestamp.
  static const String lastLoginTimestamp = 'last_login_timestamp';

  /// Key for tracking biometric authentication preference.
  static const String biometricEnabled = 'biometric_enabled';

  /// Key for tracking remember me preference.
  static const String rememberMe = 'remember_me';

  // ==================== APP SETTINGS ====================

  /// Key for storing app theme mode (light/dark/system).
  static const String themeMode = 'theme_mode';

  /// Key for storing selected language code.
  static const String languageCode = 'language_code';

  /// Key for storing notification enabled state.
  static const String notificationsEnabled = 'notifications_enabled';

  /// Key for storing sound effects enabled state.
  static const String soundEffectsEnabled = 'sound_effects_enabled';

  /// Key for storing vibration enabled state.
  static const String vibrationEnabled = 'vibration_enabled';

  /// Key for storing auto-save preference.
  static const String autoSaveEnabled = 'auto_save_enabled';

  // ==================== STUDY PREFERENCES ====================

  /// Key for storing default study mode.
  static const String defaultStudyMode = 'default_study_mode';

  /// Key for storing cards per session preference.
  static const String cardsPerSession = 'cards_per_session';

  /// Key for storing show answer timer preference.
  static const String showAnswerTimer = 'show_answer_timer';

  /// Key for storing shuffle cards preference.
  static const String shuffleCards = 'shuffle_cards';

  /// Key for storing auto-advance preference.
  static const String autoAdvanceEnabled = 'auto_advance_enabled';

  /// Key for storing show progress preference.
  static const String showProgress = 'show_progress';

  // ==================== STATISTICS & PROGRESS ====================

  /// Key for storing total study time in seconds.
  static const String totalStudyTime = 'total_study_time';

  /// Key for storing total cards studied.
  static const String totalCardsStudied = 'total_cards_studied';

  /// Key for storing total sessions completed.
  static const String totalSessions = 'total_sessions';

  /// Key for storing current streak in days.
  static const String currentStreak = 'current_streak';

  /// Key for storing longest streak in days.
  static const String longestStreak = 'longest_streak';

  /// Key for storing last study date.
  static const String lastStudyDate = 'last_study_date';

  // ==================== CACHE KEYS ====================

  /// Key for storing cached flashcards data.
  static const String cachedFlashcards = 'cached_flashcards';

  /// Key for storing cached decks data.
  static const String cachedDecks = 'cached_decks';

  /// Key for storing cached user profile.
  static const String cachedUserProfile = 'cached_user_profile';

  /// Key for storing cache timestamp.
  static const String cacheTimestamp = 'cache_timestamp';

  /// Cache expiry duration in hours.
  static const int cacheExpiryHours = 24;

  // ==================== SEARCH HISTORY ====================

  /// Key for storing recent search queries.
  static const String searchHistory = 'search_history';

  /// Maximum number of search history items.
  static const int maxSearchHistory = 20;

  // ==================== DRAFT DATA ====================

  /// Key for storing draft flashcard.
  static const String draftFlashcard = 'draft_flashcard';

  /// Key for storing draft deck.
  static const String draftDeck = 'draft_deck';

  // ==================== HIVE BOX NAMES ====================

  /// Hive box name for flashcards.
  static const String flashcardsBox = 'flashcards_box';

  /// Hive box name for decks.
  static const String decksBox = 'decks_box';

  /// Hive box name for study sessions.
  static const String sessionsBox = 'sessions_box';

  /// Hive box name for user settings.
  static const String settingsBox = 'settings_box';

  // ==================== SECURE STORAGE KEYS ====================

  /// Secure key for biometric credentials.
  static const String biometricCredentials = 'biometric_credentials';

  /// Secure key for encryption key.
  static const String encryptionKey = 'encryption_key';

  /// Secure key for device ID.
  static const String deviceId = 'device_id';

  // ==================== FEATURE FLAGS STORAGE ====================

  /// Key for storing enabled features list.
  static const String enabledFeatures = 'enabled_features';

  /// Key for storing feature flags last updated timestamp.
  static const String featureFlagsUpdated = 'feature_flags_updated';

  // ==================== APP STATE ====================

  /// Key for storing app first launch flag.
  static const String isFirstLaunch = 'is_first_launch';

  /// Key for storing app version.
  static const String appVersion = 'app_version';

  /// Key for storing last update check timestamp.
  static const String lastUpdateCheck = 'last_update_check';

  /// Key for storing crash report preference.
  static const String crashReportEnabled = 'crash_report_enabled';

  /// Key for storing analytics preference.
  static const String analyticsEnabled = 'analytics_enabled';
}
