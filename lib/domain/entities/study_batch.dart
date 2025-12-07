import 'package:flash_mastery/domain/entities/flashcard.dart';

/// Represents a batch of flashcards for study (max 7 cards).
class StudyBatch {
  final List<Flashcard> flashcards;
  final int batchIndex;

  const StudyBatch({
    required this.flashcards,
    required this.batchIndex,
  });

  /// Maximum batch size.
  static const int maxBatchSize = 7;

  /// Check if batch is full.
  bool get isFull => flashcards.length >= maxBatchSize;

  /// Check if batch is empty.
  bool get isEmpty => flashcards.isEmpty;

  /// Get batch size.
  int get size => flashcards.length;
}

