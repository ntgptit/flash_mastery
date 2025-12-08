package com.flash.mastery.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

/**
 * Base audit entity with UUID primary key, timestamps, and soft delete support.
 */
@Getter
@Setter
public abstract class BaseAuditEntity {

    private UUID id;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    /**
     * Initialize entity before insert.
     */
    public void onCreate() {
        if (this.id == null) {
            this.id = UUID.randomUUID();
        }
        final var now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
        this.deletedAt = null;
    }

    /**
     * Update timestamp before update.
     */
    public void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Soft delete the entity by setting deletedAt timestamp.
     */
    public void onDelete() {
        this.deletedAt = LocalDateTime.now();
        this.updatedAt = this.deletedAt;
    }

    /**
     * Check if entity is deleted (soft delete).
     */
    public boolean isDeleted() {
        return this.deletedAt != null;
    }
}
