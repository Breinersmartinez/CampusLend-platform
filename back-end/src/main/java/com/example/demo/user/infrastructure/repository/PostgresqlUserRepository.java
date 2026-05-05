package com.example.demo.user.infrastructure.repository;

import com.example.demo.user.domain.User;
import com.example.demo.user.domain.UserRepository;
import com.example.demo.user.infrastructure.entity.UserEntity;
import com.example.demo.user.infrastructure.mapper.UserMapper;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
@RequiredArgsConstructor
public class PostgresqlUserRepository implements UserRepository {

    private final SpringUserRepository springUserRepository;
    private final UserMapper userMapper;

    @Override
    public User save(User userEntity){
        UserEntity entity = userMapper.userToUserEntity(userEntity);
        UserEntity saved = springUserRepository.save(entity);
        return userMapper.userEntityToUser(saved);
    }

    @Override
    public Optional<User> findById(UUID id){
        return springUserRepository.findById(id).map(userMapper::userEntityToUser);
    }

    @Override
    public List<User> findAll(){
        return springUserRepository.findAll().stream().map(userMapper::userEntityToUser).toList();
    }

    @Transactional
    @Override
    public Optional<User> findByEmail(String email){
        return springUserRepository.findByEmail(email).map(userMapper::userEntityToUser);
    }

    @Override
    public Boolean existByEmail(String email){
        return springUserRepository.existsByEmail(email);
    }

    @Override
    public void deleteById(UUID id){
         springUserRepository.deleteById(id);
    }
}
