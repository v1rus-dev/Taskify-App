import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/api/auth_api.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'package:taskify/data/auth/repositories/auth_repository_impl.dart';
import 'package:taskify/data/auth/sources/auth_local_data_source.dart';
import 'package:taskify/data/auth/sources/auth_token_handler_impl.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/auth/repository/auth_repository.dart';

void initAuthStorageDependencies() {
  locator.registerLazySingleton<AuthTokenHandler>(AuthTokenHandlerImpl.new);

  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(locator<AppDatabase>()),
  );
}

void initAuthDependencies() {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authApi: locator.get<AuthApi>(),
      authLocalDataSource: locator.get<AuthLocalDataSource>(),
      authTokenHandler: locator.get<AuthTokenHandler>(),
    ),
  );
}
