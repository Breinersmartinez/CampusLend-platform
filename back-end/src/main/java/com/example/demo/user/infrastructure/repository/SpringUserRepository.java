package com.example.demo.user.infrastructure.repository;

import com.example.demo.user.infrastructure.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface SpringUserRepository extends JpaRepository<UserEntity, UUID> {

    Boolean existsByEmail(String email);

    Optional<UserEntity> findByEmail(String email);
}
