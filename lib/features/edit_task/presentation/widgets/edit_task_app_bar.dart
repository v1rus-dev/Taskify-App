import 'dart:async';

import 'package:design/constants/app_icons.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EditTaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditTaskAppBar({
    super.key,
    required this.taskId,
    required this.onClose,
  });

  final int? taskId;
  final VoidCallback onClose;

  @override
  Size get preferredSize {
    return Size.fromHeight(AppInsets.toolbarHeight);
  }

  void _onDelete(BuildContext context, EditTaskBloc bloc) async {
    final completer = Completer<void>();
    // ref.read(editTaskNotifierProvider(taskId).notifier).onDeleteTask(taskId: taskId!, completer: completer);
    await completer.future;
    if (!context.mounted) return;
    context.pop();
  }

  Widget _buildIconButton({
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              package: AppIcons.packageName,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(Color(0xFFDEDEDE), BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }

  void _onTaskCheckBoxPressed(BuildContext context) {
    // context.read<EditTaskBloc>().add(EditTaskEvent.taskCheckBoxPressed());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaTop = mediaQuery.padding.top;

    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: safeAreaTop, left: 12.0, right: 12.0),
          decoration: BoxDecoration(
            color: AppColorExtensions.getBackgroundColor(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconButton(iconPath: AppIcons.close, onPressed: onClose),
              Row(
                children: [
                  if (taskId != null) ...[
                    _buildIconButton(
                      iconPath: AppIcons.trash,
                      onPressed: () =>
                          _onDelete(context, context.read<EditTaskBloc>()),
                    ),
                  ],
                  const Gap(4),
                  TaskCheckbox(
                    isChecked: state.isCompleted,
                    onPressed: () => _onTaskCheckBoxPressed(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
