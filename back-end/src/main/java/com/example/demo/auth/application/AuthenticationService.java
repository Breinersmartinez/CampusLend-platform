package com.example.demo.auth.application;

import com.example.demo.auth.infrastructure.AuthenticationRequest;
import com.example.demo.auth.infrastructure.AuthenticationResponse;
import com.example.demo.config.application.JwtService;
import com.example.demo.exception.domain.NotFoundException;
import com.example.demo.user.domain.Role;
import com.example.demo.user.domain.User;
import com.example.demo.user.domain.UserRepository;
import com.example.demo.user.infrastructure.entity.UserEntity;
import com.example.demo.user.infrastructure.mapper.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UserMapper userMapper;

    public AuthenticationResponse register(User user) {

        if (userRepository.findByEmail(user.getEmail()).isPresent()) throw new NotFoundException("error");

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.USER);

        User saved = userRepository.save(user);
        UserEntity userEntity = userMapper.userToUserEntity(saved);

        String jwtToken = jwtService.generateToken(userEntity);

        return AuthenticationResponse.builder()
                .token(jwtToken)
                .build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) {

        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new NotFoundException("User not found"));

        UserEntity userEntity = userMapper.userToUserEntity(user);

        String jwtToken = jwtService.generateToken(userEntity);

        return AuthenticationResponse.builder()
                .token(jwtToken)
                .build();
    }
}
