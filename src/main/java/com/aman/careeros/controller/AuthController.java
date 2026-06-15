package com.aman.careeros.controller;

import com.aman.careeros.dto.AuthResponse;
import com.aman.careeros.dto.UserLoginRequest;
import com.aman.careeros.dto.UserRegisterRequest;
import com.aman.careeros.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * AuthController - REST API for authentication (Register / Login).
 * 
 * @RestController: Combines @Controller and @ResponseBody.
 * @RequestMapping("/api/auth"): Base path for all endpoints in this class.
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * POST /api/auth/register
     * 
     * @Valid: Triggers Java Bean Validation on the request body.
     * @RequestBody: Deserializes the incoming JSON into a Java object.
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody UserRegisterRequest request) {
        return ResponseEntity.ok(authService.register(request));
    }

    /**
     * POST /api/auth/login
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody UserLoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

}
