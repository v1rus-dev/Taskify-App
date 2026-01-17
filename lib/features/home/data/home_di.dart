import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/data/repositories/task_repository_impl.dart';
import 'package:taskify/domain/repository/task_repository.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

void initHomeDependencies() {
  locator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(locator<AppDatabase>()),
  );

  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(locator<TaskLocalDataSource>()),
  );

  locator.registerLazySingleton(() => TaskInteractor(locator<TaskRepository>()));
}
