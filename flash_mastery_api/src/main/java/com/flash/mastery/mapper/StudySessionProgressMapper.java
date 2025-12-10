package com.flash.mastery.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import com.flash.mastery.dto.request.StudySessionProgressUpdate;
import com.flash.mastery.dto.response.StudySessionProgressResponse;
import com.flash.mastery.entity.StudySessionProgress;

/**
 * MapStruct mapper for StudySessionProgress entity and DTOs.
 */
@Mapper(componentModel = "spring")
public interface StudySessionProgressMapper {

    /**
     * Convert entity to response DTO.
     * Calculates accuracy field from correctAnswers/totalAttempts.
     */
    @Mapping(target = "accuracy", expression = "java(calculateAccuracy(progress))")
    StudySessionProgressResponse toResponse(StudySessionProgress progress);

    /**
     * Convert list of entities to list of response DTOs.
     */
    List<StudySessionProgressResponse> toResponseList(List<StudySessionProgress> progressList);

    /**
     * Convert update DTO to entity.
     * SessionId and audit fields are set by service layer.
     */
    @Mapping(target = "sessionId", ignore = true)
    StudySessionProgress toEntity(StudySessionProgressUpdate update);

    /**
     * Convert list of update DTOs to list of entities.
     */
    List<StudySessionProgress> toEntityList(List<StudySessionProgressUpdate> updates);

    /**
     * Calculate accuracy as percentage (0.0 to 1.0).
     *
     * @param progress the progress entity
     * @return accuracy ratio, or 0.0 if no attempts
     */
    default Double calculateAccuracy(final StudySessionProgress progress) {
        if ((progress.getTotalAttempts() == null) || (progress.getTotalAttempts() == 0)) {
            return 0.0;
        }
        return (double) progress.getCorrectAnswers() / progress.getTotalAttempts();
    }
}
