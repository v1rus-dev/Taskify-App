import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify/l10n/app_localizations.dart';

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null) {
    _load();
  }

  static const String _key = 'locale_override';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null || code.isEmpty) {
      emit(null);
      return;
    }
    emit(Locale(code));
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_key);
      emit(null);
      return;
    }
    final supported = AppLocalizations.supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
    if (!supported) return;
    await prefs.setString(_key, locale.languageCode);
    emit(locale);
  }
}
