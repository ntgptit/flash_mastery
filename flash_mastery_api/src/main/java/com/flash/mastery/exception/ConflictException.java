package com.flash.mastery.exception;

import org.springframework.http.HttpStatus;

public class ConflictException extends BusinessException {

    public ConflictException(String errorCode, String messageKey) {
        super(messageKey, errorCode, HttpStatus.CONFLICT);
    }

    public ConflictException(String errorCode, String messageKey, String logMessage) {
        super(messageKey, errorCode, HttpStatus.CONFLICT, logMessage);
    }
}
