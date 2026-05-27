package com.example.demo.user.infrastructure.mapper;


import com.example.demo.auth.infrastructure.RegisterRequest;
import com.example.demo.user.domain.User;
import com.example.demo.user.infrastructure.dto.UserDTO;
import com.example.demo.user.infrastructure.entity.UserEntity;
import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface UserMapper {

    User userEntityToUser(UserEntity userEntity);

    UserEntity userToUserEntity(User user);

    UserDTO userToUserDTO(User user);

    User userDTOTOUser(UserDTO userDTO);

    User registerRequestToUser(RegisterRequest registerRequest);
}
