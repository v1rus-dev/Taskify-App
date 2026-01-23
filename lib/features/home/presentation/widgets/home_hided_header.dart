import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/domain/tasks/models/tasks_view_type.dart';
import 'package:taskify/features/home/presentation/bloc/home_bloc.dart';
import 'package:taskify/features/home/presentation/widgets/task_type_button.dart';
import 'package:taskify/features/home/presentation/widgets/home_calendar_part.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHidedHeader extends StatelessWidget {
  const HomeHidedHeader({super.key});

  void _onChangeTasksViewType(BuildContext context, TasksViewType tasksViewType) {
    context.read<HomeBloc>().add(HomeEvent.changeTasksViewType(tasksViewType));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeBloc>().state;
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
                onPressed: () => _onChangeTasksViewType(context, TasksViewType.tasks),
              ),
              const Gap(12),
              TaskTypeButton(
                tasksViewType: TasksViewType.timeline,
                isSelected: state.tasksViewType == TasksViewType.timeline,
                onPressed: () => _onChangeTasksViewType(context, TasksViewType.timeline),
              ),
            ],
          ),
        ),
        const Gap(32),
      ],
    );
  }
}
