import 'package:dio/dio.dart';
import 'package:flash_mastery/core/error/failure_mapper.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flash_mastery/core/network/api_error_parser.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to handle and transform errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('ErrorInterceptor: Handling error for ${err.requestOptions.uri}');

    // Transform DioException to custom exceptions
    final exception = _transformError(err);
    final failure = FailureMapper.fromException(exception);

    // Create a new DioException with the custom error
    final transformedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: failure,
      message: failure.message,
    );

    super.onError(transformedError, handler);
  }

  /// Transform DioException to custom exceptions
  Exception _transformError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Request timeout. Please try again.');

      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection. Please check your network.');

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'Certificate verification failed. Connection is not secure.',
        );

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NetworkException(message: 'No internet connection');
        }
        return NetworkException(message: error.message ?? 'An unexpected error occurred');
    }
  }

  /// Handle HTTP response errors based on status code
  Exception _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    final message = ApiErrorParser.extractMessage(data);
    final errorCode = ApiErrorParser.extractCode(data);

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: message ?? 'Invalid request',
          errorCode: errorCode,
          errors: ApiErrorParser.extractFieldErrors(data),
        );

      case 401:
        return AuthenticationException(
          message: message ?? 'Authentication failed. Please login again.',
          errorCode: errorCode,
        );

      case 403:
        return AuthorizationException(
          message: message ?? 'You are not authorized to access this resource.',
          errorCode: errorCode,
        );

      case 404:
        return NotFoundException(
          message: message ?? 'The requested resource was not found.',
          errorCode: errorCode,
        );

      case 408:
        return TimeoutException(message: message ?? 'Request timeout');

      case 422:
        return ValidationException(
          message: message ?? 'Validation failed',
          errorCode: errorCode,
          errors: ApiErrorParser.extractFieldErrors(data),
        );

      case 429:
        return ServerException(
          message: message ?? 'Too many requests. Please try again later.',
          statusCode: statusCode,
          errorCode: errorCode,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode,
          errorCode: errorCode,
        );

      default:
        return ServerException(
          message: message ?? 'An error occurred. Please try again.',
          statusCode: statusCode,
          errorCode: errorCode,
        );
    }
  }
}
