import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Failures are used in the domain layer to represent errors.
/// They are returned as part of `Either<Failure, Success>` pattern.
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final String? errorCode;

  const Failure({
    required this.message,
    this.code,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, code, errorCode];
}

/// Failure when there's a server error
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code,
    super.errorCode,
  });
}

/// Failure when there's a cache error
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred',
    super.code,
    super.errorCode,
  });
}

/// Failure when there's a network error
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network connection failed',
    super.code,
    super.errorCode,
  });
}

/// Failure when authentication fails
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Authentication failed',
    super.code,
    super.errorCode,
  });
}

/// Failure when authorization fails
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'You are not authorized to perform this action',
    super.code,
    super.errorCode,
  });
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    super.message = 'Validation failed',
    super.code,
    super.errorCode,
    this.errors,
  });

  @override
  List<Object?> get props => [message, code, errorCode, errors];
}

/// Failure when a timeout occurs
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timeout',
    super.code,
    super.errorCode,
  });
}

/// Failure when data format is invalid
class FormatFailure extends Failure {
  const FormatFailure({
    super.message = 'Invalid data format',
    super.code,
    super.errorCode,
  });
}

/// Failure when a resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.code,
    super.errorCode,
  });
}

/// Failure for unexpected errors
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.errorCode,
  });
}
