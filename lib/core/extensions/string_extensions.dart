/// Extension methods for String
extension StringExtensions on String {
  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert to title case
  String get toTitleCase => capitalizeWords;

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove extra whitespace (multiple spaces to single space)
  String get removeExtraWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string contains only letters and numbers
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Convert string to int (returns null if invalid)
  int? get toIntOrNull => int.tryParse(this);

  /// Convert string to double (returns null if invalid)
  double? get toDoubleOrNull => double.tryParse(this);

  /// Convert string to DateTime (returns null if invalid)
  DateTime? get toDateTimeOrNull => DateTime.tryParse(this);

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Reverse the string
  String get reverse => split('').reversed.join('');

  /// Check if string is palindrome
  bool get isPalindrome {
    final cleaned = toLowerCase().removeWhitespace;
    return cleaned == cleaned.reverse;
  }

  /// Count words in string
  int get wordCount => trim().split(RegExp(r'\s+')).length;

  /// Get initials from name (e.g., "John Doe" -> "JD")
  String get initials {
    final words = trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    }
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join('');
  }

  /// Convert snake_case to camelCase
  String get toCamelCase {
    final words = split('_');
    if (words.isEmpty) return this;
    return words.first +
        words.skip(1).map((word) => word.capitalize).join('');
  }

  /// Convert camelCase to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to kebab-case
  String get toKebabCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^-'), '');
  }

  /// Remove HTML tags
  String get stripHtml => replaceAll(RegExp(r'<[^>]*>'), '');

  /// Mask email (e.g., "john@example.com" -> "j***@example.com")
  String get maskEmail {
    if (!isValidEmail) return this;
    final parts = split('@');
    final username = parts[0];
    final domain = parts[1];
    final maskedUsername =
        username.length > 1 ? '${username[0]}***' : username;
    return '$maskedUsername@$domain';
  }

  /// Mask phone number (e.g., "1234567890" -> "******7890")
  String get maskPhone {
    if (length < 4) return this;
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }

  /// Check if string contains emoji
  bool get hasEmoji {
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]',
      unicode: true,
    );
    return emojiRegex.hasMatch(this);
  }

  /// Remove emoji from string
  String get removeEmoji {
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]',
      unicode: true,
    );
    return replaceAll(emojiRegex, '');
  }
}
