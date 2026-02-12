import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/features/tasks/data/sources/sub_task_local_datasource.dart';
import 'package:taskify/features/tasks/data/sources/tag_local_datasource.dart';
import 'package:taskify/features/tasks/data/repositories/sub_task_repository_impl.dart';
import 'package:taskify/data/repositories/tag_repository_impl.dart';
import 'package:taskify/features/tasks/domain/repositories/sub_task_repository.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/domain/tags/repository/tag_repository.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/save_edited_task_interactor.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/features/home/domain/usecases/task_interactor.dart';

void initTasksDependencies() {
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

  locator.registerLazySingleton(
    () => SaveEditedTaskInteractor(
      locator<TaskInteractor>(),
      locator<SubTaskInteractor>(),
      locator<TagInteractor>(),
    ),
  );
}
