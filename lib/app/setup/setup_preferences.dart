import 'package:taskify/data/preferences/app_preferences.dart';

Future<void> setupPreferences() async {
  await AppPreferences.init();
}