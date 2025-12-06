import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/error/failure_mapper.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flutter/foundation.dart';

/// Helper to centralize error-to-failure mapping.
class ErrorGuard {
  const ErrorGuard._();

  /// Run async work and map any thrown exception to [Failure].
  static Future<Either<Failure, T>> run<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } catch (error, stack) {
      debugPrint('ErrorGuard caught: $error');
      debugPrintStack(stackTrace: stack);
      return Left(FailureMapper.fromException(error));
    }
  }
}
