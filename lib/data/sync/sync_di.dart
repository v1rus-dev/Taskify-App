import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/data/sync/datasources/sync_local_datasource.dart';
import 'package:taskify/data/sync/datasources/sync_remote_datasource.dart';
import 'package:taskify/data/sync/repositories/sync_repository_impl.dart';
import 'package:taskify/features/auth/domain/repository/auth_repository.dart';
import 'package:taskify/domain/sync/repositories/sync_repository.dart';
import 'package:taskify/domain/sync/usecases/sync_interactor.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';

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
  locator.registerLazySingleton<SyncInteractor>(
    () => SyncInteractor(locator<SyncRepository>()),
  );
  locator.registerLazySingleton<SyncCoordinator>(
    () => SyncCoordinator(
      interactor: locator<SyncInteractor>(),
      syncRepository: locator<SyncRepository>(),
      authRepository: locator<AuthRepository>(),
    ),
  );
}
