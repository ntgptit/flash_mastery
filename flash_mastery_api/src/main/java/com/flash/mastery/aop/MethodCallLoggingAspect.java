//package com.flash.mastery.aop;
//
//import java.util.Arrays;
//import java.util.Objects;
//import java.util.stream.Collectors;
//
//import org.aspectj.lang.ProceedingJoinPoint;
//import org.aspectj.lang.annotation.Around;
//import org.aspectj.lang.annotation.Aspect;
//import org.aspectj.lang.annotation.Pointcut;
//import org.springframework.stereotype.Component;
//
//import lombok.extern.slf4j.Slf4j;
//
///**
// * Logs method entry/exit for controllers, services, and repositories so we can trace
// * when functions are invoked. Enabled when the logger level for this package is DEBUG.
// */
//@Slf4j
//@Aspect
//@Component
//public class MethodCallLoggingAspect {
//
//    @Pointcut("within(@org.springframework.stereotype.Service *) "
//            + "|| within(@org.springframework.web.bind.annotation.RestController *) "
//            + "|| within(@org.springframework.stereotype.Repository *)")
//    public void springBeans() {
//        // Pointcut for Spring stereotypes
//    }
//
//    @Around("springBeans()")
//    public Object logInvocation(ProceedingJoinPoint joinPoint) throws Throwable {
//        if (!log.isDebugEnabled()) {
//            return joinPoint.proceed();
//        }
//
//        final var signature = joinPoint.getSignature();
//        final var className = signature.getDeclaringTypeName();
//        final var methodName = signature.getName();
//        final var args = formatArgs(joinPoint.getArgs());
//
//        log.debug("→ {}.{}({})", className, methodName, args);
//        final var start = System.currentTimeMillis();
//        try {
//            final var result = joinPoint.proceed();
//            final var duration = System.currentTimeMillis() - start;
//            log.debug("← {}.{} [{}ms] -> {}", className, methodName, duration, abbreviate(result));
//            return result;
//        } catch (Throwable ex) {
//            final var duration = System.currentTimeMillis() - start;
//            log.warn("✖ {}.{} [{}ms] threw {}", className, methodName, duration, ex.getMessage(), ex);
//            throw ex;
//        }
//    }
//
//    private String formatArgs(Object[] args) {
//        if (args == null || args.length == 0) {
//            return "";
//        }
//        return Arrays.stream(args)
//                .map(this::safeToString)
//                .collect(Collectors.joining(", "));
//    }
//
//    private String safeToString(Object value) {
//        if (value == null) {
//            return "null";
//        }
//        try {
//            return abbreviate(value);
//        } catch (Exception ex) {
//            return value.getClass().getSimpleName();
//        }
//    }
//
//    private String abbreviate(Object value) {
//        final var text = Objects.toString(value, "null");
//        final int limit = 200;
//        return text.length() > limit ? text.substring(0, limit) + "..." : text;
//    }
//}
