import 'package:equatable/equatable.dart';

/// Folder entity representing a collection of flashcard decks
class Folder extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? color;
  final int deckCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Folder({
    required this.id,
    required this.name,
    this.description,
    this.color,
    required this.deckCount,
    required this.createdAt,
    required this.updatedAt,
  });

  Folder copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    int? deckCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      deckCount: deckCount ?? this.deckCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        deckCount,
        createdAt,
        updatedAt,
      ];
}
