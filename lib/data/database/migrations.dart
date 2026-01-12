import 'package:drift/drift.dart';
import 'package:taskify/data/database/tables/tasks.dart';

/// Примеры миграций для базы данных
/// 
/// При изменении схемы базы данных:
/// 1. Увеличьте schemaVersion в AppDatabase
/// 2. Добавьте логику миграции в onUpgrade
/// 
/// Примеры:
/// 
/// Миграция 1 -> 2: Добавление нового поля
/// ```dart
/// if (from < 2) {
///   await m.addColumn(tasks, tasks.priority);
/// }
/// ```
/// 
/// Миграция 2 -> 3: Переименование колонки
/// ```dart
/// if (from < 3) {
///   await m.renameColumn(tasks, 'oldName', 'newName');
/// }
/// ```
/// 
/// Миграция 3 -> 4: Удаление колонки
/// ```dart
/// if (from < 4) {
///   await m.deleteColumn(tasks, tasks.oldColumn);
/// }
/// ```
