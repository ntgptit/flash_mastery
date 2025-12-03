import 'package:flash_mastery/domain/entities/deck.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_model.freezed.dart';
part 'deck_model.g.dart';

@freezed
abstract class DeckModel with _$DeckModel {
  const DeckModel._();

  const factory DeckModel({
    required String id,
    required String name,
    String? description,
    String? folderId,
    @Default(0) int cardCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DeckModel;

  factory DeckModel.fromJson(Map<String, dynamic> json) => _$DeckModelFromJson(json);

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
