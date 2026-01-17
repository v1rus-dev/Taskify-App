import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_notifier.dart';

class EditTaskTagsPart extends ConsumerWidget {
  const EditTaskTagsPart({
    super.key,
    this.taskId,
  });

  final int? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editTaskNotifierProvider(taskId));
    return SizedBox(
      height: 24,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.subTasks.length,
        itemBuilder: (context, index) {
          final tag = state.subTasks[index];
          return Container(
            height: 24,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).chipTheme.backgroundColor ?? Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tag.title,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
