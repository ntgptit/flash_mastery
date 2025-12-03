import 'package:flash_mastery/domain/entities/flashcard.dart';

/// Data model for flashcard with mapping helpers.
class FlashcardModel {
  final String id;
  final String deckId;
  final String question;
  final String answer;
  final String? hint;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FlashcardModel({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    this.hint,
    required this.createdAt,
    required this.updatedAt,
  });

  FlashcardModel copyWith({
    String? id,
    String? deckId,
    String? question,
    String? answer,
    String? hint,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      hint: hint ?? this.hint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Flashcard toEntity() => Flashcard(
        id: id,
        deckId: deckId,
        question: question,
        answer: answer,
        hint: hint,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory FlashcardModel.fromEntity(Flashcard flashcard) => FlashcardModel(
        id: flashcard.id,
        deckId: flashcard.deckId,
        question: flashcard.question,
        answer: flashcard.answer,
        hint: flashcard.hint,
        createdAt: flashcard.createdAt,
        updatedAt: flashcard.updatedAt,
      );
}
