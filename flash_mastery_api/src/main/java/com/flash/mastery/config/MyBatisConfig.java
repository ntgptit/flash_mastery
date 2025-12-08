package com.flash.mastery.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis configuration.
 * Configures mapper scanning for repository interfaces.
 * MyBatis auto-configuration from Spring Boot will handle SqlSessionFactory creation.
 */
@Configuration
@MapperScan("com.flash.mastery.repository")
public class MyBatisConfig {
    // MyBatis Spring Boot Starter will auto-configure SqlSessionFactory
    // based on application.properties settings
}

