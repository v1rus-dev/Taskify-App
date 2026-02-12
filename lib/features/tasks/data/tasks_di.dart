import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/sync/domain/usecases/enqueue_sync_op_use_case.dart';
import 'package:taskify/features/sync/domain/usecases/request_sync_use_case.dart';
import 'package:taskify/features/tasks/data/repositories/sub_task_repository_impl.dart';
import 'package:taskify/features/tasks/data/repositories/tag_repository_impl.dart';
import 'package:taskify/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskify/features/tasks/data/sources/sub_task_local_datasource.dart';
import 'package:taskify/features/tasks/data/sources/tag_local_datasource.dart';
import 'package:taskify/features/tasks/data/sources/task_local_datasource.dart';
import 'package:taskify/features/tasks/domain/repositories/sub_task_repository.dart';
import 'package:taskify/features/tasks/domain/repositories/tag_repository.dart';
import 'package:taskify/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskify/features/tasks/domain/usecases/save_edited_task_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/sub_task_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';
import 'package:taskify/features/tasks/domain/usecases/task_interactor.dart';

void initTasksDependencies() {
  locator.registerLazySingleton<SubTaskLocalDataSource>(
    () => SubTaskLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<TagLocalDataSource>(
    () => TagLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(locator<AppDatabase>()),
  );

  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      locator<TaskLocalDataSource>(),
      locator<SubTaskLocalDataSource>(),
      locator<TagLocalDataSource>(),
      locator<EnqueueSyncOpUseCase>(),
      locator<RequestSyncUseCase>(),
    ),
  );
  locator.registerLazySingleton<SubTaskRepository>(
    () => SubTaskRepositoryImpl(
      locator<SubTaskLocalDataSource>(),
      locator<TaskLocalDataSource>(),
      locator<EnqueueSyncOpUseCase>(),
      locator<RequestSyncUseCase>(),
    ),
  );
  locator.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(locator<TagLocalDataSource>()),
  );

  locator.registerLazySingleton(
    () => TaskInteractor(locator<TaskRepository>()),
  );
  locator.registerLazySingleton(
    () => SubTaskInteractor(locator<SubTaskRepository>()),
  );
  locator.registerLazySingleton(() => TagInteractor(locator<TagRepository>()));
  locator.registerLazySingleton(
    () => SaveEditedTaskInteractor(
      locator<TaskInteractor>(),
      locator<SubTaskInteractor>(),
      locator<TagInteractor>(),
    ),
  );
}
