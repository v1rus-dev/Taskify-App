import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';

void initInteractors() {
  locator.registerLazySingleton(() => AppConfigurationInteractor(locator<AppDatabase>()));
}