import 'package:dartz/dartz.dart';
import '../exceptions/failures.dart';

/// Base class for all use cases.
///
/// A use case represents a single business operation.
/// It takes input parameters of type [Params] and returns a [Future]
/// that resolves to an [Either] containing either a [Failure] or [Type].
///
/// Example:
/// ```dart
/// class GetUserProfile extends UseCase<UserEntity, GetUserParams> {
///   final UserRepository repository;
///
///   GetUserProfile(this.repository);
///
///   @override
///   Future<Either<Failure, UserEntity>> call(GetUserParams params) {
///     return repository.getUserProfile(params.userId);
///   }
/// }
/// ```
abstract class UseCase<T, Params> {
  /// Executes the use case with the given [params].
  Future<Either<Failure, T>> call(Params params);
}

/// Special class representing no parameters needed for a use case.
///
/// Use this when a use case doesn't require any input parameters.
///
/// Example:
/// ```dart
/// class GetCurrentUser extends UseCase<UserEntity, NoParams> {
///   @override
///   Future<Either<Failure, UserEntity>> call(NoParams params) {
///     return repository.getCurrentUser();
///   }
/// }
///
/// // Usage:
/// final result = await getCurrentUser(NoParams());
/// ```
class NoParams {
  const NoParams();
}

/// Base class for stream-based use cases.
///
/// Similar to [UseCase], but returns a [Stream] instead of a [Future].
/// Useful for real-time data or long-running operations.
///
/// Example:
/// ```dart
/// class WatchUserProfile extends StreamUseCase<UserEntity, String> {
///   final UserRepository repository;
///
///   WatchUserProfile(this.repository);
///
///   @override
///   Stream<Either<Failure, UserEntity>> call(String userId) {
///     return repository.watchUserProfile(userId);
///   }
/// }
/// ```
abstract class StreamUseCase<T, Params> {
  /// Executes the stream use case with the given [params].
  Stream<Either<Failure, T>> call(Params params);
}
