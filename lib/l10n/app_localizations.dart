import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Map<String, String> _localizedStrings;

  AppLocalizations(this._localizedStrings);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Геттеры для удобства
  String get appTitle => translate('appTitle');
  String get writeANewTask => translate('writeANewTask');
  String get description => translate('description');
  String get today => translate('today');
  String get tasks => translate('tasks');
  String get timeline => translate('timeline');
  String get save => translate('save');

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
  ];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final String languageCode = locale.languageCode;
    final String jsonString = await rootBundle
        .loadString('lib/l10n/intl_$languageCode.arb');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    final Map<String, String> localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return AppLocalizations(localizedStrings);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
