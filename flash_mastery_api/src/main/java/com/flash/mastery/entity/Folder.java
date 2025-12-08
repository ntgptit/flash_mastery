package com.flash.mastery.entity;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Folder extends BaseAuditEntity {

  private String name;
  private String description;
  private String color;
  private int deckCount;

  private UUID parentId;

  @ToString.Exclude
  private Folder parent;

  @ToString.Exclude
  @Default
  private Set<Deck> decks = new HashSet<>();

  @ToString.Exclude
  @Default
  private Set<Folder> children = new HashSet<>();
}
