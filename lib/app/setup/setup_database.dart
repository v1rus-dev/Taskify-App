import 'package:taskify/core/database/app_database.dart';

Future<AppDatabase> setupDatabase() async {
  final database = AppDatabase();
  return database;
}