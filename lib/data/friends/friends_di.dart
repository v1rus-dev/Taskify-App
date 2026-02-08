import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/api/friends_api.dart';
import 'package:taskify/data/friends/datasources/friends_local_datasource.dart';
import 'package:taskify/data/friends/datasources/friends_network_datasource.dart';
import 'package:taskify/data/friends/repositories/friends_repository_impl.dart';
import 'package:taskify/core/network/network_info.dart';
import 'package:taskify/domain/friends/repository/friends_repository.dart';
import 'package:taskify/domain/friends/usecases/friends_interactor.dart';
import 'package:taskify/data/database/app_database.dart';

void initFriendsDependencies() {
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
}
