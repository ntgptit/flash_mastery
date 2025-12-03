# Flash Mastery

A modern flashcard learning application built with Flutter, following Clean Architecture principles.

## Features

- 📚 Create and organize flashcard decks
- 🎯 Spaced repetition learning system
- 🌓 Light and dark theme support
- 📱 Responsive design for all devices
- 🔐 User authentication and profile management
- 📊 Study progress tracking and statistics

## Architecture

This project follows Clean Architecture with the following layers:

### Core Layer
- **Constants**: Centralized app constants (colors, typography, spacing, API config)
- **Error Handling**: Custom exceptions and failures with Either pattern
- **Network**: Dio client configuration with interceptors
- **Utils**: Validators, formatters, and helper functions
- **Extensions**: Dart extensions for String, DateTime, num, and BuildContext
- **Theme**: Material 3 theme configuration
- **Router**: Navigation using go_router
- **Providers**: Riverpod dependency injection setup

### Data Layer
- **Models**: Data models with JSON serialization
- **Repositories**: Implementation of repository interfaces
- **Data Sources**: Remote (API) and Local (cache) data sources

### Domain Layer
- **Entities**: Business logic entities
- **Repositories**: Repository interfaces
- **Use Cases**: Business logic operations

### Presentation Layer
- **Pages**: UI screens
- **Widgets**: Reusable UI components
- **Providers**: State management with Riverpod

## Tech Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod (hooks_riverpod)
- **Navigation**: go_router
- **HTTP Client**: Dio with Retrofit
- **Code Generation**: freezed, json_serializable
- **Functional Programming**: dartz (Either pattern)
- **UI Hooks**: flutter_hooks

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flash_mastery.git
cd flash_mastery
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/                      # Core functionality
│   ├── constants/            # App constants
│   ├── error/               # Error handling
│   ├── extensions/          # Dart extensions
│   ├── network/             # Network configuration
│   ├── providers/           # Core providers
│   ├── router/              # Navigation
│   ├── theme/               # Theme configuration
│   ├── usecases/            # Base use case classes
│   └── utils/               # Utility functions
├── data/                     # Data layer
│   ├── models/              # Data models
│   ├── repositories/        # Repository implementations
│   └── sources/             # Data sources
├── domain/                   # Domain layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Use cases
├── presentation/             # Presentation layer
│   ├── pages/               # App screens
│   ├── widgets/             # Reusable widgets
│   └── providers/           # State providers
└── main.dart                # App entry point
```

## Code Generation

This project uses code generation for:
- Riverpod providers (`riverpod_generator`)
- Freezed models (`freezed`)
- JSON serialization (`json_serializable`)
- Retrofit API clients (`retrofit_generator`)

Run code generation:
```bash
# Watch mode (auto-generate on file changes)
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

## API Configuration

Update the base URL in `lib/core/constants/config/api_constants.dart`:

```dart
static const String baseUrl = 'https://your-api-url.com';
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Clean Architecture by Robert C. Martin
- Flutter and Dart teams
- Riverpod community
- Material Design 3
