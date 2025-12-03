import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses in debug mode
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌─────────────────────────────────────────────────────');
    debugPrint('│ REQUEST: ${options.method} ${options.uri}');
    debugPrint('├─────────────────────────────────────────────────────');
    debugPrint('│ Headers:');
    options.headers.forEach((key, value) {
      debugPrint('│   $key: $value');
    });
    if (options.queryParameters.isNotEmpty) {
      debugPrint('│ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        debugPrint('│   $key: $value');
      });
    }
    if (options.data != null) {
      debugPrint('│ Body: ${options.data}');
    }
    debugPrint('└─────────────────────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌─────────────────────────────────────────────────────');
    debugPrint('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('├─────────────────────────────────────────────────────');
    debugPrint('│ Headers:');
    response.headers.map.forEach((key, value) {
      debugPrint('│   $key: $value');
    });
    debugPrint('│ Body: ${response.data}');
    debugPrint('└─────────────────────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌─────────────────────────────────────────────────────');
    debugPrint('│ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
    debugPrint('├─────────────────────────────────────────────────────');
    debugPrint('│ Type: ${err.type}');
    debugPrint('│ Message: ${err.message}');
    if (err.response != null) {
      debugPrint('│ Status Code: ${err.response?.statusCode}');
      debugPrint('│ Response: ${err.response?.data}');
    }
    debugPrint('└─────────────────────────────────────────────────────');
    super.onError(err, handler);
  }
}
