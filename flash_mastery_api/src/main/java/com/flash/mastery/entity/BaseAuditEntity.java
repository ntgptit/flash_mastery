package com.flash.mastery.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

/**
 * Base audit entity with UUID primary key and timestamps.
 */
@Getter
@Setter
public abstract class BaseAuditEntity {

    private UUID id;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

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
    }

    /**
     * Update timestamp before update.
     */
    public void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
