package com.flash.mastery.entity;

import com.flash.mastery.constant.ValidationConstants;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.HashSet;
import java.util.Set;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "folders")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Folder extends BaseAuditEntity {

  @Column(name = "name", nullable = false, length = ValidationConstants.NAME_MAX_LENGTH)
  private String name;

  @Column(name = "description")
  private String description;

  @Column(name = "color", length = ValidationConstants.COLOR_MAX_LENGTH)
  private String color;

  @Column(name = "deck_count", nullable = false)
  private int deckCount;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "parent_id")
  @ToString.Exclude
  private Folder parent;

  @OneToMany(mappedBy = "folder", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
  @ToString.Exclude
  @Default
  private Set<Deck> decks = new HashSet<>();

  @OneToMany(mappedBy = "parent", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
  @ToString.Exclude
  @Default
  private Set<Folder> children = new HashSet<>();
}
