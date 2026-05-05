package com.example.demo.user.domain;

import java.util.List;
import java.util.UUID;

public interface UserService {
    User update(User user);

    List<User> findAll();

    User findById(UUID id);

    Void delete(UUID id);

}
