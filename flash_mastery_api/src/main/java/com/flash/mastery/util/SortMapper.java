package com.flash.mastery.util;

import com.flash.mastery.entity.enums.SortableOption;
import lombok.experimental.UtilityClass;

/**
 * Utility class for sort mapping - no longer needed with MyBatis.
 * Kept for potential future use.
 */
@UtilityClass
public final class SortMapper {

    public static String toOrderByClause(SortableOption option) {
        return option.getField() + " " + option.getDirection().name();
    }
}
