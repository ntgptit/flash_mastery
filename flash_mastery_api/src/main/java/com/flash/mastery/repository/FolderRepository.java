package com.flash.mastery.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.flash.mastery.entity.Folder;

public interface FolderRepository extends JpaRepository<Folder, UUID> {
}
