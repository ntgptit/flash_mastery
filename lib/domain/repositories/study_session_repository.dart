import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/study_progress_update.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';

/// Repository interface for study session operations.
abstract class StudySessionRepository {
  /// Start a new study session.
  Future<Either<Failure, StudySession>> startSession({
    required String deckId,
    List<String>? flashcardIds,
  });

  /// Get a study session by id.
  Future<Either<Failure, StudySession>> getSession(String sessionId);

  /// Update a study session.
  Future<Either<Failure, StudySession>> updateSession({
    required String sessionId,
    String? currentMode,
    String? nextMode,
    int? currentBatchIndex,
    List<StudyProgressUpdate>? progressUpdates,
  });

  /// Complete a study session.
  Future<Either<Failure, void>> completeSession(String sessionId);

  /// Cancel a study session.
  Future<Either<Failure, void>> cancelSession(String sessionId);
}
