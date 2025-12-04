package com.flash.mastery.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
    info =
        @Info(
            title = "Flash Mastery API",
            version = "v1",
            description = "Backend API for flashcards, decks, and folders"),
    servers = {@Server(url = "/", description = "Default server")})
public class OpenApiConfig {
  // Additional OpenAPI customizations can be added here if needed.
}
