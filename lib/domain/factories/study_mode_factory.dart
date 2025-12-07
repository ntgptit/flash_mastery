import 'package:flash_mastery/domain/entities/study_mode.dart';
import 'package:flash_mastery/domain/strategies/study_strategies.dart';

/// Factory for creating study mode handlers.
class StudyModeFactory {
  /// Create a study mode handler based on the mode type.
  static StudyModeHandler createHandler(StudyMode mode) {
    switch (mode) {
      case StudyMode.overview:
        return OverviewStudyHandler();
      case StudyMode.matching:
        return MatchingStudyHandler();
      case StudyMode.guess:
        return GuessStudyHandler();
      case StudyMode.recall:
        return RecallStudyHandler();
      case StudyMode.fillInBlank:
        return FillInBlankStudyHandler();
    }
  }
}

