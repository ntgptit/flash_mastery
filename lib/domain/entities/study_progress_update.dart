import 'package:flash_mastery/domain/entities/study_mode.dart';

class StudyProgressUpdate {
  final String flashcardId;
  final List<StudyMode> completedModes;
  final int? correctAnswers;
  final int? totalAttempts;

  const StudyProgressUpdate({
    required this.flashcardId,
    this.completedModes = const [],
    this.correctAnswers,
    this.totalAttempts,
  });
}
