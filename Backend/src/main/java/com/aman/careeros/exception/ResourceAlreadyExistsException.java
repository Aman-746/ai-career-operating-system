package com.aman.careeros.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Custom exception for when a resource (like a User with a specific email) 
 * already exists in the system.
 * 
 * @ResponseStatus: Automatically maps this exception to a specific HTTP 
 * status code (409 CONFLICT) whenever it is thrown.
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class ResourceAlreadyExistsException extends RuntimeException {
    public ResourceAlreadyExistsException(String message) {
        super(message);
    }
}
