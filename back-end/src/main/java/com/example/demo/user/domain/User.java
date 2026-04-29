package com.example.demo.user.domain;

import jakarta.persistence.CascadeType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class User {
    
    @Id
    private UUID id;

    @Column (name = "card_id")
    private String idCard;

    @Column (name = "firs_name")
    private String firstname;

    @Column (name = "last_name")
    private String lastName;

    @Column (name = "email")
    private String email;

    @Column (name = "password_hash")
    private String password;

    @Column (name = "created_at")
    private Date created_at;

    @Column (name = "update_at")
    private Date update_at;
    
    @ManyToOne(cascade = CascadeType.REMOVE)
    @JoinColumn(name = "role_id", referencedColumnName = "id", nullable = false)
    private Role role;


    // UserDetails methods and other getters/setters
}
