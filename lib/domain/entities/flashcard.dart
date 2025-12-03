import 'package:equatable/equatable.dart';

/// Flashcard entity representing a single study card.
class Flashcard extends Equatable {
  final String id;
  final String deckId;
  final String question;
  final String answer;
  final String? hint;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Flashcard({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    this.hint,
    required this.createdAt,
    required this.updatedAt,
  });

  Flashcard copyWith({
    String? id,
    String? deckId,
    String? question,
    String? answer,
    String? hint,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Flashcard(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      hint: hint ?? this.hint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        deckId,
        question,
        answer,
        hint,
        createdAt,
        updatedAt,
      ];
}
