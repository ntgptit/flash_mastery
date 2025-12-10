import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/usecases/study_sessions/study_session_usecases.dart';

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
    int? currentBatchIndex,
    List<StudyProgressUpdate>? progressUpdates,
  });
}

