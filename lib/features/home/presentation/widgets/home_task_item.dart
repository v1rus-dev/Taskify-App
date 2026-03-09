import 'package:flutter/material.dart';
import 'package:taskify/features/home/presentation/widgets/sub_tasks_card.dart';
import 'package:taskify/features/home/presentation/widgets/task_card.dart';
import 'package:taskify/features/tasks/data/models/task_wrapper.dart';
import 'package:taskify/features/tasks/domain/models/sub_task.dart';
import 'package:taskify/l10n/app_localizations.dart';

class HomeTaskItem extends StatefulWidget {
  const HomeTaskItem({
    super.key,
    required this.task,
    required this.onTaskClicked,
    required this.onTaskCheckboxPressed,
    required this.onSubTaskCheckboxPressed,
  });

  final TaskWrapperEntity task;
  final VoidCallback onTaskClicked;
  final VoidCallback onTaskCheckboxPressed;
  final ValueChanged<SubTaskEntity> onSubTaskCheckboxPressed;

  @override
  State<HomeTaskItem> createState() => _HomeTaskItemState();
}

class _HomeTaskItemState extends State<HomeTaskItem> {
  static const int _collapsedSubTasksCount = 2;
  bool _isExpanded = false;

  List<SubTaskEntity> _visibleSubTasks() {
    if (_isExpanded || widget.task.subTasks.length <= _collapsedSubTasksCount) {
      return widget.task.subTasks;
    }
    return widget.task.subTasks.take(_collapsedSubTasksCount).toList();
  }

  String? _footerActionTitle(BuildContext context) {
    if (widget.task.subTasks.length <= _collapsedSubTasksCount) {
      return null;
    }
    final l10n = AppLocalizations.of(context);
    return _isExpanded ? l10n?.hideAll : l10n?.showAll;
  }

  void _onFooterActionPressed() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Widget? _buildBottomContent(BuildContext context) {
    if (widget.task.subTasks.isEmpty) {
      return null;
    }
    final visibleSubTasks = _visibleSubTasks();
    final footerActionTitle = _footerActionTitle(context);
    return SubTasksCard(
      subTasks: visibleSubTasks,
      onCheckboxPressed: widget.onSubTaskCheckboxPressed,
      footerActionTitle: footerActionTitle,
      onFooterActionPressed: footerActionTitle == null
          ? null
          : _onFooterActionPressed,
      isEmbedded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TaskCard(
      task: widget.task,
      onTaskClicked: widget.onTaskClicked,
      onCheckboxPressed: widget.onTaskCheckboxPressed,
      bottomContent: _buildBottomContent(context),
    );
  }
}
