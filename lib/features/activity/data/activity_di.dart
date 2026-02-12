import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/activity/data/datasources/activity_local_datasource.dart';
import 'package:taskify/features/activity/data/repositories/activity_repository.dart';
import 'package:taskify/features/activity/domain/usecases/activity_interactor.dart';

void initActivityDependencies() {
  locator.registerLazySingleton<ActivityLocalDataSource>(
    () => ActivityLocalDataSourceImpl(locator<AppDatabase>()),
  );

  locator.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(locator<ActivityLocalDataSource>()),
  );

  locator.registerLazySingleton(
    () => ActivityInteractor(locator<ActivityRepository>()),
  );
}
