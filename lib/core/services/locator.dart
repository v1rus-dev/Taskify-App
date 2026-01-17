import 'package:get_it/get_it.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/database/database_di.dart';
import 'package:taskify/data/auth/auth_di.dart';
import 'package:taskify/data/api/api_di.dart';
import 'package:taskify/features/home/data/home_di.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/auth/access_token_provider.dart';

final locator = GetIt.instance;

Future<void> initServiceLocator(AppDatabase appDatabase) async {
  await initDatabase(appDatabase);
  initAuthStorageDependencies();
  await initDio();
  initApiDependencies();
  await initRepositories();
}

Future<void> initDatabase(AppDatabase appDatabase) async {
  DatabaseDi.register(appDatabase);
}

Future<void> initRepositories() async {
  initHomeDependencies();
  initAuthDependencies();
}

Future<void> initDio() async {
  final tokenHandler = locator.isRegistered<AuthTokenHandler>()
      ? locator<AuthTokenHandler>()
      : null;
  locator.registerSingleton(DioClient(authTokenHandler: tokenHandler));
}
