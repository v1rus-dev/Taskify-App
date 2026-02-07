import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:taskify/data/database/tables/app_configurations_table.dart';
import 'package:taskify/data/database/tables/custom_tags_table.dart';
import 'package:taskify/data/database/tables/tasks_table.dart';
import 'package:taskify/data/database/tables/subtasks_table.dart';
import 'package:taskify/data/database/tables/task_tags_table.dart';
import 'package:taskify/data/database/tables/users_table.dart';
import 'package:taskify/data/database/tables/sync_queue_table.dart';
import 'package:taskify/data/database/tables/sync_state_table.dart';
import 'package:taskify/data/database/tables/friends_table.dart';
import 'package:taskify/data/database/tables/friend_requests_table.dart';
import 'package:taskify/core/services/talker_service.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    TasksTable,
    SubtasksTable,
    CustomTagsTable,
    TaskTagsTable,
    AppConfigurationsTable,
    UsersTable,
    SyncQueueTable,
    SyncStateTable,
    FriendsTable,
    FriendRequestsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        TalkerService.instance.info('syncTag Database created');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        TalkerService.instance.info(
          'syncTag Database upgrade from $from to $to',
        );

        if (from < 2) {
          await m.createTable(appConfigurationsTable);
        }
        if (from < 3) {
          await m.createTable(usersTable);
        }
        if (from < 4) {
          await m.createTable(friendsTable);
          await m.createTable(friendRequestsTable);
        }
        if (from < 5) {
          await m.database.customStatement(
            'DROP TABLE IF EXISTS incoming_friend_requests_table;',
          );
          await m.database.customStatement(
            'DROP TABLE IF EXISTS outgoing_friend_requests_table;',
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'taskify.db'));

    TalkerService.instance.info('syncTag Database path: ${file.path}');

    return NativeDatabase(file);
  });
}
