# MyBatis Migration Guide

## Hoàn thành

### 1. Maven Dependencies ✅
- Đã thay thế `spring-boot-starter-data-jpa` bằng `mybatis-spring-boot-starter`
- Đã thay thế `spring-boot-starter-data-jpa-test` bằng `mybatis-spring-boot-starter-test`
- File: [pom.xml](flash_mastery_api/pom.xml)

### 2. Application Properties ✅
- Đã xóa tất cả config JPA/Hibernate
- Đã thêm MyBatis configuration trong:
  - [application-dev.properties](flash_mastery_api/src/main/resources/application-dev.properties)
  - [application-prod.properties](flash_mastery_api/src/main/resources/application-prod.properties)

### 3. Entities (POJOs) ✅
Đã convert tất cả entities thành POJOs bằng cách xóa JPA annotations:
- [BaseAuditEntity.java](flash_mastery_api/src/main/java/com/flash/mastery/entity/BaseAuditEntity.java)
- [Deck.java](flash_mastery_api/src/main/java/com/flash/mastery/entity/Deck.java)
- [Flashcard.java](flash_mastery_api/src/main/java/com/flash/mastery/entity/Flashcard.java)
- [Folder.java](flash_mastery_api/src/main/java/com/flash/mastery/entity/Folder.java)
- [StudySession.java](flash_mastery_api/src/main/java/com/flash/mastery/entity/StudySession.java)

**Thay đổi quan trọng:**
- Thay các foreign key relationships (@ManyToOne, @OneToMany) bằng UUID fields
- Thêm `folderId`, `deckId`, `parentId` fields
- `onCreate()` và `onUpdate()` methods giờ là `public` (phải gọi manually)

### 4. MyBatis Mappers ✅
Đã tạo MyBatis mapper interfaces:
- [DeckRepository.java](flash_mastery_api/src/main/java/com/flash/mastery/repository/DeckRepository.java)
- [FlashcardRepository.java](flash_mastery_api/src/main/java/com/flash/mastery/repository/FlashcardRepository.java)
- [FolderRepository.java](flash_mastery_api/src/main/java/com/flash/mastery/repository/FolderRepository.java)
- [StudySessionRepository.java](flash_mastery_api/src/main/java/com/flash/mastery/repository/StudySessionRepository.java)

### 5. MyBatis XML Mappers ✅
Đã tạo XML mapper files với SQL queries:
- [DeckMapper.xml](flash_mastery_api/src/main/resources/mapper/DeckMapper.xml)
- [FlashcardMapper.xml](flash_mastery_api/src/main/resources/mapper/FlashcardMapper.xml)
- [FolderMapper.xml](flash_mastery_api/src/main/resources/mapper/FolderMapper.xml)
- [StudySessionMapper.xml](flash_mastery_api/src/main/resources/mapper/StudySessionMapper.xml)

### 6. Application Configuration ✅
- Đã thêm `@MapperScan("com.flash.mastery.repository")` vào [FlashMasteryApiApplication.java](flash_mastery_api/src/main/java/com/flash/mastery/FlashMasteryApiApplication.java)

## Cần Hoàn Thành

### Service Layer Implementation ⚠️
Cần update tất cả service implementation files để sử dụng MyBatis mappers thay vì JPA repositories.

**Files cần update:**
- `DeckServiceImpl.java`
- `FlashcardServiceImpl.java`
- `FolderServiceImpl.java`
- `StudySessionServiceImpl.java`

**Các thay đổi cần thiết:**

#### 1. Thay đổi Optional<T> sang null checks
```java
// JPA (cũ)
Optional<Deck> optDeck = deckRepository.findById(id);
Deck deck = optDeck.orElseThrow(() -> new NotFoundException("..."));

// MyBatis (mới)
Deck deck = deckRepository.findById(id);
if (deck == null) {
    throw new NotFoundException("...");
}
```

