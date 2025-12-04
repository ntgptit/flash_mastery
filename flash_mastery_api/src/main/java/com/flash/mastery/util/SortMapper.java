package com.flash.mastery.util;

import org.springframework.data.domain.Sort;

public final class SortMapper {

  private SortMapper() {}

  public static Sort toSort(SortableOption option) {
    return Sort.by(option.getDirection(), option.getField());
  }
}
