import 'package:taskify/core/preferences/app_preferences.dart';

Future<void> setupPreferences() async {
  await AppPreferences.init();
}