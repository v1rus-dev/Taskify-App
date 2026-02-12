import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/auth/data/sources/auth_local_data_source.dart';
import 'package:taskify/features/friends/domain/usecases/regenerate_friend_tag_use_case.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';
import 'package:taskify/features/profile/domain/usecases/update_friend_code_interactor.dart';

void initProfileDependencies() {
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      authLocalDataSource: locator<AuthLocalDataSource>(),
      regenerateFriendTagUseCase: locator<RegenerateFriendTagUseCase>(),
    ),
  );
  locator.registerLazySingleton(
    () => UpdateFriendCodeInteractor(locator<ProfileRepository>()),
  );
}
