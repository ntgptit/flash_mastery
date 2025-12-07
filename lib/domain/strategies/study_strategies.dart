import 'dart:math';
import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/study_mode.dart';

/// Base interface for study mode handlers.
abstract class StudyModeHandler {
  /// Get the study mode this handler manages.
  StudyMode get mode;

  /// Prepare flashcards for this study mode.
  /// Returns a list of flashcards ready for study.
  List<Flashcard> prepareFlashcards(List<Flashcard> flashcards);

  /// Validate answer for this study mode.
  bool validateAnswer({
    required Flashcard flashcard,
    required dynamic userAnswer,
  });

  /// Get options for multiple choice (if applicable).
  List<String>? getOptions({
    required Flashcard flashcard,
    required List<Flashcard> allFlashcards,
  });
}

/// Overview study handler.
/// Displays flashcards with term below and meaning above.
class OverviewStudyHandler implements StudyModeHandler {
  @override
  StudyMode get mode => StudyMode.overview;

  @override
  List<Flashcard> prepareFlashcards(List<Flashcard> flashcards) {
    // Shuffle flashcards for overview
    final shuffled = List<Flashcard>.from(flashcards);
    shuffled.shuffle(Random());
    return shuffled;
  }

  @override
  bool validateAnswer({
    required Flashcard flashcard,
    required dynamic userAnswer,
  }) {
    // Overview mode doesn't require validation, just viewing
    return true;
  }

  @override
  List<String>? getOptions({
    required Flashcard flashcard,
    required List<Flashcard> allFlashcards,
  }) {
    // Overview mode doesn't use options
    return null;
  }
}

/// Matching study handler.
/// Match terms with meanings in two columns.
class MatchingStudyHandler implements StudyModeHandler {
  @override
  StudyMode get mode => StudyMode.matching;

  @override
  List<Flashcard> prepareFlashcards(List<Flashcard> flashcards) {
    // Shuffle for matching game
    final shuffled = List<Flashcard>.from(flashcards);
    shuffled.shuffle(Random());
    return shuffled;
  }

  @override
  bool validateAnswer({
    required Flashcard flashcard,
    required dynamic userAnswer,
  }) {
    // userAnswer should be the matched flashcard ID
    if (userAnswer is String) {
      return userAnswer == flashcard.id;
    }
    if (userAnswer is Flashcard) {
      return userAnswer.id == flashcard.id;
    }
    return false;
  }

  @override
  List<String>? getOptions({
    required Flashcard flashcard,
    required List<Flashcard> allFlashcards,
  }) {
    // Matching mode doesn't use traditional options
    return null;
  }
}

/// Guess study handler.
/// Show term, guess meaning from multiple choice.
class GuessStudyHandler implements StudyModeHandler {
  @override
  StudyMode get mode => StudyMode.guess;

  @override
  List<Flashcard> prepareFlashcards(List<Flashcard> flashcards) {
    // Shuffle flashcards
    final shuffled = List<Flashcard>.from(flashcards);
    shuffled.shuffle(Random());
    return shuffled;
  }

  @override
  bool validateAnswer({
    required Flashcard flashcard,
    required dynamic userAnswer,
  }) {
    // userAnswer should be the selected meaning (answer)
    if (userAnswer is String) {
      return userAnswer.trim().toLowerCase() == flashcard.answer.trim().toLowerCase();
    }
    return false;
  }

  @override
  List<String>? getOptions({
    required Flashcard flashcard,
    required List<Flashcard> allFlashcards,
  }) {
    // Generate 5 options: 1 correct + 4 incorrect
    final options = <String>[flashcard.answer];
    final otherFlashcards = allFlashcards.where((c) => c.id != flashcard.id).toList();
    otherFlashcards.shuffle(Random());

    // Add 4 incorrect options
    for (int i = 0; i < 4 && i < otherFlashcards.length; i++) {
      options.add(otherFlashcards[i].answer);
    }

    // Shuffle options
    options.shuffle(Random());
    return options;
  }
}

/// Recall study handler.
/// Show term, guess meaning with time limit.
class RecallStudyHandler implements StudyModeHandler {
  @override
  StudyMode get mode => StudyMode.recall;

  @override
  List<Flashcard> prepareFlashcards(List<Flashcard> flashcards) {
    // Shuffle flashcards
    final shuffled = List<Flashcard>.from(flashcards);
    shuffled.shuffle(Random());
    return shuffled;
  }

  @override
  bool validateAnswer({
    required Flashcard flashcard,
    required dynamic userAnswer,
  }) {
    // userAnswer should be the guessed meaning (answer)
    if (userAnswer is String) {
      return userAnswer.trim().toLowerCase() == flashcard.answer.trim().toLowerCase();
    }
    return false;
  }

  @override
  List<String>? getOptions({
    required Flashcard flashcard,
    required List<Flashcard> allFlashcards,
  }) {
    // Recall mode doesn't use multiple choice
    return null;
  }

  /// Get time limit in seconds for recall mode.
  int getTimeLimit() => 30; // 30 seconds default
}

/// Fill in blank study handler.
/// Show meaning, type the term.
class FillInBlankStudyHandler implements StudyModeHandler {
  @override
  StudyMode get mode => StudyMode.fillInBlank;

  @override
  List<Flashcard> prepareFlashcards(List<Flashcard> flashcards) {
    // Shuffle flashcards
    final shuffled = List<Flashcard>.from(flashcards);
    shuffled.shuffle(Random());
    return shuffled;
  }

  @override
  bool validateAnswer({
    required Flashcard flashcard,
    required dynamic userAnswer,
  }) {
    // userAnswer should be the typed term (question)
    if (userAnswer is String) {
      return userAnswer.trim().toLowerCase() == flashcard.question.trim().toLowerCase();
    }
    return false;
  }

  @override
  List<String>? getOptions({
    required Flashcard flashcard,
    required List<Flashcard> allFlashcards,
  }) {
    // Fill in blank mode doesn't use options
    return null;
  }
}

