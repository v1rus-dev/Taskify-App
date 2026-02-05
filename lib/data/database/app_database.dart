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
import 'package:taskify/data/database/tables/incoming_friend_requests_table.dart';
import 'package:taskify/data/database/tables/outgoing_friend_requests_table.dart';
import 'package:taskify/core/services/talker_service.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  TasksTable,
  SubtasksTable,
  CustomTagsTable,
  TaskTagsTable,
  AppConfigurationsTable,
  UsersTable,
  SyncQueueTable,
  SyncStateTable,
  FriendsTable,
  IncomingFriendRequestsTable,
  OutgoingFriendRequestsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        TalkerService.instance.info('syncTag Database created');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        TalkerService.instance.info('syncTag Database upgrade from $from to $to');
        
        if (from < 2) {
          await m.createTable(appConfigurationsTable);
        }
        if (from < 3) {
          await m.createTable(usersTable);
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
