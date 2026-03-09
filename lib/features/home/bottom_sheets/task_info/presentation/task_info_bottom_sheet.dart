import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _TaskInfoBottomSheetContent extends StatefulWidget {
  final int taskId;

  const _TaskInfoBottomSheetContent({required this.taskId});

  @override
  State<_TaskInfoBottomSheetContent> createState() =>
      _TaskInfoBottomSheetContentState();
}

class _TaskInfoBottomSheetContentState
    extends State<_TaskInfoBottomSheetContent> {
  static const double _maxSheetHeightFactor = 0.82;
  static const double _initialDraggableSize = 1.0;
  static const double _minDraggableSize = 0.5;

  final GlobalKey _measureKey = GlobalKey();

  double? _measuredContentHeight;

  void _onTaskCheckBoxPressed(BuildContext context) {
    context.read<TaskInfoBloc>().add(const TaskInfoTaskCheckBoxPressed());
  }

  void _onEditPressed() {
    if (appRouter.canPop()) {
      appRouter.pop();
    }
    appRouter.push(RouterPaths.editTask, extra: widget.taskId);
  }

  void _scheduleMeasurement() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox =
          _measureKey.currentContext?.findRenderObject() as RenderBox?;
      final height = renderBox?.size.height;
      if (height == null || height == _measuredContentHeight) {
        return;
      }
      setState(() {
        _measuredContentHeight = height;
      });
    });
  }

  Widget _buildSections(TaskInfoSuccess state) {
    final task = state.task;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TaskInfoHeaderPart(
          task: task,
          onCheckBoxPressed: () => _onTaskCheckBoxPressed(context),
        ),
        TaskInfoTagsPart(tags: task.tags),
        TaskInfoDescriptionPart(description: task.task.description ?? ''),
        TaskInfoSubTasksPart(subTasks: task.subTasks),
      ],
    );
  }

  Widget _buildFooter(String editTitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(24),
        AppSecondaryButton(title: editTitle, onPressed: _onEditPressed),
      ],
    );
  }

  Widget _buildCompactSheet(TaskInfoSuccess state, String editTitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_buildSections(state), _buildFooter(editTitle)],
    );
  }

  Widget _buildDraggableSheet(
    TaskInfoSuccess state,
    String editTitle,
    double maxSheetHeight,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: DraggableScrollableSheet(
        expand: false,
        maxChildSize: 1.0,
        minChildSize: _minDraggableSize,
        initialChildSize: _initialDraggableSize,
        shouldCloseOnMinExtent: true,
        builder: (context, scrollController) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _buildSections(state),
                ),
              ),
              _buildFooter(editTitle),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<TaskInfoBloc, TaskInfoState>(
      builder: (context, state) {
        if (state is! TaskInfoSuccess) {
          return const SizedBox.shrink();
        }

        _scheduleMeasurement();

        final maxSheetHeight =
            MediaQuery.sizeOf(context).height * _maxSheetHeightFactor;
        final editTitle = l10n?.edit ?? '';
        final compactSheet = _buildCompactSheet(state, editTitle);
        final shouldUseCompactSheet =
            (_measuredContentHeight ?? maxSheetHeight + 1) <= maxSheetHeight;

        return Padding(
          padding: EdgeInsets.only(bottom: AppInsets.sheetVertical),
          child: Stack(
            children: [
              Offstage(
                child: KeyedSubtree(key: _measureKey, child: compactSheet),
              ),
              shouldUseCompactSheet
                  ? compactSheet
                  : _buildDraggableSheet(state, editTitle, maxSheetHeight),
            ],
          ),
        );
      },
    );
  }
}
