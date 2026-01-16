import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/entities/tasks_view_type.dart';
import 'package:taskify/features/home/presentation/providers/home_screen_notifier.dart';
import 'package:taskify/features/home/presentation/widgets/task_type_button.dart';
import 'package:taskify/features/home/presentation/widgets/home_calendar_part.dart';

class HomeHidedHeader extends ConsumerWidget {
  const HomeHidedHeader({super.key});

  void _onChangeTasksViewType(WidgetRef ref, TasksViewType tasksViewType) {
    ref.read(homeScreenNotifierProvider.notifier).changeTasksViewType(tasksViewType);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeScreenNotifierProvider);
    return Column(
      children: [
        HomeCalendarPart(),
        const Gap(32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              TaskTypeButton(
                tasksViewType: TasksViewType.tasks,
                isSelected: state.tasksViewType == TasksViewType.tasks,
                onPressed: () => _onChangeTasksViewType(ref, TasksViewType.tasks),
              ),
              const Gap(12),
              TaskTypeButton(
                tasksViewType: TasksViewType.timeline,
                isSelected: state.tasksViewType == TasksViewType.timeline,
                onPressed: () => _onChangeTasksViewType(ref, TasksViewType.timeline),
              ),
            ],
          ),
        ),
        const Gap(32),
      ],
    );
  }
}
