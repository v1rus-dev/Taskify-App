import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_state.dart';
import 'package:taskify/core/services/talker_service.dart';

final editTaskNotifierProvider = NotifierProvider.autoDispose<EditTaskNotifier, EditTaskState>(
  () => EditTaskNotifier(),
);

class EditTaskNotifier extends Notifier<EditTaskState> {

  EditTaskNotifier() : super() {
    TalkerService.instance.info('EditTaskNotifier initialized');
  }

  @override
  EditTaskState build() {
    return EditTaskState();
  }

  void deleteTask() {
    TalkerService.instance.info('Delete task');
  }
}