#### 2. Thay save() bằng insert()/update()
```java
// JPA (cũ)
Deck saved = deckRepository.save(deck);

// MyBatis (mới)
if (deck.getId() == null) {
    deck.onCreate(); // IMPORTANT: gọi manually
    deckRepository.insert(deck);
} else {
    deck.onUpdate(); // IMPORTANT: gọi manually
    deckRepository.update(deck);
}
```

#### 3. Thay delete() bằng deleteById()
```java
// JPA (cũ)
deckRepository.delete(deck);

// MyBatis (mới)
deckRepository.deleteById(deck.getId());
```

#### 4. Xử lý Pagination manually
```java
// JPA (cũ)
Pageable pageable = PageRequest.of(page, size);
Page<Deck> deckPage = deckRepository.findAll(pageable);
List<Deck> decks = deckPage.getContent();

// MyBatis (mới)
int offset = page * size;
int limit = size;
List<Deck> decks = deckRepository.findAll(offset, limit);
long total = deckRepository.count();
```

#### 5. Xử lý Collections (StudySession)
Đối với StudySession, cần handle `flashcardIds` và `progressData` manually:
```java
// Insert
studySession.onCreate();
studySessionRepository.insert(studySession);
if (!studySession.getFlashcardIds().isEmpty()) {
    studySessionRepository.insertFlashcardIds(
        studySession.getId(),
        studySession.getFlashcardIds()
    );
}

// Update
studySession.onUpdate();
studySessionRepository.update(studySession);
studySessionRepository.deleteFlashcardIdsBySessionId(studySession.getId());
if (!studySession.getFlashcardIds().isEmpty()) {
    studySessionRepository.insertFlashcardIds(
        studySession.getId(),
        studySession.getFlashcardIds()
    );
}
```

#### 6. Xử lý Relationships
Relationships không còn được manage tự động bởi JPA. Cần:
- Set foreign key IDs manually (folderId, deckId, etc.)
- Load relationships manually nếu cần

#### 7. Loại bỏ findByCriteria()
Các methods như `findByCriteria()` trong old JPA repositories cần được implement lại:
```java
// DeckRepository cũ có default method findByCriteria()
// Giờ phải implement logic này trong Service layer
```

## Helper Classes Đã Tạo

### Page.java ✅
- [Page.java](flash_mastery_api/src/main/java/com/flash/mastery/util/mybatis/Page.java)
- Simple pagination wrapper để thay thế Spring Data Page<T>

## Các Bước Tiếp Theo

1. **Update DeckServiceImpl**: File phức tạp nhất, có import/export logic
2. **Update FlashcardServiceImpl**: Tương đối đơn giản
3. **Update FolderServiceImpl**: Cần xử lý recursive delete
4. **Update StudySessionServiceImpl**: Cần xử lý collections
5. **Test build**: Run `mvn clean compile` để kiểm tra compile errors
6. **Fix các compile errors** nếu có
7. **Test runtime**: Start application và test các endpoints
8. **Fix các runtime errors** nếu có

## Lưu Ý Quan Trọng

1. **Transaction Management**: `@Transactional` vẫn hoạt động với MyBatis
2. **SQL Logging**: Đã config log4jdbc để log SQL queries
3. **Type Handlers**: MyBatis tự động handle UUID, enums
4. **Cascade Operations**: Không còn cascade tự động, phải handle manually trong service layer
5. **Lazy Loading**: Không còn lazy loading, phải load relationships explicitly khi cần

## Testing Strategy

1. Compile the project: `mvn clean compile`
2. Run tests (nếu có): `mvn test`
3. Start application: `mvn spring-boot:run`
4. Test từng endpoint với Postman/Swagger
5. Monitor logs để catch SQL errors

## Rollback Plan

Nếu cần rollback về JPA:
1. Restore file `pom.xml` từ git
2. Restore các entity files
3. Restore application properties files
4. Delete MyBatis mapper XML files
5. Run `mvn clean install`
