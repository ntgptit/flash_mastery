package com.flash.mastery.util;

import java.util.Comparator;

import lombok.experimental.UtilityClass;

/**
 * Comparator for natural order sorting (numerical order within strings).
 * Example: "section 1", "section 2", "section 10" instead of "section 1", "section 10", "section 2"
 */
@UtilityClass
public final class NaturalOrderComparator {

    /**
     * Compare two strings in natural order (numerical order).
     *
     * @param s1 first string
     * @param s2 second string
     * @return negative if s1 < s2, zero if equal, positive if s1 > s2
     */
    public static int compare(String s1, String s2) {
        if (s1 == null && s2 == null) {
            return 0;
        }
        if (s1 == null) {
            return -1;
        }
        if (s2 == null) {
            return 1;
        }

        final int len1 = s1.length();
        final int len2 = s2.length();
        int i1 = 0;
        int i2 = 0;

        while (i1 < len1 && i2 < len2) {
            final char c1 = s1.charAt(i1);
            final char c2 = s2.charAt(i2);

            if (Character.isDigit(c1) && Character.isDigit(c2)) {
                // Both are digits, compare numerically
                int num1 = 0;
                int num2 = 0;

                // Extract number from s1
                while (i1 < len1 && Character.isDigit(s1.charAt(i1))) {
                    num1 = num1 * 10 + Character.getNumericValue(s1.charAt(i1));
                    i1++;
                }

                // Extract number from s2
                while (i2 < len2 && Character.isDigit(s2.charAt(i2))) {
                    num2 = num2 * 10 + Character.getNumericValue(s2.charAt(i2));
                    i2++;
                }

                if (num1 != num2) {
                    return num1 - num2;
                }
            } else {
                // Compare characters normally (case-insensitive)
                final int diff = Character.toLowerCase(c1) - Character.toLowerCase(c2);
                if (diff != 0) {
                    return diff;
                }
                i1++;
                i2++;
            }
        }

        return len1 - len2;
    }

    /**
     * Create a Comparator for natural order sorting.
     *
     * @param <T> the type to compare
     * @param keyExtractor function to extract string key from object
     * @return Comparator for natural order
     */
    public static <T> Comparator<T> comparing(java.util.function.Function<T, String> keyExtractor) {
        return (t1, t2) -> compare(keyExtractor.apply(t1), keyExtractor.apply(t2));
    }
}


