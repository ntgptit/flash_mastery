/// Core module barrel file.
///
/// Import this file to access all core functionality:
/// ```dart
/// import 'package:flash_mastery/core/core.dart';
/// ```
library;

// ==================== CONSTANTS ====================
export 'constants/constants.dart';
export 'error/error_handler.dart';
// ==================== ERROR HANDLING ====================
export 'exceptions/exceptions.dart';
export 'exceptions/failures.dart';
export 'extensions/context_extensions.dart';
export 'extensions/date_time_extensions.dart';
export 'extensions/num_extensions.dart';
// ==================== EXTENSIONS ====================
export 'extensions/string_extensions.dart';
// ==================== NETWORK ====================
export 'network/dio_client.dart';
// ==================== PROVIDERS ====================
export 'providers/core_providers.dart';
// ==================== ROUTER ====================
export 'router/app_router.dart';
// ==================== THEME ====================
export 'theme/app_theme.dart';
// ==================== USE CASES ====================
export 'usecases/usecase.dart';
export 'utils/formatters.dart';
// ==================== UTILS ====================
export 'utils/validators.dart';
