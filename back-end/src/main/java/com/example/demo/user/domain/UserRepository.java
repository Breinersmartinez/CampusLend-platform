package com.example.demo.user.domain;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface UserRepository {
    User save(User userEntity);
    Optional<User> findById(UUID id);

    List<User> findAll();

    Optional<User> findByEmail(String email);

    Boolean existByEmail(String email);

    void deleteById(UUID id);



}
