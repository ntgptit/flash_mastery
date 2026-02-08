/// Custom exceptions for the application.
///
/// These are thrown at the data layer and caught to be converted to Failures.
library;

/// Exception thrown when there's a server error
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception thrown when there's a cache error
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Cache error occurred',
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there's a network error
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Network error occurred',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when authentication fails
class AuthenticationException implements Exception {
  final String message;
  final String? errorCode;

  const AuthenticationException({
    this.message = 'Authentication failed',
    this.errorCode,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception thrown when authorization fails
class AuthorizationException implements Exception {
  final String message;
  final String? errorCode;

  const AuthorizationException({
    this.message = 'Authorization failed',
    this.errorCode,
  });

  @override
  String toString() => 'AuthorizationException: $message';
}

/// Exception thrown when validation fails
class ValidationException implements Exception {
  final String message;
  final String? errorCode;
  final Map<String, dynamic>? errors;

  const ValidationException({
    this.message = 'Validation failed',
    this.errorCode,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message ${errors ?? ""}';
}

/// Exception thrown when a timeout occurs
class TimeoutException implements Exception {
  final String message;

  const TimeoutException({
    this.message = 'Request timeout',
  });

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception thrown when data format is invalid
class FormatException implements Exception {
  final String message;

  const FormatException({
    this.message = 'Invalid data format',
  });

  @override
  String toString() => 'FormatException: $message';
}

/// Exception thrown when a resource is not found
class NotFoundException implements Exception {
  final String message;
  final String? errorCode;

  const NotFoundException({
    this.message = 'Resource not found',
    this.errorCode,
  });

  @override
  String toString() => 'NotFoundException: $message';
}
