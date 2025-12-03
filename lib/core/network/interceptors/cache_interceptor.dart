import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor to cache HTTP responses
class CacheInterceptor extends Interceptor {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultCacheDuration;
  final int maxCacheSize;

  CacheInterceptor({
    this.defaultCacheDuration = const Duration(minutes: 5),
    this.maxCacheSize = 100,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    // Check if caching is disabled for this request
    final disableCache = options.extra['disable_cache'] as bool? ?? false;
    if (disableCache) {
      return handler.next(options);
    }

    final key = _getCacheKey(options);
    final cachedEntry = _cache[key];

    // Check if cache exists and is still valid
    if (cachedEntry != null && !cachedEntry.isExpired) {
      debugPrint('CacheInterceptor: Returning cached response for ${options.uri}');
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedEntry.data,
          statusCode: cachedEntry.statusCode,
          statusMessage: cachedEntry.statusMessage,
          headers: cachedEntry.headers,
          extra: {'from_cache': true},
        ),
      );
    }

    // If cache is expired, remove it
    if (cachedEntry != null && cachedEntry.isExpired) {
      _cache.remove(key);
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Only cache successful GET requests
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final disableCache =
          response.requestOptions.extra['disable_cache'] as bool? ?? false;

      if (!disableCache) {
        final key = _getCacheKey(response.requestOptions);
        final cacheDuration =
            response.requestOptions.extra['cache_duration'] as Duration? ??
                defaultCacheDuration;

        debugPrint('CacheInterceptor: Caching response for ${response.requestOptions.uri}');

        // Check cache size and remove oldest entry if needed
        if (_cache.length >= maxCacheSize) {
          _removeOldestEntry();
        }

        _cache[key] = _CacheEntry(
          data: response.data,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          cachedAt: DateTime.now(),
          duration: cacheDuration,
        );
      }
    }

    handler.next(response);
  }

  /// Generate cache key from request options
  String _getCacheKey(RequestOptions options) {
    final uri = options.uri.toString();
    final queryParams = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '$uri?$queryParams';
  }

  /// Remove the oldest cache entry
  void _removeOldestEntry() {
    if (_cache.isEmpty) return;

    var oldestKey = _cache.keys.first;
    var oldestTime = _cache[oldestKey]!.cachedAt;

    for (final entry in _cache.entries) {
      if (entry.value.cachedAt.isBefore(oldestTime)) {
        oldestKey = entry.key;
        oldestTime = entry.value.cachedAt;
      }
    }

    _cache.remove(oldestKey);
  }

  /// Clear all cached responses
  void clearCache() {
    _cache.clear();
    debugPrint('CacheInterceptor: Cache cleared');
  }

  /// Clear cached responses matching a pattern
  void clearCacheByPattern(String pattern) {
    _cache.removeWhere((key, value) => key.contains(pattern));
    debugPrint('CacheInterceptor: Cache cleared for pattern: $pattern');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'total_entries': _cache.length,
      'max_size': maxCacheSize,
      'default_duration': defaultCacheDuration.inMinutes,
    };
  }
}

/// Cache entry model
class _CacheEntry {
  final dynamic data;
  final int? statusCode;
  final String? statusMessage;
  final Headers headers;
  final DateTime cachedAt;
  final Duration duration;

  _CacheEntry({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
    required this.cachedAt,
    required this.duration,
  });

  bool get isExpired {
    return DateTime.now().difference(cachedAt) > duration;
  }
}
