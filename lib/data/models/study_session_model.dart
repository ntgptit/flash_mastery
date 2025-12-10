import 'package:flash_mastery/data/models/study_progress_model.dart';
import 'package:flash_mastery/domain/entities/study_mode.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/entities/study_session_status.dart';

class StudySessionModel {
  final String id;
  final String deckId;
  final List<String> flashcardIds;
  final StudyMode currentMode;
  final int currentBatchIndex;
  final DateTime startedAt;
  final StudySessionStatus status;
  final List<StudyProgressModel>? progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudySessionModel({
    required this.id,
    required this.deckId,
    required this.flashcardIds,
    required this.currentMode,
    this.currentBatchIndex = 0,
    required this.startedAt,
    this.status = StudySessionStatus.inProgress,
    this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    return StudySessionModel(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      flashcardIds: (json['flashcardIds'] as List).cast<String>(),
      currentMode: studyModeFromJson(json['currentMode'] as String),
      currentBatchIndex: json['currentBatchIndex'] as int? ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      status: json['status'] != null
          ? studySessionStatusFromJson(json['status'] as String)
          : StudySessionStatus.inProgress,
      progress: json['progress'] != null
          ? (json['progress'] as List)
              .map((e) => StudyProgressModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  StudySession toEntity() {
    // Convert List<StudyProgressModel> to Map<String, StudyProgress>
    final progressMap = <String, StudyProgress>{};

    if (progress != null) {
      for (final progressModel in progress!) {
        final flashcardId = progressModel.flashcardId;
        final existing = progressMap[flashcardId];

        if (existing != null) {
          // Merge mode completion for same flashcard - recreate with copyWith
          final updatedModeCompletion = Map<StudyMode, bool>.from(existing.modeCompletion)
            ..[progressModel.mode] = progressModel.completed ?? false;

          progressMap[flashcardId] = existing.copyWith(
            modeCompletion: updatedModeCompletion,
            correctAnswers: existing.correctAnswers + (progressModel.correctAnswers ?? 0),
            totalAttempts: existing.totalAttempts + (progressModel.totalAttempts ?? 0),
            lastStudiedAt: progressModel.lastStudiedAt ?? existing.lastStudiedAt,
          );
        } else {
          // Create new progress entry
          progressMap[flashcardId] = StudyProgress(
            flashcardId: flashcardId,
            modeCompletion: {progressModel.mode: progressModel.completed ?? false},
            correctAnswers: progressModel.correctAnswers ?? 0,
            totalAttempts: progressModel.totalAttempts ?? 0,
            lastStudiedAt: progressModel.lastStudiedAt,
          );
        }
      }
    }

    return StudySession(
      id: id,
      deckId: deckId,
      flashcardIds: flashcardIds,
      currentMode: currentMode,
      currentBatchIndex: currentBatchIndex,
      startedAt: startedAt,
      status: status,
      progress: progressMap,
    );
  }

  factory StudySessionModel.fromEntity(StudySession session) {
    // Convert progress Map<String, StudyProgress> to List<StudyProgressModel>
    final progressList = <StudyProgressModel>[];

    for (final entry in session.progress.entries) {
      final flashcardId = entry.key;
      final studyProgress = entry.value;

      // Create one StudyProgressModel per mode
      for (final modeEntry in studyProgress.modeCompletion.entries) {
        progressList.add(StudyProgressModel(
          flashcardId: flashcardId,
          mode: modeEntry.key,
          completed: modeEntry.value,
          correctAnswers: studyProgress.correctAnswers,
          totalAttempts: studyProgress.totalAttempts,
          lastStudiedAt: studyProgress.lastStudiedAt,
        ));
      }
    }

    return StudySessionModel(
      id: session.id,
      deckId: session.deckId,
      flashcardIds: session.flashcardIds,
      currentMode: session.currentMode,
      currentBatchIndex: session.currentBatchIndex,
      startedAt: session.startedAt,
      status: session.status,
      progress: progressList.isNotEmpty ? progressList : null,
      createdAt: DateTime.now(), // These should come from backend
      updatedAt: DateTime.now(),
    );
  }
}

StudyMode studyModeFromJson(String json) {
  switch (json.toUpperCase()) {
    case 'OVERVIEW':
      return StudyMode.overview;
    case 'MATCHING':
      return StudyMode.matching;
    case 'GUESS':
      return StudyMode.guess;
    case 'RECALL':
      return StudyMode.recall;
    case 'FILL_IN_BLANK':
      return StudyMode.fillInBlank;
    default:
      return StudyMode.overview;
  }
}

String studyModeToJson(StudyMode mode) {
  switch (mode) {
    case StudyMode.overview:
      return 'OVERVIEW';
    case StudyMode.matching:
      return 'MATCHING';
    case StudyMode.guess:
      return 'GUESS';
    case StudyMode.recall:
      return 'RECALL';
    case StudyMode.fillInBlank:
      return 'FILL_IN_BLANK';
  }
}
