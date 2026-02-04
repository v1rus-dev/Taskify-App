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
  String get home => translate('home');
  String get spaces => translate('spaces');
  String get activity => translate('activity');
  String get profile => translate('profile');
  String get timeFormat => translate('timeFormat');
  String get timeFormat24 => translate('timeFormat24');
  String get timeFormat12 => translate('timeFormat12');
  String get selected => translate('selected');
  String get date => translate('date');
  String get period => translate('period');
  String get allDay => translate('allDay');
  String get startTime => translate('startTime');
  String get endTime => translate('endTime');
  String get when => translate('when');
  String get clearSelection => translate('clearSelection');
  String get time => translate('time');
  String get timeLabel => translate('timeLabel');
  String get selectTimes => translate('selectTimes');
  String get from => translate('from');
  String get to => translate('to');
  String get addTags => translate('addTags');
  String get createTag => translate('createTag');
  String get tagName => translate('tagName');
  String get color => translate('color');
  String get createCustomTagHint => translate('createCustomTagHint');
  String get selectTags => translate('selectTags');
  String get defaults => translate('defaults');
  String get customs => translate('customs');
  String get noCustomTags => translate('noCustomTags');
  String get tagsHelpText => translate('tagsHelpText');
  String get addTag => translate('addTag');
  String get addSubTask => translate('addSubTask');
  String get edit => translate('edit');
  String get exitFromAccount => translate('exitFromAccount');
  String get deleteAccount => translate('deleteAccount');
  String get signInWithGoogle => translate('signInWithGoogle');
  String get signInWithApple => translate('signInWithApple');
  String get am => translate('am');
  String get pm => translate('pm');
  String get saving => translate('saving');
  String get signInToGetMoreFromTaskify =>
      translate('signInToGetMoreFromTaskify');
  String get signInToGetMoreFromTaskifyDescription =>
      translate('signInToGetMoreFromTaskifyDescription');
  String get theme => translate('theme');
  String get themeLight => translate('themeLight');
  String get themeDark => translate('themeDark');
  String get themeSystem => translate('themeSystem');
  String get language => translate('language');
  String get languageEnglish => translate('languageEnglish');
  String get languageRussian => translate('languageRussian');
  String get languageSystem => translate('languageSystem');
  String get signIn => translate('signIn');
  String get signInDescription => translate('signInDescription');
  String get signInToYourAccount => translate('signInToYourAccount');
  String get friendCode => translate('friendCode');
  String get scanOrCopyToAddFriend => translate('scanOrCopyToAddFriend');
  String get sharedFriendCode => translate('sharedFriendCode');
  String get generateNewFriendCode => translate('generateNewFriendCode');
  String get friendCodeCopied => translate('friendCodeCopied');
  String get shareFriendCodeMessage => translate('shareFriendCodeMessage');
  String get friends => translate('friends');
  String get addAndManageFriends => translate('addAndManageFriends');
  String get noFriendsTitle => translate('noFriendsTitle');
  String get noFriendsDescription => translate('noFriendsDescription');
  String get addFriends => translate('addFriends');

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [Locale('en'), Locale('ru')];

  String localeDisplayName(Locale? locale) {
    if (locale == null) return languageSystem;
    return switch (locale.languageCode) {
      'en' => languageEnglish,
      'ru' => languageRussian,
      _ => locale.languageCode,
    };
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final String languageCode = locale.languageCode;
    final String jsonString = await rootBundle.loadString(
      'lib/l10n/intl_$languageCode.arb',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, String> localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return AppLocalizations(localizedStrings);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
