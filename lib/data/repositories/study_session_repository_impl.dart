import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/remote/study_session_remote_data_source.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/repositories/study_session_repository.dart';

class StudySessionRepositoryImpl implements StudySessionRepository {
  final StudySessionRemoteDataSource remoteDataSource;

  StudySessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StudySession>> startSession({
    required String deckId,
    List<String>? flashcardIds,
  }) async {
    return ErrorGuard.run(() async {
      final session = await remoteDataSource.startSession(deckId, flashcardIds: flashcardIds);
      return session.toEntity();
    });
  }

  @override
  Future<Either<Failure, StudySession>> getSession(String sessionId) async {
    return ErrorGuard.run(() async {
      final session = await remoteDataSource.getSession(sessionId);
      return session.toEntity();
    });
  }

  @override
  Future<Either<Failure, StudySession>> updateSession({
    required String sessionId,
    String? currentMode,
    int? currentBatchIndex,
    Map<String, String>? progressData,
  }) async {
    return ErrorGuard.run(() async {
      final session = await remoteDataSource.updateSession(
        sessionId,
        currentMode: currentMode,
        currentBatchIndex: currentBatchIndex,
        progressData: progressData,
      );
      return session.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> completeSession(String sessionId) async {
    return ErrorGuard.run(() async {
      await remoteDataSource.completeSession(sessionId);
      return;
    });
  }

  @override
  Future<Either<Failure, void>> cancelSession(String sessionId) async {
    return ErrorGuard.run(() async {
      await remoteDataSource.cancelSession(sessionId);
      return;
    });
  }
}

