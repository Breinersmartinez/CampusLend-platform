package com.example.demo.user.infrastructure.dto;

import com.example.demo.user.domain.Role;
import com.example.demo.user.infrastructure.annotation.MaskData;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserDTO {

    private UUID id;
    private String idCard;
    private String firstName;
    private String lastName;

    @MaskData
    private String email;

    @Enumerated(EnumType.STRING)
    private Role role;


}
