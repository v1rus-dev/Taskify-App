import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/bloc/task_info_bloc.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/widgets/task_info_sub_tasks_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskInfoSubTasksPart extends StatelessWidget {
  const TaskInfoSubTasksPart({super.key, required this.subTasks});

  final List<SubTaskEntity> subTasks;

  void _onCheckboxPressed(BuildContext context, SubTaskEntity subTask) {
    context.read<TaskInfoBloc>().add(
      TaskInfoSubTaskCheckBoxPressed(subTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(20),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppInsets.sheetHorizontalSmall,
          ),
          child: TaskInfoSubTasksCard(
            subTasks: subTasks,
            onCheckboxPressed: (subTask) =>
                _onCheckboxPressed(context, subTask),
          ),
        ),
      ],
    );
  }
}

