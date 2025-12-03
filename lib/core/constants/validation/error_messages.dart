/// Centralized error messages.
///
/// Contains all error and validation messages used throughout the app.
/// Organized by category for easy maintenance.
class ErrorMessages {
  ErrorMessages._();

  // ==================== NETWORK ERRORS ====================

  /// No internet connection error.
  static const String noInternetConnection =
      'No internet connection. Please check your network settings.';

  /// Request timeout error.
  static const String requestTimeout =
      'Request timed out. Please try again.';

  /// Server error message.
  static const String serverError =
      'Something went wrong on our end. Please try again later.';

  /// Service unavailable error.
  static const String serviceUnavailable =
      'Service temporarily unavailable. Please try again later.';

  /// Connection failed error.
  static const String connectionFailed =
      'Failed to connect to server. Please check your connection.';

  /// Network error generic message.
  static const String networkError =
      'Network error occurred. Please try again.';

  // ==================== AUTHENTICATION ERRORS ====================

  /// Invalid credentials error.
  static const String invalidCredentials =
      'Invalid email or password. Please try again.';

  /// Account not found error.
  static const String accountNotFound =
      'Account not found. Please register first.';

  /// Account disabled error.
  static const String accountDisabled =
      'Your account has been disabled. Please contact support.';

  /// Email already exists error.
  static const String emailAlreadyExists =
      'This email is already registered. Please login or use another email.';

  /// Username already taken error.
  static const String usernameTaken =
      'Username is already taken. Please choose another one.';

  /// Session expired error.
  static const String sessionExpired =
      'Your session has expired. Please login again.';

  /// Unauthorized access error.
  static const String unauthorized =
      'You are not authorized to access this resource.';

  /// Token invalid error.
  static const String tokenInvalid =
      'Authentication token is invalid. Please login again.';

  /// Password reset required error.
  static const String passwordResetRequired =
      'Password reset required. Please check your email.';

  // ==================== VALIDATION ERRORS ====================

  /// Empty field error.
  static const String fieldRequired = 'This field is required.';

  /// Invalid email format.
  static const String invalidEmail = 'Please enter a valid email address.';

  /// Password too short.
  static const String passwordTooShort =
      'Password must be at least 8 characters long.';

  /// Password too weak.
  static const String passwordTooWeak =
      'Password must contain uppercase, lowercase, and numbers.';

  /// Passwords don\'t match.
  static const String passwordsDoNotMatch = 'Passwords do not match.';

  /// Invalid username format.
  static const String invalidUsername =
      'Username can only contain letters, numbers, and underscores.';

  /// Username too short.
  static const String usernameTooShort =
      'Username must be at least 3 characters long.';

  /// Invalid phone number.
  static const String invalidPhoneNumber = 'Please enter a valid phone number.';

  /// Invalid URL format.
  static const String invalidUrl = 'Please enter a valid URL.';

  /// Text too long.
  static String textTooLong(int maxLength) =>
      'Text cannot exceed $maxLength characters.';

  /// Text too short.
  static String textTooShort(int minLength) =>
      'Text must be at least $minLength characters long.';

  /// Invalid format generic.
  static const String invalidFormat = 'Invalid format. Please check your input.';

  /// Invalid date format.
  static const String invalidDate = 'Please enter a valid date.';

  /// Invalid time format.
  static const String invalidTime = 'Please enter a valid time.';

  // ==================== DATA ERRORS ====================

  /// Data not found error.
  static const String dataNotFound = 'Requested data not found.';

  /// Failed to load data.
  static const String failedToLoadData =
      'Failed to load data. Please try again.';

  /// Failed to save data.
  static const String failedToSaveData =
      'Failed to save data. Please try again.';

  /// Failed to update data.
  static const String failedToUpdateData =
      'Failed to update data. Please try again.';

  /// Failed to delete data.
  static const String failedToDeleteData =
      'Failed to delete data. Please try again.';

