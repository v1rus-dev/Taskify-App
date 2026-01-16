import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/home/data/datasources/task_local_datasource.dart';
import 'package:taskify/data/repositories/task_repository_impl.dart';
import 'package:taskify/domain/repository/task_repository.dart';
import 'package:taskify/features/home/domain/usecases/create_task.dart';
import 'package:taskify/features/home/domain/usecases/delete_task.dart';
import 'package:taskify/features/home/domain/usecases/get_task_by_id.dart';
import 'package:taskify/features/home/domain/usecases/get_tasks.dart';
import 'package:taskify/features/home/domain/usecases/get_tasks_by_date.dart';
import 'package:taskify/features/home/domain/usecases/observe_tasks.dart';
import 'package:taskify/features/home/domain/usecases/update_task.dart';

void initHomeDependencies() {
  locator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(locator<AppDatabase>()),
  );

  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(locator<TaskLocalDataSource>()),
  );

  locator.registerLazySingleton(() => GetTasks(locator<TaskRepository>()));
  locator.registerLazySingleton(() => GetTasksByDate(locator<TaskRepository>()));
  locator.registerLazySingleton(() => CreateTask(locator<TaskRepository>()));
  locator.registerLazySingleton(() => UpdateTask(locator<TaskRepository>()));
  locator.registerLazySingleton(() => ObserveTasks(locator<TaskRepository>()));
  locator.registerLazySingleton(() => DeleteTask(locator<TaskRepository>()));
  locator.registerLazySingleton(() => GetTaskById(locator<TaskRepository>()));
}
