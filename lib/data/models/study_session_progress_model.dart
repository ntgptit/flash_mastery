import 'package:flash_mastery/domain/entities/study_mode.dart';
import 'package:flash_mastery/domain/entities/study_session.dart';

class StudySessionProgressModel {
  final String id;
  final String flashcardId;
  final Map<StudyMode, bool> modeCompletion;
  final int correctAnswers;
  final int totalAttempts;
  final DateTime? lastStudiedAt;

  const StudySessionProgressModel({
    required this.id,
    required this.flashcardId,
    required this.modeCompletion,
    this.correctAnswers = 0,
    this.totalAttempts = 0,
    this.lastStudiedAt,
  });

  factory StudySessionProgressModel.fromJson(Map<String, dynamic> json) {
    final modeMap = <StudyMode, bool>{};
    final rawModes = json['modeCompletion'] as Map<String, dynamic>?;
    rawModes?.forEach((key, value) {
      modeMap[_studyModeFromJson(key)] = value as bool;
    });

    return StudySessionProgressModel(
      id: json['id'] as String,
      flashcardId: json['flashcardId'] as String,
      modeCompletion: modeMap,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      totalAttempts: json['totalAttempts'] as int? ?? 0,
      lastStudiedAt: json['lastStudiedAt'] != null
          ? DateTime.tryParse(json['lastStudiedAt'] as String)
          : null,
    );
  }

  StudyProgress toEntity() {
    return StudyProgress(
      flashcardId: flashcardId,
      modeCompletion: modeCompletion,
      correctAnswers: correctAnswers,
      totalAttempts: totalAttempts,
      lastStudiedAt: lastStudiedAt,
    );
  }

  factory StudySessionProgressModel.fromEntity(StudyProgress progress) {
    return StudySessionProgressModel(
      id: progress.flashcardId,
      flashcardId: progress.flashcardId,
      modeCompletion: progress.modeCompletion,
      correctAnswers: progress.correctAnswers,
      totalAttempts: progress.totalAttempts,
      lastStudiedAt: progress.lastStudiedAt,
    );
  }
}

StudyMode _studyModeFromJson(String json) {
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
