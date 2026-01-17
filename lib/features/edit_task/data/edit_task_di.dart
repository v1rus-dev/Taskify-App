import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/edit_task/data/datasources/sub_task_local_datasource.dart';
import 'package:taskify/features/edit_task/data/repositories/sub_task_repository_impl.dart';
import 'package:taskify/features/edit_task/domain/repositories/sub_task_repository.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';

void initEditTaskDependencies() {
  locator.registerLazySingleton<SubTaskLocalDataSource>(
    () => SubTaskLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<SubTaskRepository>(
    () => SubTaskRepositoryImpl(locator<SubTaskLocalDataSource>()),
  );
  locator.registerLazySingleton(
    () => SubTaskInteractor(locator<SubTaskRepository>()),
  );
}
