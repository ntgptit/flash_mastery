# Flash Mastery Backend API (Draft)

Spec for the Spring Boot backend used by the app. Base URL: `/api/v1`. JSON UTF-8, ISO8601 UTC.

## Auth

- Recommend Bearer JWT: `Authorization: Bearer <token>`.
- If auth is not required yet, endpoints can stay public for now.

## Error format (example)

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

- `Folder`: `{id, name, description?, color?, deckCount, parentId?, subFolderCount, path[], createdAt, updatedAt}`
- `Deck`: `{id, name, description?, folderId?, cardCount, createdAt, updatedAt}`
- `Flashcard`: `{id, deckId, question, answer, hint?, createdAt, updatedAt}`

## Folders

- `GET /folders?parentId=...` ??`200 [Folder]` (omit parentId to fetch all; set parentId to fetch direct subfolders)
- `GET /folders/{id}` ??`200 Folder` | `404`
- `POST /folders`

  ```json
  {"name":"Common","description":"Desc","color":"#ffaa00","parentId":"parent-folder-uuid"}
  ```

  ??`201 Folder` | `400`
- `PUT /folders/{id}`

  ```json
  {"name":"New","description":"...","color":"#00aaff","parentId":"parent-folder-uuid"}
  ```

  ??`200 Folder` | `400/404`
- `DELETE /folders/{id}` ??`204` | `404`

## Decks

- `GET /decks?folderId=...&q=search` ??`200 [Deck]`
- `GET /decks/{id}` ??`200 Deck` | `404`
- `POST /decks`

  ```json
  {"name":"Passive verbs","description":"...", "folderId":"folder-123"}
  ```

  ??`201 Deck` | `400` | `404 folder`
- `PUT /decks/{id}`

  ```json
  {"name":"Updated","description":"...", "folderId":"folder-456"}
  ```

  ??`200 Deck` | `400/404`
- `DELETE /decks/{id}` ??`204` | `404`

## Flashcards

- `GET /decks/{deckId}/cards` ??`200 [Flashcard]` | `404 deck`
- `GET /cards/{id}` ??`200 Flashcard` | `404`
- `POST /decks/{deckId}/cards`

  ```json
  {"question":"Q1","answer":"A1","hint":"H1"}
  ```

  ??`201 Flashcard` | `400/404 deck`
- `PUT /cards/{id}`

  ```json
  {"question":"Q2","answer":"A2","hint":"H2"}
  ```

  ??`200 Flashcard` | `400/404`
- `DELETE /cards/{id}` ??`204` | `404`

## Validation hints

- Folder: name required, min/max (AppConstants), description max, optional parentId must exist.
- Deck: name required, min/max; description max; folderId must exist.
- Flashcard: question/answer required; length respect max; hint optional; deckId must exist.

## Status codes

- 200 OK, 201 Created, 204 No Content
- 400 Validation, 401/403 Auth, 404 Not found, 500 Server error

## Sync

- App uses Drift local; reuse backend UUIDs to avoid collisions.
- `updatedAt` helps two-way sync later if needed.
