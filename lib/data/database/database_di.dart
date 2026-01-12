import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/infrastructure/services/locator.dart';

class DatabaseDi {
  static void register(AppDatabase appDatabase) {
    locator.registerSingleton<AppDatabase>(appDatabase);
  }
}