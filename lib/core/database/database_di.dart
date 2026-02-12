import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/core/services/locator.dart';

class DatabaseDi {
  static void register(AppDatabase appDatabase) {
    locator.registerSingleton<AppDatabase>(appDatabase);
  }
}