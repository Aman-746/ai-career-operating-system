package com.aman.careeros;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * Smoke test — verifies the Spring application context loads successfully.
 *
 * WHAT THIS TEST DOES:
 * - @SpringBootTest starts the full Spring context (like running the app)
 * - If any bean fails to create, any config is wrong, or any dependency
 *   is missing, this test will FAIL
 * - The empty @Test method is intentional — just loading the context IS the test
 *
 * HOW TO RUN:
 *   mvn test
 *   (or click the green play button in your IDE)
 *
 * NOTE: This test requires a running PostgreSQL database because
 * Spring Data JPA will try to connect on startup. If you want to run
 * tests without a database, you can use an H2 in-memory database
 * for tests (we may add this later).
 */
@SpringBootTest
class CareerOsApplicationTests {

    @Test
    void contextLoads() {
        // If we get here without an exception, the Spring context loaded successfully
    }

}
