package com.aman.careeros.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import java.util.HashMap;
import java.util.Map;

/**
 * GlobalExceptionHandler - Intercepts exceptions thrown by any controller
 * and returns a structured JSON response to the client.
 * 
 * @RestControllerAdvice: Combines @ControllerAdvice and @ResponseBody.
 * It allows handling exceptions across the whole application in one global component.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Handles validation errors (e.g., @NotBlank, @Email in DTOs).
     * Returns a 400 Bad Request with a map of field names and error messages.
     * 
     * @ExceptionHandler: Tells Spring to call this method when 
     * MethodArgumentNotValidException is thrown.
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
    }

    /**
     * Handles our custom ResourceAlreadyExistsException.
     * Returns a 409 Conflict.
     * 
     * @ExceptionHandler: Tells Spring to call this method when 
     * ResourceAlreadyExistsException is thrown.
     */
    @ExceptionHandler(ResourceAlreadyExistsException.class)
    public ResponseEntity<Map<String, String>> handleResourceAlreadyExists(ResourceAlreadyExistsException ex) {
        return new ResponseEntity<>(Map.of("error", ex.getMessage()), HttpStatus.CONFLICT);
    }

    /**
     * Handles our custom ResourceNotFoundException.
     * Returns a 404 Not Found.
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, String>> handleResourceNotFound(ResourceNotFoundException ex) {
        return new ResponseEntity<>(Map.of("error", ex.getMessage()), HttpStatus.NOT_FOUND);
    }

    /**
     * Handles our custom InvalidRequestException.
     * Returns a 400 Bad Request.
     */
    @ExceptionHandler(InvalidRequestException.class)
    public ResponseEntity<Map<String, String>> handleInvalidRequest(InvalidRequestException ex) {
        return new ResponseEntity<>(Map.of("error", ex.getMessage()), HttpStatus.BAD_REQUEST);
    }

    /**
     * Handles file uploads larger than the configured multipart limit
     * (spring.servlet.multipart.max-file-size). Returns a 400 Bad Request
     * instead of letting it fall through as a 500.
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<Map<String, String>> handleMaxUploadSizeExceeded(MaxUploadSizeExceededException ex) {
        return new ResponseEntity<>(Map.of("error", "Resume file must not exceed 5MB"), HttpStatus.BAD_REQUEST);
    }

    /**
     * Catch-all handler for any other RuntimeExceptions.
     * Returns a 500 Internal Server Error.
     * 
     * @ExceptionHandler: Tells Spring to call this method for any generic 
     * RuntimeException that isn't caught by more specific handlers.
     */
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, String>> handleRuntimeExceptions(RuntimeException ex) {
        return new ResponseEntity<>(Map.of("error", ex.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
