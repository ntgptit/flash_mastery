# STUDY IMPLEMENTATION CHECKLIST

> **Flash Mastery - Study & Test Features Implementation Guide**
>
> Checklist đầy đủ cho việc phát triển tính năng Study và Test với thuật toán 7 ô và 4 chế độ học tuần tự.

---

## 📋 MỤC LỤC

- [Phase 1: Foundation & Data Layer](#phase-1-foundation--data-layer)
- [Phase 2: Settings Use Cases](#phase-2-settings-use-cases)
- [Phase 3: Settings UI](#phase-3-settings-ui)
- [Phase 4: Study Modes Architecture (Factory Pattern)](#phase-4-study-modes-architecture-factory-pattern)
- [Phase 5: Study Session Management](#phase-5-study-session-management)
- [Phase 6: Study Flow Integration](#phase-6-study-flow-integration)
- [Phase 7: Study Session Analytics](#phase-7-study-session-analytics)
- [Phase 8: Test Mode Implementation](#phase-8-test-mode-implementation)
- [Phase 9: Polish & Optimization](#phase-9-polish--optimization)
- [Phase 10: Advanced Features (Optional)](#phase-10-advanced-features-optional)
- [Priority Matrix](#-priority-matrix)
- [Timeline](#-estimated-timeline)

---

## Phase 1: Foundation & Data Layer

### 1.1. Core Entities & Enums

- [ ] Define `PenaltyStrategy` enum (resetToBox1, decreaseByOne, decreaseByTwo, stayInCurrentBox, adaptive)
- [ ] Define `ReviewOrder` enum (lowestBoxFirst, oldestFirst, random, mixedPriority)
- [ ] Define `SettingsSource` enum (global, deck, mixed)
- [ ] Define `StudyModeType` enum (matching, multipleChoice, recall, written)
- [ ] Define `RecallConfidence` enum (again, hard, good, easy)
- [ ] Create `GlobalStudySettings` entity
- [ ] Create `DeckStudySettings` entity
- [ ] Create `EffectiveStudySettings` entity with merge logic
- [ ] Create `FlashcardStudyProgress` entity
- [ ] Create `ModeResult` entity
- [ ] Create `StudySession` entity

### 1.2. Database Models

- [ ] Update `Flashcard` model: add `boxNumber` field
- [ ] Update `Flashcard` model: add `nextReviewDate` field
- [ ] Create `GlobalStudySettingsModel` (Isar/SQLite)
- [ ] Create `DeckStudySettingsModel` (Isar/SQLite)
- [ ] Create `StudySessionModel` (Isar/SQLite)
- [ ] Create `FlashcardStudyProgressModel` (Isar/SQLite)
- [ ] Create `ModeResultModel` (Isar/SQLite)
- [ ] Write migration script for Flashcard table updates
- [ ] Create default values factory (`DefaultStudySettings`)

### 1.3. Repositories

- [ ] Create `GlobalStudySettingsRepository` interface
- [ ] Implement `GlobalStudySettingsRepositoryImpl`
- [ ] Create `DeckStudySettingsRepository` interface
- [ ] Implement `DeckStudySettingsRepositoryImpl`
- [ ] Create `StudySessionRepository` interface
- [ ] Implement `StudySessionRepositoryImpl`
- [ ] Add CRUD methods for all repositories
- [ ] Add error handling for repositories

---

## Phase 2: Settings Use Cases

### 2.1. Global Settings Use Cases

- [ ] Create `GetGlobalStudySettingsUseCase`
- [ ] Create `UpdateGlobalStudySettingsUseCase`
- [ ] Create `ResetGlobalStudySettingsUseCase`

### 2.2. Deck Settings Use Cases

- [ ] Create `GetDeckStudySettingsUseCase`
- [ ] Create `SaveDeckStudySettingsUseCase`
- [ ] Create `DeleteDeckStudySettingsUseCase`
- [ ] Create `ResetDeckToGlobalSettingsUseCase`

### 2.3. Effective Settings Use Cases

- [ ] Create `GetEffectiveStudySettingsUseCase`
- [ ] Implement merge logic (deck > global priority)
- [ ] Write unit tests for merge logic
- [ ] Test edge cases (null deck settings, partial overrides)

---

## Phase 3: Settings UI

### 3.1. Global Settings Screen

- [ ] Create `GlobalSettingsScreen` widget
- [ ] Penalty strategy selector UI
- [ ] Daily goal input field
- [ ] Review order selector
- [ ] UI/UX toggles (sound, vibration, progress bar, etc.)
- [ ] Box interval configuration UI (advanced)
- [ ] Reset to default button with confirmation dialog
- [ ] Save button with validation
- [ ] Loading & error states

### 3.2. Deck Settings Screen

- [ ] Create `DeckSettingsScreen` widget
- [ ] "Use Global Settings" toggle
- [ ] Custom settings form (shows when toggle off)
- [ ] Display global values as hints/placeholders
- [ ] Individual field override indicators
- [ ] Save button
- [ ] "Reset to Global" button with confirmation
- [ ] Visual feedback for changed fields

### 3.3. Settings Integration

- [ ] Add settings entry point in Deck Detail screen
- [ ] Show settings indicator in Deck List (badge for custom settings)
- [ ] Display effective settings summary in Study screen
- [ ] Settings deep linking support

### 3.4. Settings Presets (Optional)

- [ ] Create 3 preset configurations (Chuyên sâu, Cân bằng, Thoải mái)
- [ ] Preset selector UI
- [ ] Apply preset to global settings
- [ ] Apply preset to deck settings

---

## Phase 4: Study Modes Architecture (Factory Pattern)

### 4.1. Abstract Base & Factory

- [ ] Create abstract `StudyMode` base class
  - [ ] Define `checkAnswer()` method
  - [ ] Define `generateOptions()` method
  - [ ] Define `buildModeWidget()` method
  - [ ] Define `getInstructions()` method
  - [ ] Define common properties (id, name, description, icon, order)
- [ ] Create `StudyModeFactory` class
  - [ ] Implement `createMode(StudyModeType)` method
  - [ ] Implement `getAllModes()` method
  - [ ] Implement `getNextMode(currentType)` method
  - [ ] Implement `getPreviousMode(currentType)` method

### 4.2. Mode 1: Matching (Ghép đôi)

- [ ] Create `MatchingStudyMode` class extending `StudyMode`
- [ ] Implement `generateOptions()` - create matching pairs
  - [ ] Select 3-5 other flashcards from deck
  - [ ] Shuffle questions and answers separately
  - [ ] Return `List<MatchingPair>`
- [ ] Implement `checkAnswer()` - verify all pairs matched correctly
- [ ] Create `MatchingModeWidget` UI
  - [ ] Drag & drop interface (left: questions, right: answers)
  - [ ] Visual connection lines when matched
  - [ ] Unmatched state highlighting
  - [ ] Submit button (enabled when all matched)
- [ ] Add animations (drag, drop, correct/incorrect feedback)
- [ ] Handle edge case: deck has < 4 cards

### 4.3. Mode 2: Multiple Choice (Đoán)

- [ ] Create `MultipleChoiceStudyMode` class extending `StudyMode`
- [ ] Implement `generateOptions()` - create 4 options
  - [ ] 1 correct answer
  - [ ] 3 wrong answers from other flashcards
  - [ ] Shuffle order
  - [ ] Handle duplicates
- [ ] Implement `checkAnswer()` - simple equality check
- [ ] Create `MultipleChoiceModeWidget` UI
  - [ ] Display question prominently
  - [ ] 4 option buttons (A/B/C/D style)
  - [ ] Selection highlighting
  - [ ] Submit button
  - [ ] Instant feedback (correct/incorrect)
- [ ] Add hint button (optional, with delay)
- [ ] Handle edge case: not enough unique answers in deck

### 4.4. Mode 3: Recall (Nhớ lại)

- [ ] Create `RecallStudyMode` class extending `StudyMode`
- [ ] Implement `checkAnswer()` - good/easy = pass
- [ ] Create `RecallModeWidget` UI
  - [ ] Flip card animation (3D flip effect)
  - [ ] Front: show question only
  - [ ] Back: show answer
  - [ ] "Show Answer" button
  - [ ] Self-assessment buttons (Again/Hard/Good/Easy)
  - [ ] Each button shows next review interval
- [ ] Add keyboard shortcuts (spacebar to flip)
- [ ] Auto-play pronunciation if available (TTS integration)

### 4.5. Mode 4: Written (Điền tự luận)

- [ ] Create `WrittenStudyMode` class extending `StudyMode`
- [ ] Implement fuzzy matching algorithm
  - [ ] Levenshtein distance calculation
  - [ ] Similarity threshold (85% default, configurable)
  - [ ] Case-insensitive comparison
  - [ ] Trim whitespace
- [ ] Implement `checkAnswer()` with fuzzy logic
- [ ] Create `WrittenModeWidget` UI
  - [ ] Display question
  - [ ] Text input field (TextField)
  - [ ] Character counter
  - [ ] Submit button
  - [ ] Feedback: exact match / close match / incorrect
  - [ ] Show correct answer if wrong
  - [ ] Retry button (if wrong)
- [ ] Add virtual keyboard support
- [ ] Add autocomplete suggestions (optional)

### 4.6. Testing & Validation

- [ ] Unit test `StudyModeFactory.createMode()`
- [ ] Unit test `StudyModeFactory.getAllModes()` returns 4 modes in order
- [ ] Unit test `StudyModeFactory.getNextMode()` progression
- [ ] Unit test each mode's `checkAnswer()` logic
- [ ] Unit test fuzzy matching algorithm
- [ ] Integration test: full mode sequence (1→2→3→4)
- [ ] Widget test for each mode UI

---

## Phase 5: Study Session Management

### 5.1. Session Controller

- [ ] Create `StudyController` class
- [ ] Implement `startSession(deckId)` method
  - [ ] Load deck flashcards
  - [ ] Filter cards due for review (nextReviewDate <= today)
  - [ ] Apply ReviewOrder setting
  - [ ] Initialize session state
- [ ] Implement `startFlashcard(flashcard)` method
  - [ ] Load or create FlashcardStudyProgress
  - [ ] Determine current mode (resume if incomplete)
  - [ ] Load StudyMode instance from factory
- [ ] Implement `submitAnswer(answer)` method
  - [ ] Validate answer
  - [ ] Call mode's checkAnswer()
  - [ ] Save ModeResult
  - [ ] Handle correct: move to next mode
  - [ ] Handle incorrect: retry same mode
- [ ] Implement `completeFlashcard()` method
  - [ ] Verify all 4 modes passed
  - [ ] Calculate new box number
  - [ ] Calculate next review date
  - [ ] Update flashcard in DB
  - [ ] Move to next flashcard
- [ ] Implement `skipFlashcard()` method (optional)
- [ ] Implement `pauseSession()` method
- [ ] Implement `resumeSession()` method
- [ ] Implement `endSession()` method
  - [ ] Save session summary
  - [ ] Clean up state

### 5.2. Session State Management (Riverpod)

- [ ] Create `StudySessionNotifier` provider
- [ ] Track `currentFlashcard` state
- [ ] Track `currentMode` state
- [ ] Track `sessionProgress` (X/Y cards completed)
- [ ] Track `flashcardProgress` (current mode step)
- [ ] Track `modeResults` map
- [ ] Expose computed properties:
  - [ ] `completedCards`
  - [ ] `remainingCards`
  - [ ] `currentModeIndex` (1-4)
  - [ ] `isSessionComplete`
- [ ] Handle loading states
- [ ] Handle error states

### 5.3. Session Persistence

- [ ] Save session progress to DB on each answer
- [ ] Load incomplete session on app restart
- [ ] Auto-save every 30 seconds
- [ ] Clean up completed sessions (older than 7 days)
- [ ] Export session data (JSON)

---

## Phase 6: Study Flow Integration

### 6.1. Study Screen UI

- [ ] Create `StudyScreen` main widget
- [ ] Top bar: Deck name, close button
- [ ] Progress indicators:
  - [ ] Overall progress bar (X/Y cards completed)
  - [ ] Mode progress (4-step indicator: [▓░░░])
  - [ ] Current mode name & icon
- [ ] Dynamic mode widget container
  - [ ] Renders current mode's widget
  - [ ] Handles mode transitions
- [ ] Instructions text (from mode.getInstructions())
- [ ] Bottom sheet: Session stats (time, accuracy)
- [ ] Pause/Resume button
- [ ] Exit confirmation dialog

### 6.2. Mode Transition Animations

- [ ] Fade out current mode widget
- [ ] Success confetti animation (when mode passed)
- [ ] Failure shake animation (when mode failed)
- [ ] Fade in next mode widget
- [ ] Progress bar animation
- [ ] Card completion celebration (when all 4 modes done)

### 6.3. Integration với Thuật toán 7 Ô

- [ ] After passing all 4 modes → calculate new box
- [ ] Use `EffectiveStudySettings.penaltyStrategy` for calculation
- [ ] Calculate `nextReviewDate` based on new box
- [ ] Update flashcard in DB
- [ ] Show visual feedback:
  - [ ] "Ô 3 → Ô 4" animation
  - [ ] "Ôn lại sau 7 ngày" message
- [ ] Handle failure cases:
  - [ ] If fail any mode → retry that mode
  - [ ] Option: reset to mode 1 (based on settings)
  - [ ] Apply penalty strategy if needed

### 6.4. Handle Edge Cases

- [ ] Deck with < 4 cards (warn user, adjust matching/MCQ)
- [ ] Empty deck (show empty state)
- [ ] All cards already mastered (box 7) - show congratulations
- [ ] Network error during session (save locally)
- [ ] App backgrounded during session (pause timer)
- [ ] Low memory (optimize card loading)

---

## Phase 7: Study Session Analytics

### 7.1. Track Statistics

- [ ] Create `StudySessionStats` entity
- [ ] Track time spent per mode
- [ ] Track accuracy rate per mode
- [ ] Track retry count per mode
- [ ] Track total session time
- [ ] Track cards moved to higher boxes
- [ ] Track cards failed (stayed in same box)
- [ ] Save stats to DB after session ends

### 7.2. Session Summary Screen

- [ ] Create `SessionSummaryScreen` widget
- [ ] Display session overview:
  - [ ] Total cards studied
  - [ ] Total time (formatted: HH:MM:SS)
  - [ ] Overall accuracy (%)
- [ ] Breakdown per mode:
  - [ ] Mode name & icon
  - [ ] Success rate
  - [ ] Average time
  - [ ] Retry count
- [ ] Box progression chart:
  - [ ] "X cards moved to higher boxes"
  - [ ] Visual box distribution
- [ ] Streak info (if daily goal met)
- [ ] Share button (share stats to social)
- [ ] Continue/Done buttons

### 7.3. Historical Analytics

- [ ] Create `AnalyticsScreen` widget
- [ ] Chart: Cards studied over time (last 7/30 days)
- [ ] Chart: Accuracy trend over time
- [ ] Heatmap calendar (GitHub-style streak visualization)
- [ ] Best performing modes (pie chart)
- [ ] Hardest flashcards (most retries)
- [ ] Time spent per deck
- [ ] Export analytics data (CSV)

---

## Phase 8: Test Mode Implementation

### 8.1. Test Mode Core

- [ ] Create `TestSession` entity (separate from StudySession)
- [ ] Create `TestController` class
- [ ] Support test modes:
  - [ ] Quick Test (10-20 cards)
  - [ ] Full Test (all cards in deck)
  - [ ] Custom Test (user selects count & types)
  - [ ] Timed Test (with countdown)
  - [ ] Mistake Review (only previously failed cards)
- [ ] Randomize question order
- [ ] Randomize question types (mix of 4 modes)
- [ ] Scoring system (points per correct answer)

### 8.2. Test UI

- [ ] Create `TestScreen` widget
- [ ] Test setup screen (choose mode, count, time limit)
- [ ] Test progress UI (question X/Y)
- [ ] Timer display (for timed tests)
- [ ] Question rendering (reuse mode widgets)
- [ ] Navigation buttons (prev/next/skip)
- [ ] Flag for review feature
- [ ] Submit test button with confirmation

### 8.3. Test Results

- [ ] Create `TestResultsScreen` widget
- [ ] Display score (X/Y correct, %)
- [ ] Time taken
- [ ] Breakdown by mode type
- [ ] List of incorrect answers with correct solutions
- [ ] Retry incorrect button
- [ ] Review all answers button
- [ ] Save results to history
- [ ] Update flashcard boxes based on test performance (optional)

---

## Phase 9: Polish & Optimization

### 9.1. Performance Optimization

- [ ] Lazy load flashcards (pagination)
- [ ] Preload next flashcard in background
- [ ] Cache generated options (MCQ, Matching)
- [ ] Optimize DB queries (add indexes)
- [ ] Image lazy loading (if flashcards have images)
- [ ] Debounce written mode input validation
- [ ] Use const constructors where possible
- [ ] Profile and fix performance bottlenecks

### 9.2. UX Enhancements

- [ ] Keyboard shortcuts:
  - [ ] Spacebar to flip card (recall mode)
  - [ ] Enter to submit answer
  - [ ] Number keys 1-4 for MCQ
  - [ ] Ctrl+Z to undo (if applicable)
- [ ] Haptic feedback:
  - [ ] Light haptic on button press
  - [ ] Success haptic (double pulse) on correct
  - [ ] Error haptic (triple pulse) on wrong
- [ ] Sound effects:
  - [ ] Correct answer sound
  - [ ] Wrong answer sound
  - [ ] Mode completion sound
  - [ ] Session completion fanfare
- [ ] Dark mode support
- [ ] Custom theme colors per deck (optional)
- [ ] Animations 60fps smooth
- [ ] Loading skeletons

### 9.3. Accessibility

- [ ] Screen reader support (Semantics widgets)
- [ ] High contrast mode
- [ ] Font size scaling (respect system settings)
- [ ] Focus indicators for keyboard navigation
- [ ] Alt text for images
- [ ] WCAG AA compliance

### 9.4. Error Handling & Edge Cases

- [ ] Graceful offline mode (save locally, sync later)
- [ ] Network error retry mechanism
- [ ] Corrupted data recovery
- [ ] Very long answers (truncate with "..." + expand)
- [ ] Special characters in written mode (normalize)
- [ ] Empty deck warning
- [ ] Duplicate flashcards handling
- [ ] Concurrent edit conflicts

---

## Phase 10: Advanced Features (Optional)

### 10.1. Adaptive Difficulty

- [ ] Track user's performance per mode
- [ ] Skip easier modes if user is consistently correct (>95% accuracy)
- [ ] Add extra practice modes if struggling (<70% accuracy)
- [ ] Suggest optimal study times based on history
- [ ] AI-powered difficulty adjustment

### 10.2. Customizable Mode Order

- [ ] Settings to enable/disable specific modes
- [ ] Settings to change mode order (e.g., 2→1→3→4)
- [ ] Minimum required modes (at least 2)
- [ ] Save custom order per deck

### 10.3. Spaced Repetition per Mode

- [ ] Track box number separately per mode
  - [ ] `matchingBox`, `mcqBox`, `recallBox`, `writtenBox`
- [ ] Only review modes that are due
- [ ] More granular progress tracking
- [ ] Analytics per mode effectiveness

### 10.4. Multi-Modal Flashcards

- [ ] Image support:
  - [ ] Upload/attach images to flashcards
  - [ ] Image recognition mode (match image to answer)
  - [ ] Drawing mode (draw the answer)
- [ ] Audio support:
  - [ ] Record audio pronunciation
  - [ ] Listening mode (hear question, type answer)
  - [ ] Speaking mode (voice recognition)
- [ ] Video support:
  - [ ] Video hints/explanations
  - [ ] Video questions
- [ ] LaTeX/Math formula support
- [ ] Code syntax highlighting

### 10.5. Gamification

- [ ] XP/Points system
- [ ] Levels (Bronze, Silver, Gold, Platinum)
- [ ] Achievements/Badges:
  - [ ] First study session
  - [ ] 7-day streak
  - [ ] 100 cards mastered
  - [ ] Perfect score on test
- [ ] Leaderboard (if social features)
- [ ] Daily challenges
- [ ] Reward animations

### 10.6. Collaboration & Social

- [ ] Share decks with friends
- [ ] Collaborative deck editing
- [ ] Public deck marketplace
- [ ] Comments on flashcards
- [ ] Study together mode (multiplayer)
- [ ] Challenge friends to tests

---

## 📊 PRIORITY MATRIX

### 🔴 CRITICAL (Must Have for MVP)
- Phase 1: Foundation & Data Layer
- Phase 4: Study Modes Architecture
- Phase 5: Study Session Management
- Phase 6.1-6.3: Study Flow Integration (core)

### 🟠 HIGH (Should Have for V1.0)
- Phase 2: Settings Use Cases
- Phase 3: Settings UI
- Phase 6.4: Edge Cases
- Phase 7: Analytics
- Phase 8: Test Mode

### 🟡 MEDIUM (Nice to Have for V1.5)
- Phase 9: Polish & Optimization
- Phase 10.1-10.2: Adaptive features

### 🟢 LOW (Future Versions)
- Phase 10.3-10.6: Advanced features

---

## 📅 ESTIMATED TIMELINE

```
Week 1-2:  Phase 1 (Foundation)
Week 3:    Phase 2 (Settings Use Cases)
Week 4:    Phase 3 (Settings UI)
Week 5-6:  Phase 4 (Study Modes) ⭐ CORE
Week 7:    Phase 5 (Session Management)
Week 8:    Phase 6 (Study Flow)
Week 9:    Phase 7 (Analytics)
Week 10:   Phase 8 (Test Mode)
Week 11:   Phase 9 (Polish)
Week 12+:  Phase 10 (Advanced)
```

---

## 📝 NOTES

### Thuật toán 7 Ô (Leitner System)

**Box Intervals:**
- Box 1: 0 ngày (hôm nay)
- Box 2: 2 ngày
- Box 3: 4 ngày
- Box 4: 7 ngày
- Box 5: 14 ngày
- Box 6: 30 ngày
- Box 7: 60 ngày

**Flow học:**
```
Flashcard → Mode 1 (Ghép đôi) → Mode 2 (Đoán) → Mode 3 (Nhớ lại) → Mode 4 (Tự luận)
         ↓ pass all 4        ↓                ↓                ↓
    Box tăng lên             Nếu fail → retry mode đó
```

**Settings Priority:**
```
Deck Settings (nếu có) > Global Settings
```

### Factory Pattern Structure

```dart
StudyMode (abstract)
  ├── MatchingStudyMode
  ├── MultipleChoiceStudyMode
  ├── RecallStudyMode
  └── WrittenStudyMode

StudyModeFactory
  ├── createMode(type)
  ├── getAllModes()
  └── getNextMode(current)
```

---

**Last Updated:** 2025-12-07
**Version:** 1.0
**Status:** Planning Phase
