package com.aman.careeros;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Entry point of the AI Career Operating System.
 *
 * @SpringBootApplication is a convenience annotation that combines:
 *   - @Configuration    → marks this class as a source of bean definitions
 *   - @EnableAutoConfiguration → tells Spring Boot to auto-configure beans
 *                                 based on dependencies in pom.xml
 *   - @ComponentScan    → scans this package and sub-packages for
 *                          @Component, @Service, @Repository, @Controller
 *
 * When you run this class, Spring Boot:
 *   1. Starts an embedded Tomcat server
 *   2. Connects to PostgreSQL using application.yml config
 *   3. Scans for all your controllers, services, and repositories
 *   4. Makes the app ready to accept HTTP requests
 */
@SpringBootApplication
public class CareerOsApplication {

    public static void main(String[] args) {
        SpringApplication.run(CareerOsApplication.class, args);
    }

}
