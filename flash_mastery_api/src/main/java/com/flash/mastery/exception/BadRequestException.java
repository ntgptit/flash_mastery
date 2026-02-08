package com.flash.mastery.exception;

import org.springframework.http.HttpStatus;

public class BadRequestException extends BusinessException {

    public BadRequestException(String errorCode, String messageKey) {
        super(messageKey, errorCode, HttpStatus.BAD_REQUEST);
    }

    public BadRequestException(String errorCode, String messageKey, String logMessage) {
        super(messageKey, errorCode, HttpStatus.BAD_REQUEST, logMessage);
    }
}
