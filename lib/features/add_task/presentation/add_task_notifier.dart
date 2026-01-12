import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/features/add_task/presentation/add_task_state.dart';
import 'package:taskify/infrastructure/services/talker_service.dart';

final addTaskNotifierProvider = NotifierProvider.autoDispose<AddTaskNotifier, AddTaskState>(
  () => AddTaskNotifier(),
);

class AddTaskNotifier extends Notifier<AddTaskState> {

  AddTaskNotifier() : super() {
    TalkerService.instance.info('AddTaskNotifier initialized');
  }

  @override
  AddTaskState build() {
    return AddTaskState();
  }
}