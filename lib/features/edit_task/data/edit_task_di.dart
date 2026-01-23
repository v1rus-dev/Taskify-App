import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/edit_task/data/datasources/sub_task_local_datasource.dart';
import 'package:taskify/features/edit_task/data/datasources/tag_local_datasource.dart';
import 'package:taskify/features/edit_task/data/repositories/sub_task_repository_impl.dart';
import 'package:taskify/data/repositories/tag_repository_impl.dart';
import 'package:taskify/features/edit_task/domain/repositories/sub_task_repository.dart';
import 'package:taskify/features/edit_task/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/domain/repository/tag_repository.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';

void initEditTaskDependencies() {
  locator.registerLazySingleton<SubTaskLocalDataSource>(
    () => SubTaskLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<SubTaskRepository>(
    () => SubTaskRepositoryImpl(
      locator<SubTaskLocalDataSource>(),
      locator<TaskLocalDataSource>(),
      locator<SyncRepository>(),
      locator<SyncCoordinator>(),
    ),
  );
  locator.registerLazySingleton(
    () => SubTaskInteractor(locator<SubTaskRepository>()),
  );

  locator.registerLazySingleton<TagLocalDataSource>(
    () => TagLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(locator<TagLocalDataSource>()),
  );
  locator.registerLazySingleton(
    () => TagInteractor(locator<TagRepository>()),
  );
}
