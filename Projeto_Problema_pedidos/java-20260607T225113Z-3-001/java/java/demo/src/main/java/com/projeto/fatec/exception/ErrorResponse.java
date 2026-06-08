package com.projeto.fatec.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Getter
@Setter
public class ErrorResponse {

    private Integer status;
    private String error;
    private String message;
    private String path;
}
