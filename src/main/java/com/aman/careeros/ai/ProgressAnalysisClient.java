package com.aman.careeros.ai;

import com.aman.careeros.config.AiServiceProperties;
import com.aman.careeros.dto.ProgressAnalysisAiRequest;
import com.aman.careeros.dto.ProgressAnalysisAiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.time.Duration;

@Component
@Slf4j
public class ProgressAnalysisClient {

    private final RestClient restClient;

    public ProgressAnalysisClient(AiServiceProperties properties) {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout((int) Duration.ofSeconds(properties.getConnectTimeoutSeconds()).toMillis());
        factory.setReadTimeout((int) Duration.ofSeconds(properties.getReadTimeoutSeconds()).toMillis());

        this.restClient = RestClient.builder()
                .baseUrl(properties.getBaseUrl())
                .requestFactory(factory)
                .build();
    }

    public ProgressAnalysisAiResponse analyze(ProgressAnalysisAiRequest request) {
        try {
            return restClient.post()
                    .uri("/generate/progress-analysis")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(request)
                    .retrieve()
                    .body(ProgressAnalysisAiResponse.class);
        } catch (Exception e) {
            throw new AiServiceException("Progress analysis failed: " + e.getMessage(), e);
        }
    }
}
