import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/home/presentation/widgets/home_calendar_part.dart';

class HomeHidedHeader extends StatelessWidget {
  const HomeHidedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeCalendarPart(),
        const Gap(32),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //   child: Row(
        //     children: [
        //       TaskTypeButton(
        //         tasksViewType: TasksViewType.tasks,
        //         isSelected: state.tasksViewType == TasksViewType.tasks,
        //         onPressed: () => _onChangeTasksViewType(context, TasksViewType.tasks),
        //       ),
        //       const Gap(12),
        //       TaskTypeButton(
        //         tasksViewType: TasksViewType.timeline,
        //         isSelected: state.tasksViewType == TasksViewType.timeline,
        //         onPressed: () => _onChangeTasksViewType(context, TasksViewType.timeline),
        //       ),
        //     ],
        //   ),
        // ),
        // const Gap(32),
      ],
    );
  }
}
