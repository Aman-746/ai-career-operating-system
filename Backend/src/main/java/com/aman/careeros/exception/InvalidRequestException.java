package com.aman.careeros.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Custom exception for requests that are well-formed but violate a business
 * rule (e.g. uploading a resume before the onboarding profile exists, or an
 * unsupported file type).
 *
 * @ResponseStatus: Automatically maps this exception to a specific HTTP
 * status code (400 BAD REQUEST) whenever it is thrown.
 */
@ResponseStatus(HttpStatus.BAD_REQUEST)
public class InvalidRequestException extends RuntimeException {
    public InvalidRequestException(String message) {
        super(message);
    }
}
