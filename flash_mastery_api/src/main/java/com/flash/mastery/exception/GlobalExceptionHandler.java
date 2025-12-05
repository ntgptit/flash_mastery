package com.flash.mastery.exception;

import java.util.HashMap;
import java.util.Map;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.flash.mastery.constant.ErrorCodes;
import com.flash.mastery.constant.MessageKeys;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestControllerAdvice
@RequiredArgsConstructor
@Slf4j
public class GlobalExceptionHandler {

    private static final String ERRORS = "errors";
    private static final String CODE = "code";
    private static final String MESSAGE = "message";
    private final MessageSource messageSource;

    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(NotFoundException ex) {
        log.warn("NotFoundException: {}", ex.getMessage(), ex);
        final Map<String, Object> body = new HashMap<>();
        body.put(CODE, ErrorCodes.NOT_FOUND);
        body.put(MESSAGE, ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(MethodArgumentNotValidException ex) {
        log.warn("ValidationException: {}", ex.getMessage(), ex);
        final Map<String, String> errors = new HashMap<>();
        for (final FieldError error : ex.getBindingResult().getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        final Map<String, Object> body = new HashMap<>();
        body.put(CODE, ErrorCodes.VALIDATION_ERROR);
        body.put(MESSAGE, getMessage(MessageKeys.ERROR_VALIDATION));
        body.put(ERRORS, errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGeneric(Exception ex) {
        log.error("Unhandled exception", ex);
        final Map<String, Object> body = new HashMap<>();
        body.put(CODE, ErrorCodes.INTERNAL_ERROR);
        body.put(MESSAGE, getMessage(MessageKeys.ERROR_INTERNAL));
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }

    private String getMessage(String key) {
        return this.messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
    }
}
