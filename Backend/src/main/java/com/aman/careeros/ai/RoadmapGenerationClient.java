package com.aman.careeros.ai;

import com.aman.careeros.config.AiServiceProperties;
import com.aman.careeros.dto.RoadmapAiRequest;
import com.aman.careeros.dto.RoadmapAiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.time.Duration;

@Component
@Slf4j
public class RoadmapGenerationClient {

    private final RestClient restClient;

    public RoadmapGenerationClient(AiServiceProperties properties) {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout((int) Duration.ofSeconds(properties.getConnectTimeoutSeconds()).toMillis());
        factory.setReadTimeout((int) Duration.ofSeconds(properties.getReadTimeoutSeconds()).toMillis());

        this.restClient = RestClient.builder()
                .baseUrl(properties.getBaseUrl())
                .requestFactory(factory)
                .build();
    }

    public RoadmapAiResponse generate(RoadmapAiRequest request) {
        try {
            return restClient.post()
                    .uri("/generate/roadmap")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(request)
                    .retrieve()
                    .body(RoadmapAiResponse.class);
        } catch (Exception e) {
            throw new AiServiceException("Roadmap generation failed: " + e.getMessage(), e);
        }
    }
}
