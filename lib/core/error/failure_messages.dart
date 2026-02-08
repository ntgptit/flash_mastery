import 'package:flash_mastery/core/exceptions/failures.dart';

/// Provides user-friendly messages for [Failure] types.
///
/// Backend already returns i18n-safe messages, so we use `failure.message`
/// directly. Fallbacks are only for offline/network errors where there's
/// no backend message.
extension FailureMessages on Failure {
  String toDisplayMessage() {
    if (message.isNotEmpty) return message;

    // Fallbacks for cases without backend message
    if (this is NetworkFailure) return 'Network error. Please try again.';
    if (this is TimeoutFailure) return 'Request timeout. Please try again.';
    if (this is CacheFailure) return 'Storage error. Please try again.';
    if (this is ServerFailure) return 'Server error. Please try again later.';
    if (this is ValidationFailure) return 'Invalid data provided.';
    if (this is NotFoundFailure) return 'Item not found.';
    if (this is AuthenticationFailure) return 'Authentication failed.';
    if (this is AuthorizationFailure) return 'Access denied.';
    return 'Something went wrong. Please try again.';
  }
}
