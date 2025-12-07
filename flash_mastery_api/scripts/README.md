# Database Migration Scripts

Scripts để quản lý Flyway database migrations.

## Scripts

### reset-database.sh / reset-database.bat

Script để clean và reset toàn bộ database, sau đó chạy lại tất cả migrations từ đầu.

**Usage:**

```bash
# Linux/Mac
./scripts/reset-database.sh [user] [password]

# Windows
scripts\reset-database.bat [user] [password]
```

**Ví dụ:**

```bash
# Sử dụng credentials mặc định (giapnt/abcd1234)
./scripts/reset-database.sh

# Sử dụng credentials tùy chỉnh
./scripts/reset-database.sh myuser mypassword
```

## Manual Commands

### Clean Database

Xóa toàn bộ objects trong database:

```bash
cd flash_mastery_api
mvn flyway:clean -Dflyway.user=giapnt -Dflyway.password=abcd1234
```

### Run Migrations

Chạy tất cả migrations chưa được áp dụng:

```bash
cd flash_mastery_api
mvn flyway:migrate -Dflyway.user=giapnt -Dflyway.password=abcd1234
```

### Check Migration Status

Kiểm tra trạng thái migrations:

```bash
cd flash_mastery_api
mvn flyway:info -Dflyway.user=giapnt -Dflyway.password=abcd1234
```

### Repair Migrations

Sửa checksum mismatch (nếu có):

```bash
cd flash_mastery_api
mvn flyway:repair -Dflyway.user=giapnt -Dflyway.password=abcd1234
```

## Migration Files

Tất cả migration files nằm trong `src/main/resources/db/migration/`:

- `V1__create_folders_table.sql` - Tạo bảng folders
- `V2__create_decks_and_flashcards_tables.sql` - Tạo bảng decks và flashcards
- `V3__create_study_sessions_table.sql` - Tạo bảng study_sessions (bao gồm status column)

## Lưu ý

⚠️ **CẢNH BÁO:** Script `reset-database` sẽ **XÓA TOÀN BỘ DỮ LIỆU** trong database. Chỉ sử dụng trong môi trường development hoặc khi bạn chắc chắn muốn reset database.

