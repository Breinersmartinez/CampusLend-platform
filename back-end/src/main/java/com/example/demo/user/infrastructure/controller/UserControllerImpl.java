package com.example.demo.user.infrastructure.controller;
import com.example.demo.exception.domain.NotFoundException;
import com.example.demo.user.domain.User;
import com.example.demo.user.domain.UserService;
import com.example.demo.user.infrastructure.dto.UserDTO;
import com.example.demo.user.infrastructure.mapper.UserMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@SecurityRequirement(name = "Bearer Authentication")
@Tag(name = "User", description = "The User API. Contains all the operations that can be performed on a user.")
@RequiredArgsConstructor
public class UserControllerImpl implements UserController {
    private final UserService userService;
    private final UserMapper userMapper;

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> findById(@PathVariable UUID id)  throws NotFoundException {
        User user = userService.findById(id);
        UserDTO userDTO = userMapper.userToUserDTO(user);
        return  ResponseEntity.ok(userDTO);
    }

    @Operation(summary = "List all users", description = "List all users")
    @GetMapping()
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<List<UserDTO>> findAll(){
        List<UserDTO> userDTOS = userService.findAll().stream().map(userMapper::userToUserDTO).toList();
        return ResponseEntity.ok(userDTOS);
    }

    @PutMapping
    public ResponseEntity<UserDTO> update(@RequestBody UserDTO userDTO){
        User user = userMapper.userDTOTOUser(userDTO);
        User updated = userService.update(user);
        UserDTO updatedDTO = userMapper.userToUserDTO(updated);
        return ResponseEntity.ok(updatedDTO);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id){
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
