import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/core/network/network_info.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/friends/data/api/friends_api.dart';
import 'package:taskify/features/friends/data/sources/friends_local_datasource.dart';
import 'package:taskify/features/friends/data/sources/friends_network_datasource.dart';
import 'package:taskify/features/friends/data/repositories/friends_repository_impl.dart';
import 'package:taskify/features/friends/domain/repository/friends_repository.dart';
import 'package:taskify/features/friends/domain/usecases/friends_interactor.dart';
import 'package:taskify/features/friends/domain/usecases/regenerate_friend_tag_use_case.dart';

void initFriendsDependencies() {
  locator.registerLazySingleton(() => FriendsApi(locator<DioClient>()));
  locator.registerLazySingleton<FriendsNetworkDataSource>(
    () => FriendsNetworkDataSourceImpl(locator<FriendsApi>()),
  );
  locator.registerLazySingleton<FriendsLocalDataSource>(
    () => FriendsLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<FriendsRepository>(
    () => FriendsRepositoryImpl(
      networkDataSource: locator<FriendsNetworkDataSource>(),
      localDataSource: locator<FriendsLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton(
    () =>
        FriendsInteractor(locator<FriendsRepository>(), locator<NetworkInfo>()),
  );
  locator.registerLazySingleton(
    () => RegenerateFriendTagUseCase(locator<FriendsInteractor>()),
  );
}
