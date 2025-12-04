package com.flash.mastery.entity;

import java.util.HashSet;
import java.util.Set;

import com.flash.mastery.constant.ValidationConstants;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "decks")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Deck extends BaseAuditEntity {

    @Column(name = "name", nullable = false, length = ValidationConstants.NAME_MAX_LENGTH)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "card_count", nullable = false)
    private int cardCount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "folder_id")
    @ToString.Exclude
    private Folder folder;

    @OneToMany(mappedBy = "deck", fetch = FetchType.LAZY)
    @ToString.Exclude
    @Default
    private Set<Flashcard> flashcards = new HashSet<>();
}
