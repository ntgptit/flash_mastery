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
  final Map<String, String> progressData;
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
    this.progressData = const {},
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
      progressData: json['progressData'] != null
          ? Map<String, String>.from(json['progressData'] as Map)
          : {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  StudySession toEntity() {
    // Convert progressData from Map<String, String> to Map<String, StudyProgress>
    final progress = <String, StudyProgress>{};
    for (final entry in progressData.entries) {
      // Parse progress string (format: "MODE:true,MODE:false")
      final modes = <StudyMode, bool>{};
      final parts = entry.value.split(',');
      for (final part in parts) {
        final modeParts = part.split(':');
        if (modeParts.length == 2) {
          final mode = studyModeFromJson(modeParts[0]);
          final completed = modeParts[1] == 'true';
          modes[mode] = completed;
        }
      }
      progress[entry.key] = StudyProgress(flashcardId: entry.key, modeCompletion: modes);
    }

    return StudySession(
      id: id,
      deckId: deckId,
      flashcardIds: flashcardIds,
      currentMode: currentMode,
      currentBatchIndex: currentBatchIndex,
      startedAt: startedAt,
      status: status,
      progress: progress,
    );
  }

  factory StudySessionModel.fromEntity(StudySession session) {
    // Convert progress Map<String, StudyProgress> to Map<String, String>
    final progressData = <String, String>{};
    for (final entry in session.progress.entries) {
      final parts = entry.value.modeCompletion.entries
          .map((e) => '${studyModeToJson(e.key)}:${e.value}')
          .join(',');
      progressData[entry.key] = parts;
    }

    return StudySessionModel(
      id: session.id,
      deckId: session.deckId,
      flashcardIds: session.flashcardIds,
      currentMode: session.currentMode,
      currentBatchIndex: session.currentBatchIndex,
      startedAt: session.startedAt,
      status: session.status,
      progressData: progressData,
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
