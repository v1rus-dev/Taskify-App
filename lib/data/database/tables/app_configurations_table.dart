import 'package:drift/drift.dart';

class AppConfigurationsTable extends Table {
  static const int defaultId = 0;

  IntColumn get id =>
      integer().withDefault(const Constant(defaultId))();
  BoolColumn get use24Hour => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
