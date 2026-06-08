package com.projeto.fatec.exception;

import org.apache.coyote.BadRequestException;
import org.springframework.http.ResponseEntity;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import jakarta.servlet.http.HttpServletRequest;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // TRATA ERRO POR ENTIDADES NÃO ENCONTRADAS NO BANCO
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex, HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                404,
                "Tem não! º-º",
                ex.getMessage(),
                request.getRequestURI());

        return ResponseEntity.status(404).body(error);
    }

    // TRATA ERRO POR NÃO EXISTIR MAPEAMENTO NO CONTROLLER DA CLASSE
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<ErrorResponse> handleNoHandler(NoHandlerFoundException ex, HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                404,
                "Tem não! º-º",
                ex.getMessage(),
                request.getRequestURI());

        return ResponseEntity.status(404).body(error);
    }

    // TRATA ERRO POR QUEBRA DE REGRA DE NEGOCIO
    @ExceptionHandler(BusinessRuleException.class)
    public ResponseEntity<ErrorResponse> handleBusiness(BusinessRuleException ex, HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                404,
                "Pode não pô",
                ex.getMessage(),
                request.getRequestURI());

        return ResponseEntity.status(422).body(error);
    }

    // TRATA ERRO POR REQUESTS INVALIDAS
    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(BadRequestException ex, HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                400,
                "Bad Request Baby",
                ex.getMessage(),
                request.getRequestURI());

        return ResponseEntity.status(400).body(error);
    }

    // TRATA ERRO POR DADOS INVALIDOS NAS REQUISICOES
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ErrorResponse> handleTypeMismatch(MethodArgumentTypeMismatchException ex,
            HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                400,
                "Bad Request Baby",
                ex.getMessage(),
                request.getRequestURI());

        return ResponseEntity.status(400).body(error);
    }

    // TRATA ERRO POR BODY VAZIO
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleEmptyBody(HttpMessageNotReadableException ex,
            HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                400,
                "Bad Request baby",
                "O corpo da requisição está vazio ou inválido",
                request.getRequestURI());

        return ResponseEntity.status(400).body(error);
    }

    // TRATA ALGUM TIPO DE ERRO QUE EU ESQUECI QUAL É MAS A MENSSAGEM FICOU
    // ENGRAÇADA KKKKKK
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponse> handleDataIntegrityViolation(DataIntegrityViolationException ex,
            HttpServletRequest request) {

        ErrorResponse error = new ErrorResponse(
                409,
                "Virou zona agora?",
                ex.getMessage(),
                request.getRequestURI());

        return ResponseEntity.status(409).body(error);
    }

    // fallback
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGeneric(Exception ex) {
        return ResponseEntity.status(500).body("Erro interno do servidor");
    }
}