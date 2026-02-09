import 'package:drift/drift.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/tags/models/default_tag.dart';
import 'package:taskify/features/activity/domain/models/activity_date_utils.dart';
import 'package:taskify/features/activity/domain/models/activity_models.dart';

abstract class ActivityLocalDataSource {
  Stream<Map<DateTime, int>> observeCompletedCountByDate({
    required DateTime from,
    required DateTime to,
  });

  Stream<List<ActivityTopTag>> observeTopTagsByCompletedTasks({
    required DateTime from,
    required DateTime to,
    int limit = 3,
  });
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  ActivityLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<Map<DateTime, int>> observeCompletedCountByDate({
    required DateTime from,
    required DateTime to,
  }) {
    final normalizedFrom = activityDay(from);
    final normalizedTo = activityDay(to);
    final toExclusive = normalizedTo.add(const Duration(days: 1));
    final tasks = _database.tasksTable;
    final groupedDate = tasks.date;
    final completedCount = tasks.id.count();

    final query = _database.selectOnly(tasks)
      ..addColumns([groupedDate, completedCount])
      ..where(
        tasks.isCompleted.equals(true) &
            tasks.deletedAt.isNull() &
            tasks.date.isBiggerOrEqualValue(normalizedFrom) &
            tasks.date.isSmallerThanValue(toExclusive),
      )
      ..groupBy([groupedDate]);

    return query.watch().map((rows) {
      final completedByDate = <DateTime, int>{};
      for (final row in rows) {
        final rawDate = row.read(groupedDate);
        final count = row.read(completedCount) ?? 0;
        if (rawDate == null || count <= 0) {
          continue;
        }
        final date = activityDay(rawDate);
        completedByDate[date] = (completedByDate[date] ?? 0) + count;
      }
      return completedByDate;
    });
  }

  @override
  Stream<List<ActivityTopTag>> observeTopTagsByCompletedTasks({
    required DateTime from,
    required DateTime to,
    int limit = 3,
  }) {
    final normalizedFrom = activityDay(from);
    final normalizedTo = activityDay(to);
    final toExclusive = normalizedTo.add(const Duration(days: 1));

    final query = _database
        .customSelect(
          '''
      SELECT
        tt.tag_id AS tag_id,
        tt.is_custom AS is_custom,
        COUNT(*) AS usage_count,
        MAX(ct.title) AS custom_title,
        MAX(ct.color_value) AS custom_color
      FROM task_tags_table tt
      INNER JOIN tasks_table t ON t.id = tt.task_id
      LEFT JOIN custom_tags_table ct
        ON ct.id = tt.tag_id
       AND tt.is_custom = 1
      WHERE t.is_completed = 1
        AND t.deleted_at IS NULL
        AND t.date >= ?
        AND t.date < ?
      GROUP BY tt.tag_id, tt.is_custom
      ORDER BY usage_count DESC, tt.tag_id ASC
      LIMIT ?
      ''',
          variables: [
            Variable<DateTime>(normalizedFrom),
            Variable<DateTime>(toExclusive),
            Variable<int>(limit),
          ],
          readsFrom: {
            _database.taskTagsTable,
            _database.tasksTable,
            _database.customTagsTable,
          },
        )
        .watch();

    return query.map((rows) {
      final result = <ActivityTopTag>[];
      for (final row in rows) {
        final tagId = row.read<int>('tag_id');
        final isCustom = row.read<bool>('is_custom');
        final usageCount = row.read<int>('usage_count');

        if (usageCount <= 0) {
          continue;
        }

        if (isCustom) {
          final title = row.readNullable<String>('custom_title');
          final color = row.readNullable<int>('custom_color');
          if (title == null || color == null) {
            continue;
          }
          result.add(
            ActivityTopTag(
              tagId: tagId,
              isCustom: true,
              title: title,
              colorValue: color,
              usageCount: usageCount,
            ),
          );
          continue;
        }

        final defaultTag = DefaultTagExtension.fromId(tagId);
        if (defaultTag == null) {
          continue;
        }
        result.add(
          ActivityTopTag(
            tagId: tagId,
            isCustom: false,
            title: defaultTag.title,
            colorValue: defaultTag.color.toARGB32(),
            usageCount: usageCount,
          ),
        );
      }
      return result;
    });
  }
}
