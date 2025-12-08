package com.flash.mastery.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

/**
 * MyBatis configuration.
 * Configures SqlSessionFactory and mapper scanning for repository interfaces.
 */
@Configuration
@MapperScan(basePackages = "com.flash.mastery.repository", sqlSessionFactoryRef = "sqlSessionFactory")
public class MyBatisConfig {

    @Bean(name = "sqlSessionFactory")
    SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        final var sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);

        // Set mapper locations
        final var resolver = new PathMatchingResourcePatternResolver();
        sessionFactory.setMapperLocations(resolver.getResources("classpath:mapper/**/*.xml"));

        // Set type aliases package
        sessionFactory.setTypeAliasesPackage("com.flash.mastery.entity");

        // Configure MyBatis settings
        final var configuration = new org.apache.ibatis.session.Configuration();
        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setDefaultFetchSize(100);
        configuration.setDefaultStatementTimeout(30);
        configuration.setLogImpl(org.apache.ibatis.logging.slf4j.Slf4jImpl.class);

        // Register UUID type handler
        configuration.getTypeHandlerRegistry().register(java.util.UUID.class,
                com.flash.mastery.config.UuidTypeHandler.class);

        sessionFactory.setConfiguration(configuration);

        return sessionFactory.getObject();
    }

    @Bean(name = "sqlSessionTemplate")
    SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}
