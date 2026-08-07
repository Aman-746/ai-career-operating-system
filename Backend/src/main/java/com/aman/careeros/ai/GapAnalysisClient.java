package com.aman.careeros.ai;

import com.aman.careeros.config.AiServiceProperties;
import com.aman.careeros.dto.GapAnalysis;
import com.aman.careeros.dto.GapAnalysisRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.time.Duration;

@Component
@Slf4j
public class GapAnalysisClient {

    private final RestClient restClient;

    public GapAnalysisClient(AiServiceProperties properties) {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout((int) Duration.ofSeconds(properties.getConnectTimeoutSeconds()).toMillis());
        factory.setReadTimeout((int) Duration.ofSeconds(properties.getReadTimeoutSeconds()).toMillis());

        this.restClient = RestClient.builder()
                .baseUrl(properties.getBaseUrl())
                .requestFactory(factory)
                .build();
    }

    public GapAnalysis analyze(GapAnalysisRequest request) {
        try {
            return restClient.post()
                    .uri("/analyze/gap")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(request)
                    .retrieve()
                    .body(GapAnalysis.class);
        } catch (Exception e) {
            throw new AiServiceException("AI service call failed: " + e.getMessage(), e);
        }
    }
}