  /// Data already exists.
  static const String dataAlreadyExists =
      'This data already exists. Please use a different value.';

  /// Invalid data format.
  static const String invalidDataFormat =
      'Invalid data format. Please check your input.';

  // ==================== FILE ERRORS ====================

  /// File too large error.
  static String fileTooLarge(String maxSize) =>
      'File size exceeds $maxSize limit.';

  /// Invalid file type.
  static const String invalidFileType =
      'Invalid file type. Please select a valid file.';

  /// File upload failed.
  static const String fileUploadFailed =
      'Failed to upload file. Please try again.';

  /// File download failed.
  static const String fileDownloadFailed =
      'Failed to download file. Please try again.';

  /// File not found.
  static const String fileNotFound = 'File not found.';

  // ==================== PERMISSION ERRORS ====================

  /// Permission denied.
  static const String permissionDenied =
      'Permission denied. Please grant the required permissions.';

  /// Camera permission denied.
  static const String cameraPermissionDenied =
      'Camera permission is required to take photos.';

  /// Storage permission denied.
  static const String storagePermissionDenied =
      'Storage permission is required to save files.';

  /// Location permission denied.
  static const String locationPermissionDenied =
      'Location permission is required for this feature.';

  // ==================== FLASHCARD SPECIFIC ERRORS ====================

  /// Deck not found.
  static const String deckNotFound = 'Deck not found.';

  /// Flashcard not found.
  static const String flashcardNotFound = 'Flashcard not found.';

  /// Question cannot be empty.
  static const String questionRequired = 'Question cannot be empty.';

  /// Answer cannot be empty.
  static const String answerRequired = 'Answer cannot be empty.';

  /// Deck name required.
  static const String deckNameRequired = 'Deck name is required.';

  /// Maximum cards reached.
  static String maxCardsReached(int maxCards) =>
      'Maximum number of cards ($maxCards) reached for this deck.';

  /// No cards available.
  static const String noCardsAvailable =
      'No cards available for study. Please add some flashcards first.';

  /// Study session in progress.
  static const String studySessionInProgress =
      'A study session is already in progress.';

  // ==================== GENERIC ERRORS ====================

  /// Unknown error.
  static const String unknownError =
      'An unknown error occurred. Please try again.';

  /// Operation failed.
  static const String operationFailed =
      'Operation failed. Please try again.';

  /// Something went wrong.
  static const String somethingWentWrong =
      'Something went wrong. Please try again later.';

  /// Feature not available.
  static const String featureNotAvailable =
      'This feature is not available yet.';

  /// Maintenance mode.
  static const String maintenanceMode =
      'The app is under maintenance. Please try again later.';

  /// Update required.
  static const String updateRequired =
      'A new version is available. Please update the app to continue.';

  // ==================== RATE LIMIT ERRORS ====================

  /// Too many requests.
  static const String tooManyRequests =
      'Too many requests. Please wait a moment and try again.';

  /// Rate limit exceeded.
  static String rateLimitExceeded(int seconds) =>
      'Rate limit exceeded. Please try again in $seconds seconds.';

  // ==================== PAYMENT ERRORS ====================

  /// Payment failed.
  static const String paymentFailed =
      'Payment failed. Please check your payment method.';

  /// Invalid payment method.
  static const String invalidPaymentMethod =
      'Invalid payment method. Please select another one.';

  /// Insufficient funds.
  static const String insufficientFunds =
      'Insufficient funds. Please check your account balance.';

  // ==================== BIOMETRIC ERRORS ====================

  /// Biometric not available.
  static const String biometricNotAvailable =
      'Biometric authentication is not available on this device.';

  /// Biometric not enrolled.
  static const String biometricNotEnrolled =
      'No biometric credentials are enrolled. Please set up biometric authentication in your device settings.';

  /// Biometric authentication failed.
  static const String biometricAuthFailed =
      'Biometric authentication failed. Please try again.';
}
