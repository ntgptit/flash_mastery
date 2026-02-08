package com.flash.mastery.service;

import java.util.Optional;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;

import com.flash.mastery.exception.NotFoundException;

/**
 * Base service class providing common functionality for all services.
 */
public abstract class BaseService {

    protected final MessageSource messageSource;

    protected BaseService(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    /**
     * Get localized message by key.
     *
     * @param key the message key
     * @return the localized message
     */
    protected String msg(String key) {
        return this.messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
    }

    /**
     * Find entity by ID or throw NotFoundException.
     *
     * @param <T>        the entity type
     * @param optional   the optional entity from repository
     * @param errorCode  domain-specific error code (e.g. ErrorCodes.DECK_NOT_FOUND)
     * @param messageKey i18n message key (e.g. MessageKeys.ERROR_DECK_NOT_FOUND)
     * @return the entity if found
     * @throws NotFoundException if entity not found
     */
    protected <T> T findByIdOrThrow(Optional<T> optional, String errorCode, String messageKey) {
        return optional.orElseThrow(() -> new NotFoundException(errorCode, messageKey));
    }

    /**
     * Increment count safely (prevent negative values).
     *
     * @param currentCount the current count value
     * @param increment    the increment value (usually 1)
     * @return the new count value
     */
    protected int incrementCount(int currentCount, int increment) {
        return Math.max(0, currentCount + increment);
    }

    /**
     * Decrement count safely (prevent negative values).
     *
     * @param currentCount the current count value
     * @param decrement    the decrement value (usually 1)
     * @return the new count value (never negative)
     */
    protected int decrementCount(int currentCount, int decrement) {
        return Math.max(0, currentCount - decrement);
    }
}
