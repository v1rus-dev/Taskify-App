import 'package:flutter/material.dart';
import 'package:taskify/app/setup/setup_database.dart';
import 'package:taskify/app/setup/setup_logging.dart';
import 'package:taskify/app/setup/setup_preferences.dart';
import 'package:taskify/infrastructure/services/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskify/firebase_options.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLogging();
  await setupPreferences();
  final database = await setupDatabase();
  await initServiceLocator(database);
}