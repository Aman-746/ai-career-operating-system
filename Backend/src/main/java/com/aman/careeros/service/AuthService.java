package com.aman.careeros.service;

import com.aman.careeros.dto.AuthResponse;
import com.aman.careeros.dto.UserLoginRequest;
import com.aman.careeros.dto.UserRegisterRequest;
import com.aman.careeros.entity.User;
import com.aman.careeros.exception.ResourceAlreadyExistsException;
import com.aman.careeros.repository.UserRepository;
import com.aman.careeros.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * AuthService - Handles business logic for user authentication and management.
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    /**
     * Registers a new user and returns a JWT token.
     */
    public AuthResponse register(UserRegisterRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new ResourceAlreadyExistsException("Email is already registered");
        }

        User user = User.builder()
                .name(request.getName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .build();

        userRepository.save(user);

        String token = jwtService.generateToken(user);
        return AuthResponse.builder()
                .token(token)
                .email(user.getEmail())
                .name(user.getName())
                .build();
    }

    /**
     * Authenticates a user and returns a JWT token.
     */
    public AuthResponse login(UserLoginRequest request) {
        // This will throw an exception if credentials are wrong
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow();

        String token = jwtService.generateToken(user);

        return AuthResponse.builder()
                .token(token)
                .email(user.getEmail())
                .name(user.getName())
                .build();
    }
}
