import 'package:taskify/core/app_startup/app_startup_coordinator.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/auth/repository/auth_repository.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';
import 'package:taskify/domain/friends/usecases/friends_startup_task.dart';

void initAppStartupDependencies() {
  locator.registerLazySingleton(
    () => FriendsStartupTask(locator<FriendsInteractor>()),
  );
  locator.registerLazySingleton<AppStartupCoordinator>(
    () => AppStartupCoordinator(
      tasks: [locator<FriendsStartupTask>()],
      authRepository: locator<AuthRepository>(),
    ),
  );
}
