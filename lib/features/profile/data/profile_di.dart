import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/auth/sources/auth_local_data_source.dart';
import 'package:taskify/features/profile/data/repository/profile_repository.dart';

void initProfileDependencies() {
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      authLocalDataSource: locator<AuthLocalDataSource>(),
    ),
  );
}
