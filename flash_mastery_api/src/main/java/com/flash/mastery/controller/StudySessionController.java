package com.flash.mastery.controller;

import com.flash.mastery.dto.request.StudySessionCreateRequest;
import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import com.flash.mastery.service.StudySessionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/sessions")
@RequiredArgsConstructor
@Tag(name = "Study Sessions", description = "Manage study sessions")
public class StudySessionController {

    private final StudySessionService studySessionService;

    @PostMapping("/start")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(
            summary = "Start a new study session",
            responses = @ApiResponse(responseCode = "201", description = "Study session started"))
    public StudySessionResponse startSession(@Valid @RequestBody StudySessionCreateRequest request) {
        return studySessionService.startSession(request);
    }

    @GetMapping("/{id}")
    @Operation(
            summary = "Get study session detail",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Study session found"),
                    @ApiResponse(responseCode = "404", description = "Study session not found", content = @Content(schema = @Schema(hidden = true)))
            })
    public StudySessionResponse getSession(@PathVariable UUID id) {
        return studySessionService.getSession(id);
    }

    @PutMapping("/{id}")
    @Operation(
            summary = "Update study session",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Study session updated"),
                    @ApiResponse(responseCode = "404", description = "Study session not found", content = @Content(schema = @Schema(hidden = true)))
            })
    public StudySessionResponse updateSession(
            @PathVariable UUID id,
            @Valid @RequestBody StudySessionUpdateRequest request) {
        return studySessionService.updateSession(id, request);
    }
}

