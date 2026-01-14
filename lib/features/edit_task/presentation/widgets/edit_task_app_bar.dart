import 'package:design/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_notifier.dart';

class EditTaskAppBar extends ConsumerWidget {
  const EditTaskAppBar({super.key});

  void _onClose(BuildContext context) {
    context.pop();
  }

  void _onDelete(BuildContext context, WidgetRef ref) {
    // TODO: Реализовать логику удаления задачи
    ref.read(editTaskNotifierProvider.notifier).deleteTask();
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaTop = mediaQuery.padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: safeAreaTop + 16.0,
        left: 12,
        right: 12,
        bottom: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconButton(
            iconPath: AppIcons.close,
            onPressed: () => _onClose(context),
          ),
          _buildIconButton(
            iconPath: AppIcons.trash,
            onPressed: () => _onDelete(context, ref),
          ),
        ],
      ),
    );
  }
}
