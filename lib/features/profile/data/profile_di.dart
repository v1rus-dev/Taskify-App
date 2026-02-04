import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/auth/sources/auth_local_data_source.dart';
import 'package:taskify/data/api/friends_api.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';
import 'package:taskify/features/profile/domain/usecases/update_friend_code_interactor.dart';

void initProfileDependencies() {
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      authLocalDataSource: locator<AuthLocalDataSource>(),
      friendsApi: locator<FriendsApi>(),
    ),
  );
  locator.registerLazySingleton(
    () => UpdateFriendCodeInteractor(locator<ProfileRepository>()),
  );
}
