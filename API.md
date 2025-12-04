# Flash Mastery Backend API (Draft)

Spec cho Spring Boot backend kết nối với app hiện tại. Base URL: `/api/v1`. JSON UTF-8, ISO8601 UTC.

## Auth
- Khuyến nghị Bearer JWT: `Authorization: Bearer <token>`.
- Nếu chưa cần, có thể tạm mở public.

## Error format (gợi ý)
```json
{
  "code": "VALIDATION_ERROR",
  "message": "Deck name required",
  "errors": {
    "name": "Too short"
  }
}
```

## Entities
- `Folder`: `{id, name, description?, color?, deckCount, createdAt, updatedAt}`
- `Deck`: `{id, name, description?, folderId?, cardCount, createdAt, updatedAt}`
- `Flashcard`: `{id, deckId, question, answer, hint?, createdAt, updatedAt}`

## Folders
- `GET /folders?q=search` → `200 [Folder]`
- `GET /folders/{id}` → `200 Folder` | `404`
- `POST /folders`
  ```json
  {"name":"Common","description":"Desc","color":"#ffaa00"}
  ```
  → `201 Folder` | `400`
- `PATCH /folders/{id}`
  ```json
  {"name":"New","description":"...","color":"#00aaff"}
  ```
  → `200 Folder` | `400/404`
- `DELETE /folders/{id}` → `204` | `404`

## Decks
- `GET /decks?folderId=...&q=search` → `200 [Deck]`
- `GET /decks/{id}` → `200 Deck` | `404`
- `POST /decks`
  ```json
  {"name":"Passive verbs","description":"...", "folderId":"folder-123"}
  ```
  → `201 Deck` | `400` | `404 folder`
- `PATCH /decks/{id}`
  ```json
  {"name":"Updated","description":"...", "folderId":"folder-456"}
  ```
  → `200 Deck` | `400/404`
- `DELETE /decks/{id}` → `204` | `404`

## Flashcards
- `GET /decks/{deckId}/cards?q=search` → `200 [Flashcard]` | `404 deck`
- `GET /cards/{id}` → `200 Flashcard` | `404`
- `POST /decks/{deckId}/cards`
  ```json
  {"question":"Q1","answer":"A1","hint":"H1"}
  ```
  → `201 Flashcard` | `400/404 deck`
- `PATCH /cards/{id}`
  ```json
  {"question":"Q2","answer":"A2","hint":"H2"}
  ```
  → `200 Flashcard` | `400/404`
- `DELETE /cards/{id}` → `204` | `404`

## Validation gợi ý (khớp app)
- Folder: name required, min/max (AppConstants), description max.
- Deck: name required, min/max; description max; folderId phải tồn tại.
- Flashcard: question/answer required; length ≤ max; hint optional; deckId phải tồn tại.

## Status codes
- 200 OK, 201 Created, 204 No Content
- 400 Validation, 401/403 Auth, 404 Not found, 500 Server error

## Đồng bộ
- App dùng Drift local; nên dùng id từ backend (UUID) để tránh trùng.
- Có `updatedAt` để hỗ trợ sync hai chiều nếu cần sau này.
