package com.aman.careeros.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "app.ai-service")
@Data
public class AiServiceProperties {

    private boolean enabled = true;
    private String baseUrl = "http://localhost:8000";
    private int connectTimeoutSeconds = 5;
    private int readTimeoutSeconds = 60;
}
