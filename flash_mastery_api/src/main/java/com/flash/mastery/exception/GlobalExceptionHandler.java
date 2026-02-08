package com.flash.mastery.exception;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.flash.mastery.constant.ErrorCodes;
import com.flash.mastery.constant.MessageKeys;
import com.flash.mastery.dto.response.ErrorResponse;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestControllerAdvice
@RequiredArgsConstructor
@Slf4j
public class GlobalExceptionHandler {

    private final MessageSource messageSource;

    // ── Business exceptions (custom) ──

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponse> handleBusiness(BusinessException ex, HttpServletRequest request) {
        log.warn("{}: {} [{}]", ex.getClass().getSimpleName(), ex.getMessage(), request.getRequestURI());
        final var body = ErrorResponse.builder()
                .code(ex.getErrorCode())
                .message(getMessage(ex.getMessageKey()))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(ex.getStatus()).body(body);
    }

    // ── Validation exceptions (Spring framework) ──

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex,
            HttpServletRequest request) {
        log.warn("MethodArgumentNotValidException: {} [{}]", ex.getMessage(), request.getRequestURI());
        final Map<String, String> errors = new HashMap<>();
        for (final FieldError error : ex.getBindingResult().getFieldErrors()) {
            errors.put(error.getField(), error.getDefaultMessage());
        }
        final var body = ErrorResponse.builder()
                .code(ErrorCodes.VALIDATION_ERROR)
                .message(getMessage(MessageKeys.ERROR_VALIDATION))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .errors(errors)
                .build();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ErrorResponse> handleConstraintViolation(ConstraintViolationException ex,
            HttpServletRequest request) {
        log.warn("ConstraintViolationException: {} [{}]", ex.getMessage(), request.getRequestURI());
        final Map<String, String> errors = new HashMap<>();
        ex.getConstraintViolations().forEach(violation -> {
            final var path = violation.getPropertyPath().toString();
            final var field = path.contains(".") ? path.substring(path.lastIndexOf('.') + 1) : path;
            errors.put(field, violation.getMessage());
        });
        final var body = ErrorResponse.builder()
                .code(ErrorCodes.VALIDATION_ERROR)
                .message(getMessage(MessageKeys.ERROR_VALIDATION))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .errors(errors)
                .build();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    // ── Bad request exceptions (Spring framework) ──

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleMessageNotReadable(HttpMessageNotReadableException ex,
            HttpServletRequest request) {
        log.warn("HttpMessageNotReadableException: {} [{}]", ex.getMessage(), request.getRequestURI());
        final var body = ErrorResponse.builder()
                .code(ErrorCodes.BAD_REQUEST)
                .message(getMessage(MessageKeys.ERROR_BAD_REQUEST))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ErrorResponse> handleMissingParam(MissingServletRequestParameterException ex,
            HttpServletRequest request) {
        log.warn("MissingServletRequestParameterException: {} [{}]", ex.getMessage(), request.getRequestURI());
        final var body = ErrorResponse.builder()
                .code(ErrorCodes.BAD_REQUEST)
                .message(getMessage(MessageKeys.ERROR_BAD_REQUEST))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    // ── Method not allowed ──

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ErrorResponse> handleMethodNotSupported(HttpRequestMethodNotSupportedException ex,
            HttpServletRequest request) {
        log.warn("HttpRequestMethodNotSupportedException: {} [{}]", ex.getMessage(), request.getRequestURI());
        final var body = ErrorResponse.builder()
                .code(ErrorCodes.METHOD_NOT_ALLOWED)
                .message(getMessage(MessageKeys.ERROR_METHOD_NOT_ALLOWED))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.METHOD_NOT_ALLOWED).body(body);
    }

    // ── Catch-all (never expose internals) ──

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneric(Exception ex, HttpServletRequest request) {
        log.error("Unhandled exception [{}]", request.getRequestURI(), ex);
        final var body = ErrorResponse.builder()
                .code(ErrorCodes.INTERNAL_ERROR)
                .message(getMessage(MessageKeys.ERROR_INTERNAL))
                .path(request.getRequestURI())
                .timestamp(LocalDateTime.now())
                .build();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }

    private String getMessage(String key) {
        return this.messageSource.getMessage(key, null, LocaleContextHolder.getLocale());
    }
}
