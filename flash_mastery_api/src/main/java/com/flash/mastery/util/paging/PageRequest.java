package com.flash.mastery.util.paging;

/**
 * Simple pagination request helper for MyBatis.
 */
public class PageRequest {
    private final int page;
    private final int size;
    private final int offset;
    private final int limit;

    private PageRequest(int page, int size) {
        this.page = page;
        this.size = size;
        this.offset = page * size;
        this.limit = size;
    }

    public static PageRequest of(int page, int size) {
        return new PageRequest(page, size);
    }

    public int getPage() {
        return page;
    }

    public int getSize() {
        return size;
    }

    public int getOffset() {
        return offset;
    }

    public int getLimit() {
        return limit;
    }

    public <T> Page<T> toPage(java.util.List<T> content, long totalElements) {
        return new Page<>(content, totalElements, page, size);
    }
}
