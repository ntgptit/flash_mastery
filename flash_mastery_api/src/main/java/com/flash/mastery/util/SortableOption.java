package com.flash.mastery.util;

import org.springframework.data.domain.Sort;

public interface SortableOption {

    String getKey();

    String getField();

    Sort.Direction getDirection();
}
