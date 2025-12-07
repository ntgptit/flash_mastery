import 'package:equatable/equatable.dart';
import 'package:flash_mastery/domain/entities/study_mode.dart';

/// Study session entity representing a study session.
class StudySession extends Equatable {
  final String id;
  final String deckId;
  final List<String> flashcardIds;
  final StudyMode currentMode;
  final int currentBatchIndex;
  final DateTime startedAt;
  final DateTime? completedAt;
  final Map<String, StudyProgress> progress;

  const StudySession({
    required this.id,
    required this.deckId,
    required this.flashcardIds,
    required this.currentMode,
    this.currentBatchIndex = 0,
    required this.startedAt,
    this.completedAt,
    this.progress = const {},
  });

  StudySession copyWith({
    String? id,
    String? deckId,
    List<String>? flashcardIds,
    StudyMode? currentMode,
    int? currentBatchIndex,
    DateTime? startedAt,
    DateTime? completedAt,
    Map<String, StudyProgress>? progress,
  }) {
    return StudySession(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      flashcardIds: flashcardIds ?? this.flashcardIds,
      currentMode: currentMode ?? this.currentMode,
      currentBatchIndex: currentBatchIndex ?? this.currentBatchIndex,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
    );
  }

  /// Get flashcards for current batch (max 7 cards).
  List<String> getCurrentBatch() {
    const batchSize = 7;
    final start = currentBatchIndex * batchSize;
    final end = (start + batchSize).clamp(0, flashcardIds.length);
    return flashcardIds.sublist(start, end);
  }

  /// Check if current batch is complete.
  bool isCurrentBatchComplete() {
    final batch = getCurrentBatch();
    return batch.every((id) => progress[id]?.isCompleted ?? false);
  }

  /// Check if all flashcards are studied.
  bool isComplete() {
    return flashcardIds.every((id) => progress[id]?.isCompleted ?? false);
  }

  /// Get next mode in sequence.
  StudyMode? getNextMode() {
    switch (currentMode) {
      case StudyMode.overview:
        return StudyMode.matching;
      case StudyMode.matching:
        return StudyMode.guess;
      case StudyMode.guess:
        return StudyMode.recall;
      case StudyMode.recall:
        return StudyMode.fillInBlank;
      case StudyMode.fillInBlank:
        return null; // All modes completed
    }
  }

  @override
  List<Object?> get props => [
        id,
        deckId,
        flashcardIds,
        currentMode,
        currentBatchIndex,
        startedAt,
        completedAt,
        progress,
      ];
}

/// Study progress for a single flashcard.
class StudyProgress extends Equatable {
  final String flashcardId;
  final Map<StudyMode, bool> modeCompletion;
  final int correctAnswers;
  final int totalAttempts;
  final DateTime? lastStudiedAt;

  const StudyProgress({
    required this.flashcardId,
    this.modeCompletion = const {},
    this.correctAnswers = 0,
    this.totalAttempts = 0,
    this.lastStudiedAt,
  });

  StudyProgress copyWith({
    String? flashcardId,
    Map<StudyMode, bool>? modeCompletion,
    int? correctAnswers,
    int? totalAttempts,
    DateTime? lastStudiedAt,
  }) {
    return StudyProgress(
      flashcardId: flashcardId ?? this.flashcardId,
      modeCompletion: modeCompletion ?? this.modeCompletion,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
    );
  }

  /// Check if flashcard is completed in all modes.
  bool get isCompleted {
    return modeCompletion.length == StudyMode.values.length &&
        modeCompletion.values.every((completed) => completed);
  }

  /// Mark a mode as completed.
  StudyProgress markModeCompleted(StudyMode mode) {
    final updated = Map<StudyMode, bool>.from(modeCompletion);
    updated[mode] = true;
    return copyWith(
      modeCompletion: updated,
      lastStudiedAt: DateTime.now(),
    );
  }

  /// Record an answer attempt.
  StudyProgress recordAttempt({required bool isCorrect}) {
    return copyWith(
      correctAnswers: isCorrect ? correctAnswers + 1 : correctAnswers,
      totalAttempts: totalAttempts + 1,
      lastStudiedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        flashcardId,
        modeCompletion,
        correctAnswers,
        totalAttempts,
        lastStudiedAt,
      ];
}

