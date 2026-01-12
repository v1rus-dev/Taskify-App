import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/add_task/presentation/add_task_notifier.dart';

class AddTaskScreen extends ConsumerWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Создаем Notifier при открытии экрана
    ref.watch(addTaskNotifierProvider);
    
    return const Scaffold(
      body: Center(
        child: Text('Add Task Screen'),
      ),
    );
  }
}