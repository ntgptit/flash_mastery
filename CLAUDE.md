# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flash Mastery is a flashcard learning app with spaced repetition. It's a **monorepo** with two projects:
- **Flutter frontend** (root `/`) — Clean Architecture + Riverpod + Drift (local SQLite)
- **Spring Boot API backend** (`/flash_mastery_api/`) — JPA + PostgreSQL + Flyway migrations

## Common Commands

### Flutter (frontend, from root)
```bash
# Install dependencies
flutter pub get

# Run code generation (one-time)
dart run build_runner build --delete-conflicting-outputs

# Run code generation (watch mode, use on Windows to avoid FS watcher crashes)
dart run build_runner watch --delete-conflicting-outputs --use-polling-watcher
# Or: tool\build_runner_watch.bat

# Run the app
flutter run

# Run tests
flutter test
# Single test file:
flutter test test/path/to/test_file.dart

# Analyze
flutter analyze
```

### Spring Boot API (from `/flash_mastery_api/`)
```bash
# Build & run
./mvnw spring-boot:run

# Run tests (uses H2 in-memory DB via test profile)
./mvnw test
# Single test class:
./mvnw test -Dtest=ClassName

# Flyway migrations
./mvnw flyway:migrate
./mvnw flyway:info

# Reset database (dev only)
scripts\reset-database.bat [user] [password]
```

## Architecture

### Flutter Frontend

**Clean Architecture layers** (dependency flows inward):
- **Presentation** (`lib/presentation/`) — Screens, widgets, ViewModels (Riverpod StateNotifier with Freezed states), providers
- **Domain** (`lib/domain/`) — Entities (with Equatable), repository interfaces, use cases
- **Data** (`lib/data/`) — Models (Freezed + json_serializable), repository implementations, remote data sources (Retrofit/Dio), local data sources (Drift SQLite)
- **Core** (`lib/core/`) — Dio client with interceptor chain, go_router config, Riverpod core providers, theme, error handling (dartz Either pattern)

**Key patterns:**
- **Code generation is mandatory**: Freezed for data classes/states, riverpod_generator for providers, json_serializable for models, Drift for local DB, Retrofit for API clients. Always run `build_runner` after modifying annotated files.
- **Dio interceptor chain** (order matters): Connectivity → Cache → Auth → Logging → Error → Retry
- **ViewModels** use Freezed union types for state (Initial/Loading/Success/Error pattern) with pagination support
- **Router**: go_router with StatefulShellRoute for bottom navigation tab preservation. Routes defined in `lib/core/router/app_router.dart`.
- **Local database**: Drift with 3 tables (Folders, Decks, Flashcards), schema version 4 with migration strategy in `lib/data/local/app_database.dart`

**Feature domains**: folders, decks, flashcards, study sessions (with 5 study modes: OVERVIEW, MATCHING, GUESS, RECALL, FILL_IN_BLANK)

### Spring Boot Backend

**Package structure** (`com.flash.mastery`): controller → service/impl → repository → entity

**Entity model hierarchy:**
- `BaseAuditEntity` (UUID PK, timestamps) → `Folder` (self-referencing tree) → `Deck` → `Flashcard`
- `StudySession` (tracks mode progression, batch index, flashcard IDs) → `StudySessionProgress` (per-flashcard completion flags for each study mode)

**Key details:**
- REST API at `/api/v1/` with OpenAPI/Swagger docs
- MapStruct for entity↔DTO mapping (annotation processor order: MapStruct → Lombok → lombok-mapstruct-binding)
- Flyway manages PostgreSQL schema `flash_mastery` (6 migrations in `src/main/resources/db/migration/`)
- Profiles: `dev` (PostgreSQL localhost:5432), `test` (H2 in-memory, Flyway disabled), `prod` (env vars for DB config)
- Import support for CSV and Excel via Apache Commons CSV and POI

## Lint / Analysis

Flutter: `analysis_options.yaml` extends `package:flutter_lints/flutter.yaml`. Key enabled rules: `always_use_package_imports`, `prefer_final_locals`, `prefer_final_fields`. Disabled: `unawaited_futures`.

## API Configuration

Frontend API base URL is in `lib/core/constants/config/api_constants.dart`. Backend dev defaults to `localhost:8080`.

## Study Session Status Flow

`IN_PROGRESS → SUCCESS` (completed) or `IN_PROGRESS → CANCEL` (cancelled). Transitions are one-way; terminal states cannot change.
