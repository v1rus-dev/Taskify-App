import 'package:taskify/core/services/dio_client.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/api/auth_api.dart';

void initApiDependencies() {
  locator.registerLazySingleton(() => AuthApi(locator<DioClient>()));
}
