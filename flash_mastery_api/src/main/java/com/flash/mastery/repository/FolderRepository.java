package com.flash.mastery.repository;

import com.flash.mastery.entity.Folder;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FolderRepository extends JpaRepository<Folder, UUID> {
}
