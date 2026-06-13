package com.aman.careeros.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Security Configuration — TEMPORARY (permits all requests).
 *
 * WHY THIS EXISTS:
 * When you add spring-boot-starter-security, Spring Security automatically:
 *   - Locks down ALL endpoints
 *   - Shows a login form at /login
 *   - Generates a random password in the console
 *
 * This is great for production, but blocks development.
 * So we override the default to PERMIT ALL requests for now.
 *
 * WHAT WILL CHANGE:
 * In Step 3 (Authentication Module), we will:
 *   1. Lock down most endpoints (require JWT)
 *   2. Allow only /api/auth/** without authentication
 *   3. Add a JWT filter to validate tokens on every request
 *
 * KEY CONCEPTS:
 * - @Configuration  → tells Spring this class defines beans
 * - @EnableWebSecurity → activates Spring Security
 * - SecurityFilterChain → the chain of security filters that every request passes through
 * - SessionCreationPolicy.STATELESS → no HTTP sessions (we'll use JWT instead)
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // Disable CSRF because we're building a stateless REST API.
            // CSRF protection is for browser-based apps with sessions/cookies.
            // Since we'll use JWT tokens (sent in headers), CSRF is not needed.
            .csrf(csrf -> csrf.disable())

            // Allow all requests without authentication (temporary for development)
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            )

            // Use stateless sessions — no session cookies, no server-side sessions.
            // Every request must be independently authenticated (via JWT later).
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );

        return http.build();
    }

}
