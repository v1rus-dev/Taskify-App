import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/auth/access_token_provider.dart';
import 'package:taskify/data/api/friends_api.dart';
import 'package:taskify/features/friends_list/data/datasources/friends_network_datasource.dart';
import 'package:taskify/features/friends_list/data/repositories/friends_repository.dart';
import 'package:taskify/features/friends_list/domain/usecases/friends_interactor.dart';

void initFriendsListDependencies() {
  locator.registerLazySingleton<FriendsNetworkDataSource>(
    () => FriendsNetworkDataSourceImpl(locator<FriendsApi>()),
  );
  locator.registerLazySingleton<FriendsRepository>(
    () => FriendsRepositoryImpl(
      networkDataSource: locator<FriendsNetworkDataSource>(),
      authTokenHandler: locator<AuthTokenHandler>(),
    ),
  );
  locator.registerLazySingleton(
    () => FriendsInteractor(locator<FriendsRepository>()),
  );
}
