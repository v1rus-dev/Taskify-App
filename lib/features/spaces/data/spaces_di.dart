import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/api/spaces_api.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/features/spaces/data/datasources/spaces_local_datasource.dart';
import 'package:taskify/features/spaces/data/datasources/spaces_network_datasource.dart';
import 'package:taskify/features/spaces/data/repositories/spaces_repository_impl.dart';
import 'package:taskify/features/spaces/domain/repositories/space_repository.dart';
import 'package:taskify/features/spaces/domain/usecases/space_interactor.dart';

void initSpacesDependencies() {
  locator.registerLazySingleton<SpacesNetworkDataSource>(
    () => SpacesNetworkDataSourceImpl(locator<SpacesApi>()),
  );
  locator.registerLazySingleton<SpacesLocalDataSource>(
    () => SpacesLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<SpaceRepository>(
    () => SpacesRepositoryImpl(
      networkDataSource: locator<SpacesNetworkDataSource>(),
      localDataSource: locator<SpacesLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton(
    () => SpaceInteractor(locator<SpaceRepository>()),
  );
}
