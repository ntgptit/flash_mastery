import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to automatically retry failed requests
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryableStatusCodes;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableStatusCodes = const [408, 429, 500, 502, 503, 504],
  });

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Don't retry if max retries reached
    final retryCount = err.requestOptions.extra['retry_count'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      debugPrint('Max retries ($maxRetries) reached for ${err.requestOptions.uri}');
      return handler.next(err);
    }

    // Only retry certain types of errors
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    debugPrint('Retrying request (${retryCount + 1}/$maxRetries): ${err.requestOptions.uri}');

    // Wait before retrying with exponential backoff
    final delay = retryDelay * (retryCount + 1);
    await Future.delayed(delay);

    // Increment retry count
    err.requestOptions.extra['retry_count'] = retryCount + 1;

    try {
      // Retry the request
      final response = await Dio().fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Determine if the request should be retried
  bool _shouldRetry(DioException err) {
    // Retry on timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry on connection errors
    if (err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on specific status codes
    if (err.response?.statusCode != null &&
        retryableStatusCodes.contains(err.response!.statusCode)) {
      return true;
    }

    return false;
  }
}
