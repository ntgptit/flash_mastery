import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/error/error_guard.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/data/datasources/remote/study_session_remote_data_source.dart';
import 'package:flash_mastery/data/models/study_progress_model.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/repositories/study_session_repository.dart';
import 'package:flash_mastery/domain/usecases/study_sessions/study_session_usecases.dart';

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
    List<StudyProgressUpdate>? progressUpdates,
  }) async {
    return ErrorGuard.run(() async {
      // Convert domain DTOs to data models
      List<StudyProgressModel>? progressModels;
      if (progressUpdates != null) {
        progressModels = progressUpdates.map((update) {
          return StudyProgressModel(
            flashcardId: update.flashcardId,
            mode: update.mode,
            completed: update.completed,
            completedAt: update.completedAt,
            correctAnswers: update.correctAnswers,
            totalAttempts: update.totalAttempts,
            lastStudiedAt: update.lastStudiedAt,
          );
        }).toList();
      }

      final session = await remoteDataSource.updateSession(
        sessionId,
        currentMode: currentMode,
        currentBatchIndex: currentBatchIndex,
        progressUpdates: progressModels,
      );
      return session.toEntity();
    });
  }

}

