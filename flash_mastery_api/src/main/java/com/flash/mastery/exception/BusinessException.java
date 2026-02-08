package com.flash.mastery.exception;

import org.springframework.http.HttpStatus;

import lombok.Getter;

@Getter
public abstract class BusinessException extends RuntimeException {

    private final String errorCode;
    private final HttpStatus status;
    private final String messageKey;

    /**
     * @param messageKey i18n key → resolved to client-facing message
     * @param errorCode  domain-specific error code for client to switch on
     * @param status     HTTP status
     */
    protected BusinessException(String messageKey, String errorCode, HttpStatus status) {
        super(messageKey);
        this.errorCode = errorCode;
        this.status = status;
        this.messageKey = messageKey;
    }

    /**
     * @param messageKey  i18n key → resolved to client-facing message
     * @param errorCode   domain-specific error code for client to switch on
     * @param status      HTTP status
     * @param logMessage  technical message for ops log (never sent to client)
     */
    protected BusinessException(String messageKey, String errorCode, HttpStatus status, String logMessage) {
        super(logMessage);
        this.errorCode = errorCode;
        this.status = status;
        this.messageKey = messageKey;
    }
}
