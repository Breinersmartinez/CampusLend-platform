package com.example.demo.user.infrastructure.controller;

import com.example.demo.user.infrastructure.dto.UserDTO;
import org.springframework.http.ResponseEntity;

import java.util.List;
import java.util.UUID;

public interface UserController {

    ResponseEntity<UserDTO> findById(UUID id);

    ResponseEntity<List<UserDTO>> findAll();

    ResponseEntity<UserDTO> update(UserDTO userDTO);

    ResponseEntity<Void> delete(UUID id);
}
