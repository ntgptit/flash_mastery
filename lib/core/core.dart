/// Core module barrel file.
///
/// Import this file to access all core functionality:
/// ```dart
/// import 'package:flash_mastery/core/core.dart';
/// ```
library;

// ==================== CONSTANTS ====================
export 'constants/constants.dart';

// ==================== ERROR HANDLING ====================
export 'exceptions/exceptions.dart';
export 'exceptions/failures.dart';
export 'error/error_handler.dart';

// ==================== NETWORK ====================
export 'network/dio_client.dart';

// ==================== USE CASES ====================
export 'usecases/usecase.dart';

// ==================== UTILS ====================
export 'utils/validators.dart';
export 'utils/formatters.dart';

// ==================== EXTENSIONS ====================
export 'extensions/string_extensions.dart';
export 'extensions/context_extensions.dart';
export 'extensions/date_time_extensions.dart';
export 'extensions/num_extensions.dart';

// ==================== THEME ====================
export 'theme/app_theme.dart';

// ==================== ROUTER ====================
export 'router/app_router.dart';

// ==================== PROVIDERS ====================
export 'providers/core_providers.dart';
