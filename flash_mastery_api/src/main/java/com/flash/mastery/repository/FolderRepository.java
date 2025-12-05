package com.flash.mastery.repository;

import com.flash.mastery.entity.Folder;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FolderRepository extends JpaRepository<Folder, UUID> {
  List<Folder> findByParentId(UUID parentId);
  List<Folder> findByParentIsNull();
}
