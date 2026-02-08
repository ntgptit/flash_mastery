import 'package:dio/dio.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/core/network/api_error_parser.dart';

/// Handles conversion of exceptions to failures
class ErrorHandler {
  /// Converts an exception to a failure
  static Failure handleException(dynamic error) {
    if (error is ServerException) {
      return ServerFailure(message: error.message, code: error.statusCode, errorCode: error.errorCode);
    } else if (error is CacheException) {
      return CacheFailure(message: error.message);
    } else if (error is NetworkException) {
      return NetworkFailure(message: error.message);
    } else if (error is AuthenticationException) {
      return AuthenticationFailure(message: error.message, errorCode: error.errorCode);
    } else if (error is AuthorizationException) {
      return AuthorizationFailure(message: error.message, errorCode: error.errorCode);
    } else if (error is ValidationException) {
      return ValidationFailure(message: error.message, errorCode: error.errorCode, errors: error.errors);
    } else if (error is TimeoutException) {
      return TimeoutFailure(message: error.message);
    } else if (error is FormatException) {
      return FormatFailure(message: error.message);
    } else if (error is NotFoundException) {
      return NotFoundFailure(message: error.message, errorCode: error.errorCode);
    } else if (error is DioException) {
      return _handleDioException(error);
    } else {
      return UnexpectedFailure(message: error.toString());
    }
  }

  /// Handles Dio specific exceptions
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'Request timeout. Please try again.',
          code: error.response?.statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'No internet connection. Please check your network.',
          code: error.response?.statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return const UnexpectedFailure(message: 'Request cancelled');

      case DioExceptionType.badCertificate:
        return const NetworkFailure(message: 'Certificate verification failed');

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkFailure(message: 'No internet connection');
        }
        return UnexpectedFailure(message: error.message ?? 'An unexpected error occurred');
    }
  }

  /// Handles HTTP response errors based on status code
  static Failure _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = ApiErrorParser.extractMessage(data);
    final errorCode = ApiErrorParser.extractCode(data);

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: message ?? 'Invalid request',
          code: statusCode,
          errorCode: errorCode,
        );

      case 401:
        return AuthenticationFailure(
          message: message ?? 'Authentication failed',
          code: statusCode,
          errorCode: errorCode,
        );

      case 403:
        return AuthorizationFailure(
          message: message ?? 'Access denied',
          code: statusCode,
          errorCode: errorCode,
        );

      case 404:
        return NotFoundFailure(
          message: message ?? 'Resource not found',
          code: statusCode,
          errorCode: errorCode,
        );

      case 408:
        return TimeoutFailure(message: message ?? 'Request timeout', code: statusCode);

      case 422:
        return ValidationFailure(
          message: message ?? 'Validation failed',
          code: statusCode,
          errorCode: errorCode,
          errors: ApiErrorParser.extractFieldErrors(data),
        );

      case 429:
        return ServerFailure(
          message: message ?? 'Too many requests. Please try again later.',
          code: statusCode,
          errorCode: errorCode,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: message ?? 'Server error. Please try again later.',
          code: statusCode,
          errorCode: errorCode,
        );

      default:
        return ServerFailure(
          message: message ?? 'An error occurred',
          code: statusCode,
          errorCode: errorCode,
        );
    }
  }
}
