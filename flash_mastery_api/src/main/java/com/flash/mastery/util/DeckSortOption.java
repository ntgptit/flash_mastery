package com.flash.mastery.util;

import org.springframework.data.domain.Sort;

public enum DeckSortOption implements SortableOption {
  LATEST("latest", "createdAt", Sort.Direction.DESC),
  NAME_ASC("name,asc", "name", Sort.Direction.ASC),
  NAME_DESC("name,desc", "name", Sort.Direction.DESC),
  CARD_COUNT_ASC("cardCount,asc", "cardCount", Sort.Direction.ASC),
  CARD_COUNT_DESC("cardCount,desc", "cardCount", Sort.Direction.DESC);

  private final String key;
  private final String field;
  private final Sort.Direction direction;

  DeckSortOption(String key, String field, Sort.Direction direction) {
    this.key = key;
    this.field = field;
    this.direction = direction;
  }

  @Override
  public String getKey() {
    return key;
  }

  @Override
  public String getField() {
    return field;
  }

  @Override
  public Sort.Direction getDirection() {
    return direction;
  }

  public static DeckSortOption from(String value) {
    if (value == null || value.isBlank()) {
      return LATEST;
    }
    for (DeckSortOption option : DeckSortOption.values()) {
      if (option.key.equalsIgnoreCase(value)) {
        return option;
      }
    }
    return LATEST;
  }
}
