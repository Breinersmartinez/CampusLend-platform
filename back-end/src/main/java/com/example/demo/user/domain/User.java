package com.example.demo.user.domain;

import jakarta.persistence.CascadeType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.*;

import java.util.Date;
import java.util.UUID;

@Data
@Builder
public class User {

    private UUID id;
    private String idCard;
    private String firstname;
    private String lastName;
    private String email;
    private String password;
    private Role role;
    private Date created_at;
    private Date updated_at;

    // UserDetails methods and other getters/setters
}
