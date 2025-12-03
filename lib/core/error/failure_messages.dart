import 'package:flash_mastery/core/exceptions/failures.dart';

/// Provides user-friendly messages for [Failure] types in one place.
extension FailureMessages on Failure {
  String toDisplayMessage() {
    if (this is ValidationFailure) return message.isNotEmpty ? message : 'Invalid data provided.';
    if (this is NotFoundFailure) return message.isNotEmpty ? message : 'Item not found.';
    if (this is NetworkFailure) return message.isNotEmpty ? message : 'Network error. Please try again.';
    if (this is CacheFailure) return message.isNotEmpty ? message : 'Storage error. Please try again.';
    if (this is ServerFailure) return message.isNotEmpty ? message : 'Server error. Please try again later.';
    return message.isNotEmpty ? message : 'Something went wrong. Please try again.';
  }
}
