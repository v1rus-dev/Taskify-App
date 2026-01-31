import 'package:get_it/get_it.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/database/database_di.dart';
import 'package:taskify/data/auth/auth_di.dart';
import 'package:taskify/data/api/api_di.dart';
import 'package:taskify/data/interactors/interactors_di.dart';
import 'package:taskify/data/sync/sync_di.dart';
import 'package:taskify/features/home/data/home_di.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'package:taskify/features/edit_task/data/edit_task_di.dart';
import 'package:taskify/core/native_widgets/task_widget_bridge.dart';
import 'package:taskify/core/native_widgets/task_widget_store.dart';
import 'package:taskify/core/native_widgets/task_widget_sync_service.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';

final locator = GetIt.instance;

Future<void> initServiceLocator(AppDatabase appDatabase) async {
  await initDatabase(appDatabase);
  initAuthStorageDependencies();
  await initDio();
  initApiDependencies();
  await initRepositories();
  initWidgetDependencies();
  initInteractors();
}

Future<void> initDatabase(AppDatabase appDatabase) async {
  DatabaseDi.register(appDatabase);
}

Future<void> initRepositories() async {
  initSyncDependencies();
  initHomeDependencies();
  initAuthDependencies();
  initEditTaskDependencies();
}

void initWidgetDependencies() {
  locator.registerLazySingleton(TaskWidgetBridge.new);
  locator.registerLazySingleton(() => TaskWidgetStore(locator<TaskWidgetBridge>()));
  locator.registerLazySingleton(
    () => TaskWidgetSyncService(
      locator<TaskLocalDataSource>(),
      locator<TaskWidgetStore>(),
      locator<TaskWidgetBridge>(),
    ),
  );
}

Future<void> initDio() async {
  final tokenHandler = locator.isRegistered<AuthTokenHandler>()
      ? locator<AuthTokenHandler>()
      : null;
  locator.registerSingleton(DioClient(authTokenHandler: tokenHandler));
}
