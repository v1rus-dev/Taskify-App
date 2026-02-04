import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/data/api/auth_api.dart';
import 'package:taskify/data/api/friends_api.dart';

void initApiDependencies() {
  locator.registerLazySingleton(() => AuthApi(locator<DioClient>()));
  locator.registerLazySingleton(() => FriendsApi(locator<DioClient>()));
}
