class FriendCode {
  static const int maxLength = 8;
  static const int separatorIndex = 4;
  static final RegExp _validPattern = RegExp(r'^[A-Z0-9]{4}-[A-Z0-9]{4}$');
  static final RegExp _invalidChars = RegExp(r'[^A-Z0-9]');

  static bool isValid(String value) => _validPattern.hasMatch(value);

  static String normalize(String raw) {
    final upper = raw.toUpperCase();
    final cleaned = upper.replaceAll(_invalidChars, '');
    if (cleaned.length <= maxLength) {
      return cleaned;
    }
    return cleaned.substring(0, maxLength);
  }

  static String format(String raw) {
    final normalized = normalize(raw);
    if (normalized.length <= separatorIndex) {
      return normalized;
    }
    final first = normalized.substring(0, separatorIndex);
    final second = normalized.substring(separatorIndex);
    return '$first-$second';
  }
}
