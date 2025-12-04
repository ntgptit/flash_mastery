package com.flash.mastery.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

import com.flash.mastery.constant.MessageSourceConstants;

@Configuration
public class MessageSourceConfig {

    @Bean
    public MessageSource messageSource() {
        final var messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename(MessageSourceConstants.BASENAME);
        messageSource.setDefaultEncoding(MessageSourceConstants.DEFAULT_ENCODING);
        messageSource.setFallbackToSystemLocale(false);
        return messageSource;
    }
}
