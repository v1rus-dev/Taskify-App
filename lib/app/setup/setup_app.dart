import 'package:flutter/material.dart';
import 'package:taskify/app/setup/setup_logging.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLogging();
}