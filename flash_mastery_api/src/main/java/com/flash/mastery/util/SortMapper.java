package com.flash.mastery.util;

import org.springframework.data.domain.Sort;

import lombok.experimental.UtilityClass;

@UtilityClass
public final class SortMapper {

    public static Sort toSort(SortableOption option) {
        return Sort.by(option.getDirection(), option.getField());
    }
}
