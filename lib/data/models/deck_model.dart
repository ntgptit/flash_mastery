import '../../domain/entities/deck.dart';

/// Data model for Deck with mapping helpers.
class DeckModel {
  final String id;
  final String name;
  final String? description;
  final String? folderId;
  final int cardCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeckModel({
    required this.id,
    required this.name,
    this.description,
    this.folderId,
    this.cardCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  DeckModel copyWith({
    String? id,
    String? name,
    String? description,
    String? folderId,
    int? cardCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeckModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      folderId: folderId ?? this.folderId,
      cardCount: cardCount ?? this.cardCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Deck toEntity() => Deck(
        id: id,
        name: name,
        description: description,
        folderId: folderId,
        cardCount: cardCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory DeckModel.fromEntity(Deck deck) => DeckModel(
        id: deck.id,
        name: deck.name,
        description: deck.description,
        folderId: deck.folderId,
        cardCount: deck.cardCount,
        createdAt: deck.createdAt,
        updatedAt: deck.updatedAt,
      );
}
