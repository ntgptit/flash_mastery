// ignore_for_file: invalid_annotation_target

import 'package:flash_mastery/domain/entities/flashcard.dart';
import 'package:flash_mastery/domain/entities/flashcard_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_model.freezed.dart';
part 'flashcard_model.g.dart';

@freezed
abstract class FlashcardModel with _$FlashcardModel {
  const FlashcardModel._();

  const factory FlashcardModel({
    required String id,
    required String deckId,
    required String question,
    required String answer,
    String? hint,
    @JsonKey(
      fromJson: flashcardTypeFromJson,
      toJson: flashcardTypeToJson,
    )
    @Default(FlashcardType.vocabulary)
    FlashcardType type,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FlashcardModel;

  factory FlashcardModel.fromJson(Map<String, dynamic> json) => _$FlashcardModelFromJson(json);

  Flashcard toEntity() => Flashcard(
    id: id,
    deckId: deckId,
    question: question,
    answer: answer,
    hint: hint,
    type: type,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory FlashcardModel.fromEntity(Flashcard flashcard) => FlashcardModel(
    id: flashcard.id,
    deckId: flashcard.deckId,
    question: flashcard.question,
    answer: flashcard.answer,
    hint: flashcard.hint,
    type: flashcard.type,
    createdAt: flashcard.createdAt,
    updatedAt: flashcard.updatedAt,
  );
}
