import 'package:flutter/material.dart';

sealed class LanguageSelection {
  const LanguageSelection();
}

class LanguageSelectionSystem extends LanguageSelection {
  const LanguageSelectionSystem();
}

class LanguageSelectionOverride extends LanguageSelection {
  const LanguageSelectionOverride(this.locale);
  final Locale locale;
}
