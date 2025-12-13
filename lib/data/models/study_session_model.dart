import 'package:flash_mastery/data/models/study_session_progress_model.dart';
import 'package:flash_mastery/domain/entities/study_mode.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';
import 'package:flash_mastery/domain/entities/study_session_status.dart';

class StudySessionModel {
  final String id;
  final String deckId;
  final List<String> flashcardIds;
  final StudyMode currentMode;
  final StudyMode? nextMode;
  final int currentBatchIndex;
  final DateTime startedAt;
  final DateTime? completedAt;
  final StudySessionStatus status;
  final List<StudySessionProgressModel> progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudySessionModel({
    required this.id,
    required this.deckId,
    required this.flashcardIds,
    required this.currentMode,
    this.nextMode,
    this.currentBatchIndex = 0,
    required this.startedAt,
    this.completedAt,
    this.status = StudySessionStatus.inProgress,
    this.progress = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudySessionModel.fromJson(Map<String, dynamic> json) {
    return StudySessionModel(
      id: json['id'] as String,
      deckId: json['deckId'] as String,
      flashcardIds: (json['flashcardIds'] as List).cast<String>(),
      currentMode: studyModeFromJson(json['currentMode'] as String),
      nextMode: json['nextMode'] != null
          ? studyModeFromJson(json['nextMode'] as String)
          : null,
      currentBatchIndex: json['currentBatchIndex'] as int? ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      status: json['status'] != null
          ? studySessionStatusFromJson(json['status'] as String)
          : StudySessionStatus.inProgress,
      progress: (json['progress'] as List<dynamic>? ?? [])
          .map(
            (e) => StudySessionProgressModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  StudySession toEntity() {
    final progressMap = <String, StudyProgress>{};
    for (final record in progress) {
      progressMap[record.flashcardId] = record.toEntity();
    }

    return StudySession(
      id: id,
      deckId: deckId,
      flashcardIds: flashcardIds,
      currentMode: currentMode,
      nextMode: nextMode,
      currentBatchIndex: currentBatchIndex,
      startedAt: startedAt,
      completedAt: completedAt,
      status: status,
      progress: progressMap,
    );
  }

  factory StudySessionModel.fromEntity(StudySession session) {
    final progressData = session.progress.values
        .map(StudySessionProgressModel.fromEntity)
        .toList();

    return StudySessionModel(
      id: session.id,
      deckId: session.deckId,
      flashcardIds: session.flashcardIds,
      currentMode: session.currentMode,
      nextMode: session.nextMode,
      currentBatchIndex: session.currentBatchIndex,
      startedAt: session.startedAt,
      completedAt: session.completedAt,
      status: session.status,
      progress: progressData,
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
