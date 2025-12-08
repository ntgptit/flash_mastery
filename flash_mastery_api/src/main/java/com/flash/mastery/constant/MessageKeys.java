package com.flash.mastery.constant;

public final class MessageKeys {

  private MessageKeys() {}

  // Not Found Errors
  public static final String ERROR_NOT_FOUND_FOLDER = "error.not_found.folder";
  public static final String ERROR_NOT_FOUND_DECK = "error.not_found.deck";
  public static final String ERROR_NOT_FOUND_FLASHCARD = "error.not_found.flashcard";
  public static final String ERROR_NOT_FOUND_SESSION = "error.not_found.session";

  // Validation Errors
  public static final String ERROR_VALIDATION = "error.validation";
  public static final String ERROR_FOLDER_CANNOT_REFERENCE_ITSELF = "error.folder.cannot_reference_itself";
  public static final String ERROR_FOLDER_PARENT_DESCENDANT = "error.folder.parent_descendant";
  public static final String ERROR_DECK_ID_NULL = "error.deck.id_null";
  public static final String ERROR_FLASHCARD_TYPE_MISMATCH = "error.flashcard.type_mismatch";
  public static final String ERROR_MISSING_VOCABULARY_OR_MEANING = "error.missing.vocabulary_or_meaning";
  public static final String ERROR_VOCABULARY_OR_MEANING_BLANK = "error.vocabulary_or_meaning.blank";
  public static final String ERROR_NO_FLASHCARDS_AVAILABLE = "error.no_flashcards.available";
  public static final String ERROR_ALL_FLASHCARDS_STUDIED = "error.all_flashcards.studied";

  // Internal Errors
  public static final String ERROR_INTERNAL = "error.internal";
}
