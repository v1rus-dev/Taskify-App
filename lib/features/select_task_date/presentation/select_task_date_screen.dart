import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:taskify/features/select_task_date/presentation/providers/select_task_notifier.dart';

class SelectTaskDateScreen extends ConsumerWidget {
  final DateTime? selectedDate;
  final bool? isAllDay;

  const SelectTaskDateScreen({super.key, this.selectedDate, this.isAllDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectTaskNotifierProvider((selectedDate, isAllDay)));
    final notifier = ref.read(
      selectTaskNotifierProvider((selectedDate, isAllDay)).notifier,
    );

    return const Scaffold(body: Center(child: Text('Select Task Date')));
  }
}
