# Study Session Status Enum

## Tổng quan

Enum `StudySessionStatus` được sử dụng để đại diện cho các trạng thái của một phiên học tập (study session).

## Frontend Implementation (Flutter/Dart)

### Enum Definition
```dart
enum StudySessionStatus {
  inProgress,  // Đang học
  success,      // Hoàn thành
  cancel,       // Đã hủy
}
```

### JSON Mapping
- `IN_PROGRESS` ↔ `StudySessionStatus.inProgress`
- `SUCCESS` ↔ `StudySessionStatus.success`
- `CANCEL` ↔ `StudySessionStatus.cancel`

### File Location
- Frontend: `lib/domain/entities/study_session_status.dart`

## Backend Implementation (Recommended)

### Java/Kotlin Example
```java
public enum StudySessionStatus {
    IN_PROGRESS,  // Khi session được tạo
    SUCCESS,      // Khi session hoàn thành thành công
    CANCEL        // Khi session bị hủy
}
```

### Database Schema
```sql
CREATE TABLE study_sessions (
    id VARCHAR(255) PRIMARY KEY,
    deck_id VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'IN_PROGRESS',
    -- status có thể là: 'IN_PROGRESS', 'SUCCESS', 'CANCEL'
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CHECK (status IN ('IN_PROGRESS', 'SUCCESS', 'CANCEL'))
);
```

## API Behavior

### 1. Start Session
- **Endpoint**: `POST /api/v1/sessions/start`
- **Request Body**:
  ```json
  {
    "deckId": "string",
    "flashcardIds": ["string"]
  }
  ```
- **Response**: Session object với `status: "IN_PROGRESS"`
- **Backend Action**: Tự động set `status = IN_PROGRESS` khi tạo session

### 2. Complete Session
- **Endpoint**: `POST /api/v1/sessions/{id}/complete`
- **Response**: `204 No Content` hoặc updated session với `status: "SUCCESS"`
- **Backend Action**: Update `status = SUCCESS` và set `completedAt = current timestamp`

### 3. Cancel Session
- **Endpoint**: `POST /api/v1/sessions/{id}/cancel`
- **Response**: `204 No Content` hoặc updated session với `status: "CANCEL"`
- **Backend Action**: Update `status = CANCEL`

### 4. Get Session
- **Endpoint**: `GET /api/v1/sessions/{id}`
- **Response**: Session object với field `status` (IN_PROGRESS, SUCCESS, hoặc CANCEL)

## Status Transitions

```
IN_PROGRESS → SUCCESS  (khi user hoàn thành session)
IN_PROGRESS → CANCEL   (khi user hủy session)
```

**Lưu ý**: Một session không thể chuyển từ SUCCESS hoặc CANCEL sang trạng thái khác.

## Frontend Usage

```dart
// Parse từ JSON response
final status = studySessionStatusFromJson(json['status']);

// Convert sang JSON để gửi API (nếu cần)
final statusJson = status.toJson(); // Returns: "IN_PROGRESS", "SUCCESS", or "CANCEL"

// Display name
final displayName = status.displayName; // Returns: "Đang học", "Hoàn thành", hoặc "Đã hủy"
```

## Validation Rules

1. **IN_PROGRESS**:
   - Session đang được học
   - `completedAt` phải là `null`
   - Có thể chuyển sang SUCCESS hoặc CANCEL

2. **SUCCESS**:
   - Session đã hoàn thành thành công
   - `completedAt` không được là `null`
   - Không thể thay đổi trạng thái

3. **CANCEL**:
   - Session đã bị hủy
   - `completedAt` có thể là `null` hoặc có giá trị (nếu hủy sau khi bắt đầu)
   - Không thể thay đổi trạng thái

## Notes

- Backend nên validate status transitions và reject các transition không hợp lệ
- Frontend sẽ parse status từ API response và sử dụng enum để type-safe
- Enum này đảm bảo consistency giữa frontend và backend

