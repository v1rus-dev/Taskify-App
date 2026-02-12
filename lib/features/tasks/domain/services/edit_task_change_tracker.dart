import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/tasks/data/models/task_entity.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_date_calculator.dart';
import 'package:taskify/features/tasks/domain/services/edit_task_snapshots.dart';

class EditTaskChangeTracker {
  EditTaskChangeTracker({
    required DateSelectionSnapshot initialSelection,
    EditTaskDateCalculator? dateCalculator,
  })  : _initialSelection = initialSelection,
        _dateCalculator = dateCalculator ?? const EditTaskDateCalculator();

  final EditTaskDateCalculator _dateCalculator;
  DateSelectionSnapshot _initialSelection;
  DateTime? _createdAt;
  EditTaskSnapshot? _lastSavedTaskSnapshot;
  List<String> _lastSavedTagKeys = const [];
  List<SubTaskSnapshot> _lastSavedSubTaskSnapshots = const [];

  DateSelectionSnapshot get initialSelection => _initialSelection;
  DateTime? get createdAt => _createdAt;

  void updateAfterLoad({
    required TaskEntity task,
    required List<TagEntity> tags,
  }) {
    _createdAt = task.createdAt;
    _lastSavedTaskSnapshot = EditTaskSnapshot.fromTask(task);
    _lastSavedTagKeys = _sortedTagKeys(tags);
    _lastSavedSubTaskSnapshots = const [];
    _initialSelection = DateSelectionSnapshot(
      selectedDate: task.date,
      isAllDay: task.isAllDay,
      startTime: task.startTime,
      endTime: task.endTime,
    );
  }

  void updateAfterSave({
    required TaskEntity savedTask,
    required EditTaskSnapshot snapshot,
    required List<TagEntity> tags,
    required List<SubTaskSnapshot> subTasks,
  }) {
    _createdAt = savedTask.createdAt;
    _lastSavedTaskSnapshot = snapshot;
    _lastSavedTagKeys = _sortedTagKeys(tags);
    _lastSavedSubTaskSnapshots = subTasks;
  }

  bool isDateModified(DateSelectionSnapshot current) {
    return _dateCalculator.isDateModified(
      current: current,
      initial: _initialSelection,
    );
  }

  bool isSnapshotEmpty({
    required String title,
    required String description,
    required List<TagEntity> tags,
    required List<SubTaskSnapshot> subTasks,
  }) {
    if (title.trim().isNotEmpty) {
      return false;
    }
    if (description.trim().isNotEmpty) {
      return false;
    }
    if (tags.isNotEmpty) {
      return false;
    }
    return subTasks.every((item) => item.title.trim().isEmpty);
  }

  bool shouldSave({
    required EditTaskSnapshot snapshot,
    required List<TagEntity> tags,
    required List<SubTaskSnapshot> subTasks,
  }) {
    if (isSnapshotEmpty(
      title: snapshot.title,
      description: snapshot.description,
      tags: tags,
      subTasks: subTasks,
    )) {
      return false;
    }
    if (snapshot.title.trim().isEmpty) {
      return false;
    }
    if (_lastSavedTaskSnapshot == null) {
      return true;
    }
    return isTaskChanged(snapshot) ||
        areTagsChanged(tags) ||
        areSubTasksChanged(subTasks);
  }

  bool isTaskChanged(EditTaskSnapshot snapshot) {
    return _lastSavedTaskSnapshot != snapshot;
  }

  bool areTagsChanged(List<TagEntity> tags) {
    return !_areTagKeysEqual(_lastSavedTagKeys, _sortedTagKeys(tags));
  }

  bool areSubTasksChanged(List<SubTaskSnapshot> subTasks) {
    return !_areSubTaskSnapshotsEqual(_lastSavedSubTaskSnapshots, subTasks);
  }

  List<String> _sortedTagKeys(List<TagEntity> tags) {
    final keys = tags.map((tag) => tag.key).toList()..sort();
    return keys;
  }

  bool _areTagKeysEqual(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var i = 0; i < left.length; i += 1) {
      if (left[i] != right[i]) {
        return false;
      }
    }
    return true;
  }

  bool _areSubTaskSnapshotsEqual(
    List<SubTaskSnapshot> left,
    List<SubTaskSnapshot> right,
  ) {
    if (left.length != right.length) {
      return false;
    }
    for (var i = 0; i < left.length; i += 1) {
      if (left[i] != right[i]) {
        return false;
      }
    }
    return true;
  }
}

