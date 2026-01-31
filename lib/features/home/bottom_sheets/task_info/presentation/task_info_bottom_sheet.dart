import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design/design.dart';
import 'package:gap/gap.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/bloc/task_info_bloc.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/widgets/task_info_description_part.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/widgets/task_info_header_part.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/widgets/task_info_sub_tasks_part.dart';
import 'package:taskify/features/home/bottom_sheets/task_info/presentation/widgets/task_info_tags_part.dart';
import 'package:taskify/l10n/app_localizations.dart';

class TaskInfoBottomSheet extends StatelessWidget {
  final int taskId;

  const TaskInfoBottomSheet({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskInfoBloc(
        taskId: taskId,
        taskInteractor: locator(),
        subTaskInteractor: locator(),
      )..add(const TaskInfoStarted()),
      child: _TaskInfoBottomSheetContent(taskId: taskId),
    );
  }
}

class _TaskInfoBottomSheetContent extends StatelessWidget {
  final int taskId;

  const _TaskInfoBottomSheetContent({required this.taskId});

  void _onTaskCheckBoxPressed(BuildContext context) {
    context.read<TaskInfoBloc>().add(const TaskInfoTaskCheckBoxPressed());
  }

  void _onEditPressed() {
    if (appRouter.canPop()) {
      appRouter.pop();
    }
    appRouter.push(RouterPaths.editTask, extra: taskId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<TaskInfoBloc, TaskInfoState>(
      builder: (context, state) {
        if (state is! TaskInfoSuccess) {
          return const SizedBox.shrink();
        }
        final task = state.task;
        return Padding(
          padding: EdgeInsets.only(bottom: AppInsets.sheetVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TaskInfoHeaderPart(
                task: task,
                onCheckBoxPressed: () => _onTaskCheckBoxPressed(context),
              ),
              TaskInfoTagsPart(tags: task.tags),
              TaskInfoDescriptionPart(
                description: task.task.description ?? '',
              ),
              TaskInfoSubTasksPart(subTasks: task.subTasks),
              const Gap(24),
              AppSecondaryButton(
                title: l10n?.edit ?? '',
                onPressed: _onEditPressed,
              ),
            ],
          ),
        );
      },
    );
  }
}
