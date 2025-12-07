/// Enum representing different study modes.
enum StudyMode {
  /// Overview mode: Display flashcards for review (term below, meaning above).
  overview,

  /// Matching mode: Match terms with meanings in two columns.
  matching,

  /// Guess mode: Show meaning, guess term from multiple choice.
  guess,

  /// Recall mode: Show term, guess meaning with time limit.
  recall,

  /// Fill in blank mode: Show meaning, type the term.
  fillInBlank,
}

extension StudyModeExtension on StudyMode {
  /// Display name for the study mode.
  String get displayName {
    switch (this) {
      case StudyMode.overview:
        return 'Overview';
      case StudyMode.matching:
        return 'Matching';
      case StudyMode.guess:
        return 'Guess';
      case StudyMode.recall:
        return 'Recall';
      case StudyMode.fillInBlank:
        return 'Fill in Blank';
    }
  }

  /// Description of the study mode.
  String get description {
    switch (this) {
      case StudyMode.overview:
        return 'Review flashcards with term and meaning displayed';
      case StudyMode.matching:
        return 'Match terms with their meanings';
      case StudyMode.guess:
        return 'Guess the term from multiple choice options';
      case StudyMode.recall:
        return 'Recall the meaning with a time limit';
      case StudyMode.fillInBlank:
        return 'Type the term for the given meaning';
    }
  }
}
