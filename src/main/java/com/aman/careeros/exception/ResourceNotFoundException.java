package com.aman.careeros.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Custom exception for when a requested resource (e.g. an onboarding profile
 * or resume that hasn't been created yet) cannot be found.
 *
 * @ResponseStatus: Automatically maps this exception to a specific HTTP
 * status code (404 NOT FOUND) whenever it is thrown.
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
