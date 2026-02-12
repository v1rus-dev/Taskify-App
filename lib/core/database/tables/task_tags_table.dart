import 'package:drift/drift.dart';

class TaskTagsTable extends Table {
  IntColumn get taskId => integer()();
  IntColumn get tagId => integer()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {taskId, tagId, isCustom};
}
