package com.example.demo.exception.domain;

public class InvalidTokenException extends BadRequestException {

    private static final String DESCRIPTION = "Token expired";

    public InvalidTokenException(String detail){
        super(DESCRIPTION + ". "+ detail);
    }
}
