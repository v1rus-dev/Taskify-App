import 'package:taskify/core/app_startup/app_startup_coordinator.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/auth/domain/repository/auth_repository.dart';
import 'package:taskify/features/friends/domain/usecases/friends_interactor.dart';
import 'package:taskify/features/friends/domain/usecases/friends_startup_task.dart';

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
