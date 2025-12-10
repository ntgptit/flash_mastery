import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/study_mode.dart';

part 'study_progress_model.g.dart';

/// Model for study progress data from API.
/// Represents progress for a single flashcard in a specific study mode.
@JsonSerializable()
class StudyProgressModel {
  @JsonKey(name: 'flashcardId')
  final String flashcardId;

  @JsonKey(name: 'mode')
  final StudyMode mode;

  @JsonKey(name: 'completed')
  final bool? completed;

  @JsonKey(name: 'completedAt')
  final DateTime? completedAt;

  @JsonKey(name: 'correctAnswers')
  final int? correctAnswers;

  @JsonKey(name: 'totalAttempts')
  final int? totalAttempts;

  @JsonKey(name: 'lastStudiedAt')
  final DateTime? lastStudiedAt;

  /// Read-only accuracy field from backend
  @JsonKey(name: 'accuracy')
  final double? accuracy;

  const StudyProgressModel({
    required this.flashcardId,
    required this.mode,
    this.completed,
    this.completedAt,
    this.correctAnswers,
    this.totalAttempts,
    this.lastStudiedAt,
    this.accuracy,
  });

  factory StudyProgressModel.fromJson(Map<String, dynamic> json) =>
      _$StudyProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudyProgressModelToJson(this);

  StudyProgressModel copyWith({
    String? flashcardId,
    StudyMode? mode,
    bool? completed,
    DateTime? completedAt,
    int? correctAnswers,
    int? totalAttempts,
    DateTime? lastStudiedAt,
    double? accuracy,
  }) {
    return StudyProgressModel(
      flashcardId: flashcardId ?? this.flashcardId,
      mode: mode ?? this.mode,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}
