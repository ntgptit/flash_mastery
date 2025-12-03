import 'package:dio/dio.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/network/interceptors/auth_interceptor.dart';
import 'package:flash_mastery/core/network/interceptors/cache_interceptor.dart';
import 'package:flash_mastery/core/network/interceptors/connectivity_interceptor.dart';
import 'package:flash_mastery/core/network/interceptors/error_interceptor.dart';
import 'package:flash_mastery/core/network/interceptors/logging_interceptor.dart';
import 'package:flash_mastery/core/network/interceptors/retry_interceptor.dart';
import 'package:flutter/foundation.dart';

/// Dio client configuration for API calls
class DioClient {
  late final Dio _dio;
  late final CacheInterceptor _cacheInterceptor;

  Dio get dio => _dio;
  CacheInterceptor get cache => _cacheInterceptor;

  DioClient({
    bool enableCache = true,
    bool enableRetry = true,
    bool enableConnectivityCheck = true,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(seconds: ApiConstants.receiveTimeout),
        sendTimeout: Duration(seconds: ApiConstants.sendTimeout),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Initialize cache interceptor
    _cacheInterceptor = CacheInterceptor(
      defaultCacheDuration: const Duration(minutes: 5),
      maxCacheSize: 100,
    );

    // Add interceptors in order:
    // 1. Connectivity check (before request)
    // 2. Cache (before request, after response)
    // 3. Auth (before request)
    // 4. Logging (all phases) - debug only
    // 5. Error transformation (on error)
    // 6. Retry (on error)
    _dio.interceptors.addAll([
      if (enableConnectivityCheck) ConnectivityInterceptor(),
      if (enableCache) _cacheInterceptor,
      AuthInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
      ErrorInterceptor(),
      if (enableRetry) RetryInterceptor(maxRetries: 3),
    ]);
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
