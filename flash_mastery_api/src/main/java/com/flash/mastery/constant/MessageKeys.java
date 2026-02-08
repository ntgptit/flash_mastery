package com.flash.mastery.constant;

public final class MessageKeys {

  private MessageKeys() {}

  // ── Resource not found ──
  public static final String ERROR_FOLDER_NOT_FOUND = "error.folder_not_found";
  public static final String ERROR_DECK_NOT_FOUND = "error.deck_not_found";
  public static final String ERROR_FLASHCARD_NOT_FOUND = "error.flashcard_not_found";
  public static final String ERROR_SESSION_NOT_FOUND = "error.session_not_found";

  // ── Business logic ──
  public static final String ERROR_FOLDER_SELF_REFERENCE = "error.folder_self_reference";
  public static final String ERROR_FOLDER_CIRCULAR_PARENT = "error.folder_circular_parent";
  public static final String ERROR_FLASHCARD_TYPE_MISMATCH = "error.flashcard_type_mismatch";
  public static final String ERROR_DECK_ID_REQUIRED = "error.deck_id_required";
  public static final String ERROR_NO_FLASHCARDS_AVAILABLE = "error.no_flashcards_available";
  public static final String ERROR_ALL_FLASHCARDS_STUDIED = "error.all_flashcards_studied";
  public static final String ERROR_FLASHCARD_NOT_IN_SESSION = "error.flashcard_not_in_session";
  public static final String ERROR_UNSUPPORTED_FILE_TYPE = "error.unsupported_file_type";

  // ── Generic ──
  public static final String ERROR_VALIDATION = "error.validation";
  public static final String ERROR_BAD_REQUEST = "error.bad_request";
  public static final String ERROR_METHOD_NOT_ALLOWED = "error.method_not_allowed";
  public static final String ERROR_INTERNAL = "error.internal";
}
