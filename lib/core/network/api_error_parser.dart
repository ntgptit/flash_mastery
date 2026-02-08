/// Parses backend ErrorResponse `{code, message, path, timestamp, errors}`.
class ApiErrorParser {
  const ApiErrorParser._();

  static String? extractCode(dynamic data) =>
      data is Map ? data['code'] as String? : null;

  static String? extractMessage(dynamic data) =>
      data is Map ? data['message'] as String? : null;

  static Map<String, String>? extractFieldErrors(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is Map) {
      return errors.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return null;
  }
}
