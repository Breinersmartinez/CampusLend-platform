package com.example.demo.user.application;
import com.example.demo.exception.domain.NotFoundException;
import com.example.demo.user.domain.User;
import com.example.demo.user.domain.UserRepository;
import com.example.demo.user.domain.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public User update(User updateUser){
        User user = userRepository.findById(updateUser.getId()).orElseThrow(() -> new NotFoundException("User not found "));
        BeanUtils.copyProperties(updateUser, user, "role");
        return userRepository.save(user);
    }

    public List<User> findAll(){
        return userRepository.findAll();
    }

    public User findById(UUID id) throws  NotFoundException {
        return userRepository.findById(id).orElseThrow(() -> new NotFoundException("User not found"));
    }
    public void delete(UUID id){
        userRepository.deleteById(id);
    }

}
