import 'package:equatable/equatable.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';

/// Deck entity representing a collection of flashcards under a folder.
class Deck extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? folderId;
  final int cardCount;
  final FlashcardType? _type;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Returns the deck type, defaulting to vocabulary if null
  FlashcardType get type => _type ?? FlashcardType.vocabulary;

  const Deck({
    required this.id,
    required this.name,
    this.description,
    this.folderId,
    this.cardCount = 0,
    FlashcardType? type,
    required this.createdAt,
    required this.updatedAt,
  }) : _type = type;

  Deck copyWith({
    String? id,
    String? name,
    String? description,
    String? folderId,
    int? cardCount,
    FlashcardType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      folderId: folderId ?? this.folderId,
      cardCount: cardCount ?? this.cardCount,
      type: type ?? _type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        folderId,
        cardCount,
        _type,
        createdAt,
        updatedAt,
      ];
}
