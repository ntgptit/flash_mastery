package com.flash.mastery.constant;

public final class ErrorCodes {

  private ErrorCodes() {}

  // ── Resource not found ──
  public static final String FOLDER_NOT_FOUND = "FOLDER_NOT_FOUND";
  public static final String DECK_NOT_FOUND = "DECK_NOT_FOUND";
  public static final String FLASHCARD_NOT_FOUND = "FLASHCARD_NOT_FOUND";
  public static final String SESSION_NOT_FOUND = "SESSION_NOT_FOUND";

  // ── Business logic ──
  public static final String FOLDER_SELF_REFERENCE = "FOLDER_SELF_REFERENCE";
  public static final String FOLDER_CIRCULAR_PARENT = "FOLDER_CIRCULAR_PARENT";
  public static final String FLASHCARD_TYPE_MISMATCH = "FLASHCARD_TYPE_MISMATCH";
  public static final String DECK_ID_REQUIRED = "DECK_ID_REQUIRED";
  public static final String NO_FLASHCARDS_AVAILABLE = "NO_FLASHCARDS_AVAILABLE";
  public static final String ALL_FLASHCARDS_STUDIED = "ALL_FLASHCARDS_STUDIED";
  public static final String FLASHCARD_NOT_IN_SESSION = "FLASHCARD_NOT_IN_SESSION";
  public static final String UNSUPPORTED_FILE_TYPE = "UNSUPPORTED_FILE_TYPE";

  // ── Generic (for Spring framework exceptions) ──
  public static final String VALIDATION_ERROR = "VALIDATION_ERROR";
  public static final String BAD_REQUEST = "BAD_REQUEST";
  public static final String CONFLICT = "CONFLICT";
  public static final String METHOD_NOT_ALLOWED = "METHOD_NOT_ALLOWED";
  public static final String INTERNAL_ERROR = "INTERNAL_ERROR";
}
