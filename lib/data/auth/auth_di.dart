import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/api/auth_api.dart';
import 'package:taskify/data/auth/repositories/auth_repository_impl.dart';
import 'package:taskify/domain/auth/repositories/auth_repository.dart';

void initAuthDependencies() {
  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authApi: locator.get<AuthApi>()),
    );
  }
}
