/// Regular expression patterns for validation.
///
/// Contains compiled regex patterns used throughout the app
/// for input validation and data formatting.
class RegexConstants {
  RegexConstants._();

  // ==================== EMAIL VALIDATION ====================

  /// Email validation pattern (RFC 5322 compliant).
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Simple email validation pattern.
  static final RegExp emailSimple = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  // ==================== PASSWORD VALIDATION ====================

  /// Password with at least 8 characters, 1 uppercase, 1 lowercase, 1 number.
  static final RegExp passwordStrong = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );

  /// Password with at least 8 characters, 1 letter, 1 number.
  static final RegExp passwordMedium = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  );

  /// At least one uppercase letter.
  static final RegExp hasUppercase = RegExp(r'[A-Z]');

  /// At least one lowercase letter.
  static final RegExp hasLowercase = RegExp(r'[a-z]');

  /// At least one digit.
  static final RegExp hasDigit = RegExp(r'\d');

  /// At least one special character.
  static final RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // ==================== USERNAME VALIDATION ====================

  /// Username: alphanumeric, underscore, dash (3-50 chars).
  static final RegExp username = RegExp(
    r'^[a-zA-Z0-9_-]{3,50}$',
  );

  /// Username starting with letter, alphanumeric + underscore allowed.
  static final RegExp usernameStrict = RegExp(
    r'^[a-zA-Z][a-zA-Z0-9_]{2,49}$',
  );

  // ==================== PHONE NUMBER VALIDATION ====================

  /// International phone number format.
  static final RegExp phoneInternational = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  /// US phone number format (xxx-xxx-xxxx).
  static final RegExp phoneUS = RegExp(
    r'^(\+1[-.\s]?)?(\([0-9]{3}\)|[0-9]{3})[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}$',
  );

  /// Vietnam phone number format (10 digits starting with 0).
  static final RegExp phoneVN = RegExp(
    r'^(0|\+84)[3|5|7|8|9][0-9]{8}$',
  );

  /// Only digits (for phone input).
  static final RegExp onlyDigits = RegExp(r'^\d+$');

  // ==================== URL VALIDATION ====================

  /// URL validation pattern.
  static final RegExp url = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  /// Domain name validation.
  static final RegExp domain = RegExp(
    r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$',
  );

  // ==================== NAME VALIDATION ====================

  /// Full name (letters, spaces, hyphens, apostrophes).
  static final RegExp fullName = RegExp(
    r"^[a-zA-Z\s\-']+$",
  );

  /// Name with accents (supports international characters).
  static final RegExp nameWithAccents = RegExp(
    r"^[a-zA-ZÀ-ÿ\s\-']+$",
  );

  /// Only letters (no spaces).
  static final RegExp onlyLetters = RegExp(r'^[a-zA-Z]+$');

  /// Letters and spaces only.
  static final RegExp lettersAndSpaces = RegExp(r'^[a-zA-Z\s]+$');

  // ==================== NUMERIC VALIDATION ====================

  /// Integer numbers only.
  static final RegExp integerNumber = RegExp(r'^-?\d+$');

  /// Decimal numbers (with optional decimal point).
  static final RegExp decimalNumber = RegExp(r'^-?\d*\.?\d+$');

  /// Positive integer only.
  static final RegExp positiveInteger = RegExp(r'^\d+$');

  /// Positive decimal only.
  static final RegExp positiveDecimal = RegExp(r'^\d*\.?\d+$');

  // ==================== DATE & TIME VALIDATION ====================

  /// Date format: YYYY-MM-DD.
  static final RegExp dateYYYYMMDD = RegExp(
    r'^\d{4}-\d{2}-\d{2}$',
  );

  /// Date format: DD/MM/YYYY.
  static final RegExp dateDDMMYYYY = RegExp(
    r'^\d{2}\/\d{2}\/\d{4}$',
  );

  /// Date format: MM/DD/YYYY.
  static final RegExp dateMMDDYYYY = RegExp(
    r'^\d{2}\/\d{2}\/\d{4}$',
  );

  /// Time format: HH:MM (24-hour).
  static final RegExp time24Hour = RegExp(
    r'^([01]\d|2[0-3]):([0-5]\d)$',
  );

  /// Time format: HH:MM:SS.
  static final RegExp timeWithSeconds = RegExp(
    r'^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$',
  );

  // ==================== CREDIT CARD VALIDATION ====================

  /// Credit card number (13-19 digits).
  static final RegExp creditCard = RegExp(r'^\d{13,19}$');

  /// CVV code (3 or 4 digits).
  static final RegExp cvv = RegExp(r'^\d{3,4}$');

  // ==================== POSTAL CODE VALIDATION ====================

  /// US ZIP code (5 or 9 digits).
  static final RegExp zipCodeUS = RegExp(r'^\d{5}(-\d{4})?$');

  /// UK postcode.
  static final RegExp postcodeUK = RegExp(
    r'^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$',
    caseSensitive: false,
  );

  /// Canada postal code.
  static final RegExp postalCodeCA = RegExp(
    r'^[A-Z]\d[A-Z]\s?\d[A-Z]\d$',
    caseSensitive: false,
  );

  // ==================== COLOR VALIDATION ====================

  /// Hex color code (#RGB or #RRGGBB).
  static final RegExp hexColor = RegExp(
    r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$',
  );

  /// RGB color format.
  static final RegExp rgbColor = RegExp(
    r'^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$',
  );

  // ==================== VERSION VALIDATION ====================

  /// Semantic version (x.y.z).
  static final RegExp semanticVersion = RegExp(
    r'^\d+\.\d+\.\d+$',
  );

  /// Version with optional build number (x.y.z+build).
  static final RegExp versionWithBuild = RegExp(
    r'^\d+\.\d+\.\d+(\+\d+)?$',
  );

  // ==================== FILE & PATH VALIDATION ====================

  /// File extension validator.
  static final RegExp fileExtension = RegExp(r'\.([a-zA-Z0-9]+)$');

  /// Image file extensions.
  static final RegExp imageExtension = RegExp(
    r'\.(jpg|jpeg|png|gif|bmp|webp)$',
    caseSensitive: false,
  );

  /// Document file extensions.
  static final RegExp documentExtension = RegExp(
    r'\.(pdf|doc|docx|txt|xls|xlsx|ppt|pptx)$',
    caseSensitive: false,
  );

  // ==================== SPECIAL PATTERNS ====================

  /// HTML tags remover.
  static final RegExp htmlTags = RegExp(r'<[^>]*>');

  /// Whitespace (multiple spaces/tabs/newlines).
  static final RegExp multipleWhitespace = RegExp(r'\s+');

  /// Leading and trailing whitespace.
  static final RegExp trimWhitespace = RegExp(r'^\s+|\s+$');

  /// Only alphanumeric characters.
  static final RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  /// Base64 string validation.
  static final RegExp base64 = RegExp(
    r'^[A-Za-z0-9+/]*={0,2}$',
  );

  // ==================== SOCIAL MEDIA PATTERNS ====================

  /// Twitter username (@username).
  static final RegExp twitterUsername = RegExp(r'^@?(\w){1,15}$');

  /// Instagram username.
  static final RegExp instagramUsername = RegExp(r'^@?[a-zA-Z0-9._]{1,30}$');

  /// Hashtag validation.
  static final RegExp hashtag = RegExp(r'^#[a-zA-Z0-9_]+$');
}
