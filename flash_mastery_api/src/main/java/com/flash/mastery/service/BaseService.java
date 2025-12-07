package com.flash.mastery.service;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;

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
}

