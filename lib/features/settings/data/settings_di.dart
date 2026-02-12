import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/settings/domain/usecases/app_configuration_interactor.dart';

void initSettingsDependencies() {
  locator.registerLazySingleton(
    () => AppConfigurationInteractor(locator<AppDatabase>()),
  );
}
