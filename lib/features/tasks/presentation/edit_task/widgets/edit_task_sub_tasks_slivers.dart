import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskify/features/tasks/presentation/edit_sub_task/bloc/edit_sub_task_bloc.dart';
import 'package:taskify/features/tasks/presentation/models/sub_task_model_ui.dart';
import 'package:taskify/l10n/app_localizations.dart';

class EditTaskSubTasksSlivers extends StatelessWidget {
  const EditTaskSubTasksSlivers({super.key});

  void _onReorder(BuildContext context, int oldIndex, int newIndex) {
    context.read<EditSubTaskBloc>().add(
      EditSubTaskReordered(oldIndex, newIndex),
    );
  }

  void _onAddSubTaskPressed(BuildContext context) {
    context.read<EditSubTaskBloc>().add(const EditSubTaskAdded());
  }

  void _onSubTaskDismissed(BuildContext context, int localKey) {
    context.read<EditSubTaskBloc>().add(EditSubTaskRemovedByLocalKey(localKey));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSubTaskBloc, EditSubTaskState>(
      builder: (context, state) {
        final hasItems = state.subTasks.isNotEmpty;
        return SliverMainAxisGroup(
          slivers: [
            if (hasItems)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverReorderableList(
                  itemCount: state.subTasks.length,
                  onReorder: (oldIndex, newIndex) =>
                      _onReorder(context, oldIndex, newIndex),
                  itemBuilder: (context, index) {
                    final subTask = state.subTasks[index];
                    final isFirst = index == 0;
                    final isLast = index == state.subTasks.length - 1;
                    final radius = _resolveItemRadius(isFirst, isLast);
                    return Dismissible(
                      key: ValueKey('dismiss_${subTask.localKey}'),
                      direction: DismissDirection.endToStart,
                      background: _SwipeDeleteBackground(radius: radius),
                      onDismissed: (_) =>
                          _onSubTaskDismissed(context, subTask.localKey),
                      child: _EditSubTaskItem(
                        subTask: subTask,
                        isFirst: isFirst,
                        showBottomDivider: !isLast,
                        autoFocus: subTask.title.isEmpty,
                        onToggle: () => context.read<EditSubTaskBloc>().add(
                          EditSubTaskToggle(index),
                        ),
                        onTextChanged: (text) => context
                            .read<EditSubTaskBloc>()
                            .add(EditSubTaskTextChanged(index, text)),
                        onEmptyFocusLost: () =>
                            _onSubTaskDismissed(context, subTask.localKey),
                        dragIndex: index,
                      ),
                    );
                  },
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: _AddSubTaskRow(
                  isStandalone: !hasItems,
                  onPressed: () => _onAddSubTaskPressed(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  BorderRadius _resolveItemRadius(bool isFirst, bool isLast) {
    if (!isFirst) {
      return BorderRadius.zero;
    }
    return BorderRadius.vertical(
      top: Radius.circular(AppRadius.defaultCardRadius),
    );
  }
}

class _EditSubTaskItem extends StatefulWidget {
  const _EditSubTaskItem({
    required this.subTask,
    required this.isFirst,
    required this.showBottomDivider,
    required this.autoFocus,
    required this.onToggle,
    required this.onTextChanged,
    required this.onEmptyFocusLost,
    required this.dragIndex,
  });

  final SubTaskModelUi subTask;
  final bool isFirst;
  final bool showBottomDivider;
  final bool autoFocus;
  final VoidCallback onToggle;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onEmptyFocusLost;
  final int dragIndex;

  @override
  State<_EditSubTaskItem> createState() => _EditSubTaskItemState();
}

class _EditSubTaskItemState extends State<_EditSubTaskItem> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _requestedFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.subTask.title);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _requestFocusIfNeeded();
  }

  @override
  void didUpdateWidget(covariant _EditSubTaskItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subTask.title != widget.subTask.title &&
        _controller.text != widget.subTask.title) {
      _controller.text = widget.subTask.title;
      _controller.selection = TextSelection.collapsed(
        offset: widget.subTask.title.length,
      );
    }
    _requestFocusIfNeeded();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _requestFocusIfNeeded() {
    if (!widget.autoFocus || _requestedFocus) {
      return;
    }
    _requestedFocus = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      return;
    }
    if (_controller.text.trim().isEmpty) {
      widget.onEmptyFocusLost();
    }
  }

  BorderRadius _resolveRadius() {
    return widget.isFirst
        ? BorderRadius.vertical(
            top: Radius.circular(AppRadius.defaultCardRadius),
          )
        : BorderRadius.zero;
  }

  Color _resolveTextColor(BuildContext context) {
    final base = AppColorExtensions.getTextPrimaryColor(context);
    return widget.subTask.isCompleted ? base.withValues(alpha: 0.4) : base;
  }

  TextDecoration? _resolveDecoration() {
    return widget.subTask.isCompleted ? TextDecoration.lineThrough : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = AppColorExtensions.getCardColor(context);
    final dividerColor = AppColorExtensions.getDividerColor(context);
    final textColor = _resolveTextColor(context);

    return Material(
      color: cardColor,
      borderRadius: _resolveRadius(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TaskCheckbox(
                    isChecked: widget.subTask.isCompleted,
                    onPressed: widget.onToggle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextField(
                      onChanged: widget.onTextChanged,
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        decoration: _resolveDecoration(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ReorderableDragStartListener(
                  index: widget.dragIndex,
                  child: SvgPicture.asset(
                    AppIcons.dragVertical,
                    package: AppIcons.packageName,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColorExtensions.getTextSecondaryColor(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.showBottomDivider)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, thickness: 1, color: dividerColor),
            ),
        ],
      ),
    );
  }
}

class _SwipeDeleteBackground extends StatelessWidget {
  const _SwipeDeleteBackground({required this.radius});

  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        color: AppColorExtensions.getErrorColor(context),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: SvgPicture.asset(
          AppIcons.trash,
          package: AppIcons.packageName,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _AddSubTaskRow extends StatelessWidget {
  const _AddSubTaskRow({required this.isStandalone, required this.onPressed});

  final bool isStandalone;
  final VoidCallback onPressed;

  BorderRadius _resolveRadius() {
    return isStandalone
        ? BorderRadius.circular(AppRadius.defaultCardRadius)
        : BorderRadius.vertical(
            bottom: Radius.circular(AppRadius.defaultCardRadius),
          );
  }

  void _onPressed() {
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = AppColorExtensions.getDividerColor(context);
    final cardColor = AppColorExtensions.getCardColor(context);
    final textColor = AppColorExtensions.getTextSecondaryColor(context);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: _resolveRadius(),
      ),
      child: Column(
        children: [
          if (!isStandalone)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1, thickness: 1, color: dividerColor),
            ),
          Material(
            color: Colors.transparent,
            borderRadius: _resolveRadius(),
            child: InkWell(
              onTap: _onPressed,
              borderRadius: _resolveRadius(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)?.addSubTask ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      AppIcons.addSmall,
                      package: AppIcons.packageName,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
