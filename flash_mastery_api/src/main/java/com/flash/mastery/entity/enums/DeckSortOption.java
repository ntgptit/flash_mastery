package com.flash.mastery.entity.enums;

public enum DeckSortOption implements SortableOption {
    LATEST("latest", "createdAt", SortDirection.DESC),
    NAME_ASC("name,asc", "name", SortDirection.ASC),
    NAME_DESC("name,desc", "name", SortDirection.DESC),
    CARD_COUNT_ASC("cardCount,asc", "cardCount", SortDirection.ASC),
    CARD_COUNT_DESC("cardCount,desc", "cardCount", SortDirection.DESC);

    private final String key;
    private final String field;
    private final SortDirection direction;

    DeckSortOption(String key, String field, SortDirection direction) {
        this.key = key;
        this.field = field;
        this.direction = direction;
    }

    @Override
    public String getKey() {
        return this.key;
    }

    @Override
    public String getField() {
        return this.field;
    }

    @Override
    public SortDirection getDirection() {
        return this.direction;
    }

    public static DeckSortOption from(String value) {
        if ((value == null) || value.isBlank()) {
            return LATEST;
        }
        for (final DeckSortOption option : DeckSortOption.values()) {
            if (option.key.equalsIgnoreCase(value)) {
                return option;
            }
        }
        return LATEST;
    }
}
