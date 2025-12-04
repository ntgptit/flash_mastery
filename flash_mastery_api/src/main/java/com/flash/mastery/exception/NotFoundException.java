package com.flash.mastery.exception;

public class NotFoundException extends RuntimeException {
    private static final long serialVersionUID = -1791292593081061951L;

    public NotFoundException(String message) {
        super(message);
    }
}
