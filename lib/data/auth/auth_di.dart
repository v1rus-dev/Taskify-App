import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/api/auth_api.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'package:taskify/data/auth/repositories/auth_repository_impl.dart';
import 'package:taskify/data/auth/sources/auth_local_data_source.dart';
import 'package:taskify/data/auth/sources/auth_token_storage.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';

void initAuthStorageDependencies() {
  if (!locator.isRegistered<AuthTokenStorage>()) {
    locator.registerLazySingleton<AuthTokenStorage>(AuthTokenStorage.new);
  }
  if (!locator.isRegistered<AuthTokenHandler>()) {
    locator.registerLazySingleton<AuthTokenHandler>(
      () => locator<AuthTokenStorage>(),
    );
  }
  if (!locator.isRegistered<AuthLocalDataSource>()) {
    locator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(locator()),
    );
  }
}

void initAuthDependencies() {
  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authApi: locator.get<AuthApi>(),
        authLocalDataSource: locator.get<AuthLocalDataSource>(),
        authTokenStorage: locator.get<AuthTokenStorage>(),
      ),
    );
  }
}
