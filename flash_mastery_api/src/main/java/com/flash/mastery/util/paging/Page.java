package com.flash.mastery.util.paging;

import java.util.List;

/**
 * Simple pagination wrapper for MyBatis results.
 */
public class Page<T> {
    private final List<T> content;
    private final long totalElements;
    private final int pageNumber;
    private final int pageSize;

    public Page(List<T> content, long totalElements, int pageNumber, int pageSize) {
        this.content = content;
        this.totalElements = totalElements;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
    }

    public List<T> getContent() {
        return content;
    }

    public long getTotalElements() {
        return totalElements;
    }

    public int getPageNumber() {
        return pageNumber;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalPages() {
        return (int) Math.ceil((double) totalElements / pageSize);
    }

    public boolean hasContent() {
        return !content.isEmpty();
    }
}
