import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flash_mastery/core/exceptions/exceptions.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to check network connectivity before making requests
class ConnectivityInterceptor extends Interceptor {
  final List<String> testHosts;
  final Duration timeout;

  ConnectivityInterceptor({
    this.testHosts = const ['google.com', '8.8.8.8'],
    this.timeout = const Duration(seconds: 3),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip connectivity check if disabled for this request
    final skipCheck = options.extra['skip_connectivity_check'] as bool? ?? false;
    if (skipCheck) {
      return handler.next(options);
    }

    // Check if we have internet connectivity
    final hasConnection = await _checkConnectivity();

    if (!hasConnection) {
      debugPrint('ConnectivityInterceptor: No internet connection for ${options.uri}');
      return handler.reject(
        DioException(
          requestOptions: options,
          error: NetworkException(message: 'No internet connection. Please check your network.'),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    handler.next(options);
  }

  /// Check if device has internet connectivity
  Future<bool> _checkConnectivity() async {
    try {
      // Try to lookup multiple hosts for reliability
      for (final host in testHosts) {
        try {
          final result = await InternetAddress.lookup(host).timeout(timeout);

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Try next host
          continue;
        }
      }

      return false;
    } catch (e) {
      debugPrint('ConnectivityInterceptor: Error checking connectivity: $e');
      // If we can't check, assume we have connection
      // to avoid blocking requests unnecessarily
      return true;
    }
  }

  /// Check connectivity without timeout (for manual checks)
  static Future<bool> checkConnection({
    List<String> hosts = const ['google.com', '8.8.8.8'],
  }) async {
    try {
      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(host);
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          continue;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
