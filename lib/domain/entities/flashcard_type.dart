enum FlashcardType { vocabulary, grammar }

FlashcardType flashcardTypeFromJson(String? value) {
  if (value == null) return FlashcardType.vocabulary;
  switch (value.toLowerCase()) {
    case 'vocabulary':
      return FlashcardType.vocabulary;
    case 'grammar':
      return FlashcardType.grammar;
    default:
      return FlashcardType.vocabulary;
  }
}

String flashcardTypeToJson(FlashcardType type) => type.name.toUpperCase();

FlashcardType? flashcardTypeFromJsonNullable(String? value) {
  if (value == null) return null;
  switch (value.toLowerCase()) {
    case 'vocabulary':
      return FlashcardType.vocabulary;
    case 'grammar':
      return FlashcardType.grammar;
    default:
      return FlashcardType.vocabulary;
  }
}

String? flashcardTypeToJsonNullable(FlashcardType? type) => type?.name.toUpperCase();

extension FlashcardTypeX on FlashcardType {
  String get label => this == FlashcardType.vocabulary ? 'Vocabulary' : 'Grammar';
}
