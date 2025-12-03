# Constants Directory

This directory contains all application-wide constants organized by category for better maintainability and clarity.

## 📁 Directory Structure

```
lib/core/constants/
├── theme/              # UI Theme & Design System
│   ├── app_colors.dart       # Color palette
│   ├── app_typography.dart   # Text styles
│   └── app_spacing.dart      # Spacing system
│
├── config/             # Application Configuration
│   ├── app_constants.dart    # App config & feature flags
│   └── api_constants.dart    # API endpoints & config
│
├── validation/         # Input Validation
│   ├── error_messages.dart   # Error & validation messages
│   └── regex_constants.dart  # Validation patterns
│
├── storage/            # Local Storage
│   └── storage_constants.dart # Storage keys
│
└── constants.dart      # Barrel file (exports all)
```

## 🎯 Usage

### Option 1: Import Individual Files (Recommended for specific needs)
```dart
import 'package:flash_mastery/core/constants/theme/app_colors.dart';
import 'package:flash_mastery/core/constants/config/api_constants.dart';
```

### Option 2: Import Everything (Convenient but larger bundle)
```dart
import 'package:flash_mastery/core/constants/constants.dart';
```

## 📦 Categories

### 🎨 Theme
Design system constants including colors, typography, and spacing.
- **app_colors.dart**: Brand colors and theme palette
- **app_typography.dart**: Text styles following Material 3
- **app_spacing.dart**: Consistent spacing scale (xs, sm, md, lg, xl, xxl)

### ⚙️ Config
Application and API configuration.
- **app_constants.dart**: App metadata, feature flags, limits, timing constants
- **api_constants.dart**: Base URLs, endpoints, timeout values

### ✅ Validation
Input validation patterns and error messages.
- **error_messages.dart**: All user-facing error messages
- **regex_constants.dart**: Regex patterns for email, phone, URLs, etc.

### 💾 Storage
Local storage key definitions.
- **storage_constants.dart**: Keys for SharedPreferences, Hive, and Secure Storage

## 🔄 Migration Guide

If you were previously importing from the root constants folder:

**Before:**
```dart
import 'package:flash_mastery/core/constants/app_colors.dart';
```

**After:**
```dart
// Option A: Import from specific subfolder
import 'package:flash_mastery/core/constants/theme/app_colors.dart';

// Option B: Import from barrel file (recommended)
import 'package:flash_mastery/core/constants/constants.dart';
```

## 📝 Best Practices

1. **Use meaningful names**: Constants should be self-documenting
2. **Group related constants**: Keep related values in the same section
3. **Add documentation**: Include doc comments for complex constants
4. **Avoid magic numbers**: Define all numbers as named constants
5. **Use type-safe constants**: Prefer `const` over `final` when possible

## 🚀 Adding New Constants

1. Determine the appropriate category (theme/config/validation/storage)
2. Add constants to the relevant file in that category
3. Use consistent naming conventions
4. Add documentation comments
5. Update the barrel file if creating a new file
6. Update this README if adding a new category

## 📖 Related Documentation

- [Flutter Constants Best Practices](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options#constants)
- [Dart Language Tour - Constants](https://dart.dev/guides/language/language-tour#final-and-const)
