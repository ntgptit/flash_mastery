/// Barrel file for all constants.
///
/// Import this file to access all constants in the app:
/// ```dart
/// import 'package:flash_mastery/core/constants/constants.dart';
/// ```
///
/// This file re-exports all constants organized by category:
/// - Theme: Colors, Typography, Spacing
/// - Config: App Constants, API Constants
/// - Validation: Error Messages, Regex Patterns
/// - Storage: Storage Keys and Configuration
library;

// ==================== THEME CONSTANTS ====================
export 'theme/app_colors.dart';
export 'theme/app_typography.dart';
export 'theme/app_spacing.dart';

// ==================== CONFIG CONSTANTS ====================
export 'config/app_constants.dart';
export 'config/api_constants.dart';

// ==================== VALIDATION CONSTANTS ====================
export 'validation/error_messages.dart';
export 'validation/regex_constants.dart';

// ==================== STORAGE CONSTANTS ====================
export 'storage/storage_constants.dart';
