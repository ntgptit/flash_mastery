import '../constants/constants.dart';

/// Validation utility class for common input validations
class Validators {
  Validators._();

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (!RegexConstants.email.hasMatch(value)) {
      return ErrorMessages.invalidEmail;
    }
    return null;
  }

  /// Validates password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (value.length < 8) {
      return ErrorMessages.passwordTooShort;
    }
    if (!RegexConstants.passwordStrong.hasMatch(value)) {
      return ErrorMessages.passwordTooWeak;
    }
    return null;
  }

  /// Validates required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : ErrorMessages.fieldRequired;
    }
    return null;
  }

  /// Validates phone number format
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (!RegexConstants.phoneInternational.hasMatch(value)) {
      return ErrorMessages.invalidPhoneNumber;
    }
    return null;
  }

  /// Validates minimum length
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : ErrorMessages.fieldRequired;
    }
    if (value.length < minLength) {
      return fieldName != null
          ? '$fieldName must be at least $minLength characters'
          : 'Must be at least $minLength characters';
    }
    return null;
  }

  /// Validates maximum length
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return fieldName != null
          ? '$fieldName must not exceed $maxLength characters'
          : 'Must not exceed $maxLength characters';
    }
    return null;
  }

  /// Validates URL format
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.invalidUrl;
    }
    if (!RegexConstants.url.hasMatch(value)) {
      return ErrorMessages.invalidUrl;
    }
    return null;
  }

  /// Validates that value matches another value (e.g., password confirmation)
  static String? match(String? value, String? otherValue, {String? fieldName}) {
    if (value != otherValue) {
      return fieldName != null
          ? '$fieldName does not match'
          : ErrorMessages.passwordsDoNotMatch;
    }
    return null;
  }

  /// Validates numeric value
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (!RegexConstants.decimalNumber.hasMatch(value)) {
      return 'Must be a valid number';
    }
    return null;
  }

  /// Validates alphanumeric value
  static String? alphanumeric(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (!RegexConstants.alphanumeric.hasMatch(value)) {
      return 'Only letters and numbers are allowed';
    }
    return null;
  }

  /// Validates username format
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.fieldRequired;
    }
    if (!RegexConstants.username.hasMatch(value)) {
      return ErrorMessages.invalidUsername;
    }
    return null;
  }
}
