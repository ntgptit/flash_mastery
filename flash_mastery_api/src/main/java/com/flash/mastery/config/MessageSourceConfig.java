package com.flash.mastery.config;

import com.flash.mastery.constant.MessageSourceConstants;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;

@Configuration
public class MessageSourceConfig {

  @Bean
  public MessageSource messageSource() {
    ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
    messageSource.setBasename(MessageSourceConstants.BASENAME);
    messageSource.setDefaultEncoding(MessageSourceConstants.DEFAULT_ENCODING);
    messageSource.setFallbackToSystemLocale(false);
    return messageSource;
  }
}
