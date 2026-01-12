import 'package:get_it/get_it.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/database/database_di.dart';

final locator = GetIt.instance;

Future<void> initServiceLocator(AppDatabase appDatabase) async {
  await initDatabase(appDatabase);
  await initDio();
  await initRepositories();
}

Future<void> initDatabase(AppDatabase appDatabase) async {
  DatabaseDi.register(appDatabase);
}

Future<void> initRepositories() async {

}

Future<void> initDio() async {

}