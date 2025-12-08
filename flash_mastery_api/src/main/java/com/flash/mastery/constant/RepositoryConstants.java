package com.flash.mastery.constant;

/**
 * Constants used in repository layer.
 * Contains values used when calling repository methods.
 */
public final class RepositoryConstants {

    private RepositoryConstants() {
        // Utility class
    }

    // ==================== PAGINATION ====================

    /**
     * Default offset value (0) for fetching all records.
     */
    public static final int DEFAULT_OFFSET = 0;

    /**
     * Maximum limit value to fetch all records (Integer.MAX_VALUE).
     */
    public static final int MAX_LIMIT = Integer.MAX_VALUE;

    // ==================== BATCH OPERATIONS ====================

    /**
     * Batch size for bulk insert operations.
     */
    public static final int BATCH_SIZE = 500;

    // ==================== RECURSION LIMITS ====================

    /**
     * Maximum recursion depth for folder hierarchy operations.
     */
    public static final int MAX_RECURSION_DEPTH = 100;

    // ==================== PARAMETER NAMES ====================

    /**
     * Parameter name for ID.
     */
    public static final String PARAM_ID = "id";

    /**
     * Parameter name for folder ID.
     */
    public static final String PARAM_FOLDER_ID = "folderId";

    /**
     * Parameter name for deck ID.
     */
    public static final String PARAM_DECK_ID = "deckId";

    /**
     * Parameter name for name.
     */
    public static final String PARAM_NAME = "name";

    /**
     * Parameter name for offset.
     */
    public static final String PARAM_OFFSET = "offset";

    /**
     * Parameter name for limit.
     */
    public static final String PARAM_LIMIT = "limit";

    /**
     * Parameter name for session ID.
     */
    public static final String PARAM_SESSION_ID = "sessionId";

    /**
     * Parameter name for flashcard ID.
     */
    public static final String PARAM_FLASHCARD_ID = "flashcardId";

    /**
     * Parameter name for flashcard IDs (list).
     */
    public static final String PARAM_FLASHCARD_IDS = "flashcardIds";

    /**
     * Parameter name for progress data.
     */
    public static final String PARAM_PROGRESS_DATA = "progressData";

    /**
     * Parameter name for status.
     */
    public static final String PARAM_STATUS = "status";

    /**
     * Parameter name for parent ID.
     */
    public static final String PARAM_PARENT_ID = "parentId";

    /**
     * Parameter name for IDs (list).
     */
    public static final String PARAM_IDS = "ids";
}

