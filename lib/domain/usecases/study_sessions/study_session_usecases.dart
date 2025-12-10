import 'package:dartz/dartz.dart';
import 'package:flash_mastery/core/exceptions/failures.dart';
import 'package:flash_mastery/core/usecases/usecase.dart';
import 'package:flash_mastery/domain/entities/study_mode.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/repositories/study_session_repository.dart';

class StartStudySessionUseCase extends UseCase<StudySession, StartStudySessionParams> {
  final StudySessionRepository repository;

  StartStudySessionUseCase(this.repository);

  @override
  Future<Either<Failure, StudySession>> call(StartStudySessionParams params) {
    return repository.startSession(
      deckId: params.deckId,
      flashcardIds: params.flashcardIds,
    );
  }
}

class GetStudySessionUseCase extends UseCase<StudySession, String> {
  final StudySessionRepository repository;

  GetStudySessionUseCase(this.repository);

  @override
  Future<Either<Failure, StudySession>> call(String sessionId) {
    return repository.getSession(sessionId);
  }
}

class UpdateStudySessionUseCase extends UseCase<StudySession, UpdateStudySessionParams> {
  final StudySessionRepository repository;

  UpdateStudySessionUseCase(this.repository);

  @override
  Future<Either<Failure, StudySession>> call(UpdateStudySessionParams params) {
    return repository.updateSession(
      sessionId: params.sessionId,
      currentMode: params.currentMode,
      currentBatchIndex: params.currentBatchIndex,
      progressUpdates: params.progressUpdates,
    );
  }
}


class StartStudySessionParams {
  final String deckId;
  final List<String>? flashcardIds;

  const StartStudySessionParams({
    required this.deckId,
    this.flashcardIds,
  });
}

class UpdateStudySessionParams {
  final String sessionId;
  final String? currentMode;
  final int? currentBatchIndex;
  final List<StudyProgressUpdate>? progressUpdates;

  const UpdateStudySessionParams({
    required this.sessionId,
    this.currentMode,
    this.currentBatchIndex,
    this.progressUpdates,
  });
}

/// DTO for study progress update sent to backend
class StudyProgressUpdate {
  final String flashcardId;
  final StudyMode mode;
  final bool? completed;
  final DateTime? completedAt;
  final int? correctAnswers;
  final int? totalAttempts;
  final DateTime? lastStudiedAt;

  const StudyProgressUpdate({
    required this.flashcardId,
    required this.mode,
    this.completed,
    this.completedAt,
    this.correctAnswers,
    this.totalAttempts,
    this.lastStudiedAt,
  });
}

