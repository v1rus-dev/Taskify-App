import 'package:flutter/services.dart';
import 'package:taskify/features/friends/domain/friend_code.dart';

class FriendCodeInputFormatter extends TextInputFormatter {
  const FriendCodeInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = FriendCode.format(newValue.text);
    final cursorPosition = _computeCursorPosition(newValue, formatted);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  int _computeCursorPosition(TextEditingValue newValue, String formatted) {
    final baseOffset = newValue.selection.baseOffset;
    if (baseOffset < 0) {
      return formatted.length;
    }

    final rawBeforeCursor = newValue.text.substring(
      0,
      baseOffset.clamp(0, newValue.text.length),
    );
    final normalizedBeforeCursor = FriendCode.normalize(rawBeforeCursor);
    final validCount = normalizedBeforeCursor.length;

    final cursor = validCount <= FriendCode.separatorIndex
        ? validCount
        : validCount + 1;

    if (cursor > formatted.length) {
      return formatted.length;
    }

    return cursor;
  }
}
