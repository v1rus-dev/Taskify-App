import 'package:taskify/data/database/app_database.dart';

Future<AppDatabase> setupDatabase() async {
  final database = AppDatabase();
  return database;
}