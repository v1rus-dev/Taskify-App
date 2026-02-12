import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/auth/domain/repository/auth_repository.dart';
import 'package:taskify/features/sync/data/datasources/sync_local_datasource.dart';
import 'package:taskify/features/sync/data/datasources/sync_remote_datasource.dart';
import 'package:taskify/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:taskify/features/sync/domain/repositories/sync_repository.dart';
import 'package:taskify/features/sync/domain/services/sync_coordinator.dart';
import 'package:taskify/features/sync/domain/usecases/enqueue_sync_op_use_case.dart';
import 'package:taskify/features/sync/domain/usecases/get_sync_state_use_case.dart';
import 'package:taskify/features/sync/domain/usecases/request_sync_use_case.dart';
import 'package:taskify/features/sync/domain/usecases/run_sync_use_case.dart';
import 'package:taskify/features/sync/domain/usecases/save_sync_state_use_case.dart';
import 'package:taskify/features/sync/domain/usecases/sync_interactor.dart';

void initSyncDependencies() {
  locator.registerLazySingleton<SyncLocalDataSource>(
    () => SyncLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<SyncRemoteDataSource>(
    () => SyncRemoteDataSourceImpl(locator<DioClient>()),
  );
  locator.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      locator<SyncLocalDataSource>(),
      locator<SyncRemoteDataSource>(),
    ),
  );

  locator.registerLazySingleton(
    () => SyncInteractor(locator<SyncRepository>()),
  );
  locator.registerLazySingleton(
    () => RunSyncUseCase(locator<SyncInteractor>()),
  );
  locator.registerLazySingleton(
    () => GetSyncStateUseCase(locator<SyncRepository>()),
  );
  locator.registerLazySingleton(
    () => SaveSyncStateUseCase(locator<SyncRepository>()),
  );
  locator.registerLazySingleton(
    () => EnqueueSyncOpUseCase(locator<SyncRepository>()),
  );

  locator.registerLazySingleton<SyncCoordinator>(
    () => SyncCoordinator(
      runSyncUseCase: locator<RunSyncUseCase>(),
      getSyncStateUseCase: locator<GetSyncStateUseCase>(),
      saveSyncStateUseCase: locator<SaveSyncStateUseCase>(),
      authRepository: locator<AuthRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => RequestSyncUseCase(locator<SyncCoordinator>()),
  );
}
