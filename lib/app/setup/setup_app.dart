import 'package:flutter/material.dart';
import 'package:taskify/app/setup/setup_database.dart';
import 'package:taskify/app/setup/setup_logging.dart';
import 'package:taskify/app/setup/setup_preferences.dart';
import 'package:taskify/infrastructure/services/locator.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogging();
  await setupPreferences();
  final database = await setupDatabase();
  await initServiceLocator(database);
}