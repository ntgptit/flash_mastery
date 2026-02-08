import 'package:dio/dio.dart';

import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';

/// Maps low-level exceptions into domain [Failure] types.
class FailureMapper {
  const FailureMapper._();

  /// Convert any exception/error into a [Failure].
  static Failure fromException(Object error) {
    if (error is Failure) return error;
    if (error is ValidationException) {
      return ValidationFailure(message: error.message, errorCode: error.errorCode, errors: error.errors);
    }
    if (error is NotFoundException) {
      return NotFoundFailure(message: error.message, errorCode: error.errorCode);
    }
    if (error is CacheException) {
      return CacheFailure(message: error.message);
    }
    if (error is ServerException) {
      return ServerFailure(message: error.message, code: error.statusCode, errorCode: error.errorCode);
    }
    if (error is AuthenticationException) {
      return AuthenticationFailure(message: error.message, errorCode: error.errorCode);
    }
    if (error is AuthorizationException) {
      return AuthorizationFailure(message: error.message, errorCode: error.errorCode);
    }
    if (error is NetworkException) {
      return NetworkFailure(message: error.message);
    }
    if (error is TimeoutException) {
      return TimeoutFailure(message: error.message);
    }
    if (error is DioException) {
      return ServerFailure(message: error.message ?? 'Network error');
    }

    return ServerFailure(message: error.toString());
  }
}
