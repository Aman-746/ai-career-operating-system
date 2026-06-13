package com.aman.careeros.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * Health Check Controller.
 *
 * A simple endpoint to verify the application is running.
 * Useful for:
 *   - Quick manual testing after startup
 *   - Load balancer health checks (in production)
 *   - Verifying Spring context loaded correctly
 *
 * KEY CONCEPTS:
 * - @RestController = @Controller + @ResponseBody
 *     → Every method return value is serialized to JSON automatically
 * - @RequestMapping("/api/health") = base path for all methods in this controller
 * - @GetMapping = handles HTTP GET requests
 * - ResponseEntity = gives you control over HTTP status code + headers + body
 */
@RestController
@RequestMapping("/api/health")
public class HealthController {

    @GetMapping
    public ResponseEntity<Map<String, Object>> healthCheck() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "timestamp", LocalDateTime.now().toString()
        ));
    }

}
