import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/data/database/tables/app_configurations_table.dart';
import 'package:taskify/domain/entities/time_format_type.dart';

class AppConfigurationInteractor {
  AppConfigurationInteractor(this._db);

  final AppDatabase _db;

  Stream<AppConfigurationsTableData?> observeConfiguration() {
    return _db.select(_db.appConfigurationsTable).watchSingleOrNull();
  }

  Future<void> setTimeFormat(TimeFormatType type) async {
    await _db.into(_db.appConfigurationsTable).insertOnConflictUpdate(
          AppConfigurationsTableCompanion(
            id: const Value(AppConfigurationsTable.defaultId),
            use24Hour: Value(type.is24Hour),
          ),
        );
  }
}
