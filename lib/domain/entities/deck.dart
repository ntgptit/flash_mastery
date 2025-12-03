import 'package:equatable/equatable.dart';

/// Deck entity representing a collection of flashcards under a folder.
class Deck extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? folderId;
  final int cardCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Deck({
    required this.id,
    required this.name,
    this.description,
    this.folderId,
    this.cardCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Deck copyWith({
    String? id,
    String? name,
    String? description,
    String? folderId,
    int? cardCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Deck(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      folderId: folderId ?? this.folderId,
      cardCount: cardCount ?? this.cardCount,
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
        createdAt,
        updatedAt,
      ];
}
