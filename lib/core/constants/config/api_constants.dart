/// API configuration and endpoint constants.
///
/// Contains base URLs, timeout values, and all API endpoints
/// used throughout the application.
class ApiConstants {
  ApiConstants._();

  // ==================== BASE CONFIGURATION ====================

  /// Base URL for the API server.
  static const String baseUrl = 'http://192.168.35.146:8080/api/v1';

  // ==================== TIMEOUT VALUES ====================

  /// Connection timeout in seconds.
  static const int connectionTimeout = 30;

  /// Receive timeout in seconds.
  static const int receiveTimeout = 30;

  /// Send timeout in seconds.
  static const int sendTimeout = 30;

  // ==================== HTTP HEADERS ====================

  /// Content-Type header key.
  static const String contentType = 'Content-Type';

  /// Authorization header key.
  static const String authorization = 'Authorization';

  /// Accept header key.
  static const String accept = 'Accept';

  /// Application JSON value.
  static const String applicationJson = 'application/json';

  /// Bearer token prefix.
  static const String bearer = 'Bearer';

  // ==================== AUTH ENDPOINTS ====================

  /// User login endpoint.
  static const String login = '/auth/login';

  /// User registration endpoint.
  static const String register = '/auth/register';

  /// User logout endpoint.
  static const String logout = '/auth/logout';

  /// Refresh token endpoint.
  static const String refreshToken = '/auth/refresh';

  /// Forgot password endpoint.
  static const String forgotPassword = '/auth/forgot-password';

  /// Reset password endpoint.
  static const String resetPassword = '/auth/reset-password';

  /// Verify OTP endpoint.
  static const String verifyOtp = '/auth/verify-otp';

  // ==================== USER ENDPOINTS ====================

  /// Get user profile endpoint.
  static const String userProfile = '/user/profile';

  /// Update user profile endpoint.
  static const String updateProfile = '/user/profile';

  /// Change password endpoint.
  static const String changePassword = '/user/change-password';

  /// Delete account endpoint.
  static const String deleteAccount = '/user/delete';

  // ==================== FLASHCARD ENDPOINTS ====================

  /// Get all flashcards endpoint.
  static String deckFlashcards(String deckId) => '/decks/$deckId/cards';

  /// Get flashcard by ID endpoint.
  static String flashcardById(String id) => '/cards/$id';

  /// Create flashcard endpoint.
  static String createFlashcard(String deckId) => '/decks/$deckId/cards';

  /// Update flashcard endpoint.
  static String updateFlashcard(String id) => '/cards/$id';

  /// Delete flashcard endpoint.
  static String deleteFlashcard(String id) => '/cards/$id';

  // ==================== DECK ENDPOINTS ====================

  /// Get all decks endpoint.
  static const String decks = '/decks';

  /// Get deck by ID endpoint.
  static String deckById(String id) => '/decks/$id';

  /// Create deck endpoint.
  static const String createDeck = '/decks';

  /// Update deck endpoint.
  static String updateDeck(String id) => '/decks/$id';

  /// Delete deck endpoint.
  static String deleteDeck(String id) => '/decks/$id';

  /// Import decks into a folder.
  static String importDecks(String folderId) => '/decks/import/$folderId';

  // ==================== FOLDER ENDPOINTS ====================

  /// Get all folders endpoint.
  static const String folders = '/folders';

  /// Get folder by ID endpoint.
  static String folderById(String id) => '/folders/$id';

  /// Create folder endpoint.
  static const String createFolder = '/folders';

  /// Update folder endpoint.
  static String updateFolder(String id) => '/folders/$id';

  /// Delete folder endpoint.
  static String deleteFolder(String id) => '/folders/$id';

  // ==================== STUDY SESSION ENDPOINTS ====================

  /// Start study session endpoint.
  static const String startSession = '/sessions/start';

  /// Get study session by ID endpoint.
  static String sessionById(String id) => '/sessions/$id';

  /// Update study session endpoint.
  static String updateSession(String id) => '/sessions/$id';

  /// Complete study session endpoint.
  static String completeSession(String id) => '/sessions/$id/complete';

  /// Get session history endpoint.
  static const String sessionHistory = '/sessions/history';

  /// Get session statistics endpoint.
  static const String sessionStats = '/sessions/stats';

  // ==================== PAGINATION PARAMS ====================

  /// Default page number.
  static const int defaultPage = 1;

  /// Default page size.
  static const int defaultPageSize = 20;

  /// Maximum page size.
  static const int maxPageSize = 100;

  // ==================== RETRY CONFIGURATION ====================

  /// Maximum retry attempts for failed requests.
  static const int maxRetryAttempts = 3;

  /// Delay between retry attempts in milliseconds.
  static const int retryDelay = 1000;
}
