import 'package:get_it/get_it.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/database/database_di.dart';
import 'package:taskify/data/auth/auth_di.dart';
import 'package:taskify/data/api/api_di.dart';
import 'package:taskify/data/interactors/interactors_di.dart';
import 'package:taskify/data/sync/sync_di.dart';
import 'package:taskify/features/home/data/home_di.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';
import 'package:taskify/core/config/server_env.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'package:taskify/features/edit_task/data/edit_task_di.dart';
import 'package:taskify/features/profile/data/profile_di.dart';
import 'package:taskify/data/friends/friends_di.dart';
import 'package:taskify/core/app_startup/app_startup_di.dart';
import 'package:taskify/core/home_widget/task_home_widget_service.dart';
import 'package:taskify/core/network/network_info.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taskify/features/activity/data/activity_di.dart';
import 'package:taskify/features/spaces/data/spaces_di.dart';

final locator = GetIt.instance;

Future<void> initServiceLocator(
  AppDatabase appDatabase, {
  required ServerEnv serverEnv,
}) async {
  locator.registerSingleton<ServerEnv>(serverEnv);
  locator.registerLazySingleton<Connectivity>(() => Connectivity());
  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(locator<Connectivity>()),
  );
  await initDatabase(appDatabase);
  initAuthStorageDependencies();
  await initDio();
  initApiDependencies();
  await initRepositories();
  initInteractors();
  locator.registerLazySingleton(
    () => TaskHomeWidgetService(locator<TaskInteractor>()),
  );
}

Future<void> initDatabase(AppDatabase appDatabase) async {
  DatabaseDi.register(appDatabase);
}

Future<void> initRepositories() async {
  initSyncDependencies();
  initHomeDependencies();
  initAuthDependencies();
  initProfileDependencies();
  initEditTaskDependencies();
  initActivityDependencies();
  initFriendsDependencies();
  initSpacesDependencies();
  initAppStartupDependencies();
}

Future<void> initDio() async {
  final serverEnv = locator<ServerEnv>();
  final tokenHandler = locator.isRegistered<AuthTokenHandler>()
      ? locator<AuthTokenHandler>()
      : null;
  locator.registerSingleton(
    DioClient(serverEnv: serverEnv, authTokenHandler: tokenHandler),
  );
}
