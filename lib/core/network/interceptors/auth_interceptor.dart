import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to add authentication token to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from secure storage
    // For now, we'll leave this as a placeholder
    // TODO: Implement token retrieval from secure storage
    final token = await _getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - refresh token or logout
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic
      debugPrint('Unauthorized - Token might be expired');
    }

    super.onError(err, handler);
  }

  /// Retrieve authentication token from storage
  Future<String?> _getToken() async {
    // TODO: Implement secure storage for token
    // Example: return await secureStorage.read(key: 'auth_token');
    return null;
  }
}
