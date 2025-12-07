package com.flash.mastery.service;

import com.flash.mastery.dto.request.StudySessionCreateRequest;
import com.flash.mastery.dto.request.StudySessionUpdateRequest;
import com.flash.mastery.dto.response.StudySessionResponse;
import java.util.UUID;

public interface StudySessionService {
    StudySessionResponse startSession(StudySessionCreateRequest request);
    StudySessionResponse getSession(UUID sessionId);
    StudySessionResponse updateSession(UUID sessionId, StudySessionUpdateRequest request);
    void completeSession(UUID sessionId);
}

