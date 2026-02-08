package com.flash.mastery.exception;

import org.springframework.http.HttpStatus;

public class NotFoundException extends BusinessException {

    public NotFoundException(String errorCode, String messageKey) {
        super(messageKey, errorCode, HttpStatus.NOT_FOUND);
    }

    public NotFoundException(String errorCode, String messageKey, String logMessage) {
        super(messageKey, errorCode, HttpStatus.NOT_FOUND, logMessage);
    }
}
