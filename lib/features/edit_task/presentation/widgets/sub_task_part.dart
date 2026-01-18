import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/providers/edit_task_notifier.dart';
import 'package:taskify/features/edit_task/presentation/widgets/sub_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task_bloc.dart';

class SubTaskPart extends StatefulWidget {
  const SubTaskPart({super.key});

  @override
  State<SubTaskPart> createState() => _SubTaskPartState();
}

class _SubTaskPartState extends State<SubTaskPart> {
  final List<FocusNode> _focusNodes = [];
  int? _pendingFocusIndex;

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    _focusNodes.clear();
    super.dispose();
  }

  void _syncFocusNodes(int count) {
    if (_focusNodes.length == count) {
      return;
    }
    if (_focusNodes.length < count) {
      _focusNodes.addAll(
        List.generate(count - _focusNodes.length, (_) => FocusNode()),
      );
      return;
    }
    final removeCount = _focusNodes.length - count;
    for (int i = 0; i < removeCount; i++) {
      _focusNodes.removeLast().dispose();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_pendingFocusIndex != null) {
      final focusIndex = _pendingFocusIndex!;
      _pendingFocusIndex = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusIndex < _focusNodes.length) {
          _focusNodes[focusIndex].requestFocus();
        }
      });
    }

    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        final loadedState = state.loadedOrNull;
        final subTasks = loadedState?.subTasks ?? [];
        final displayCount = subTasks.length + 1;
        _syncFocusNodes(displayCount);
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: List.generate(displayCount, (index) {
              final isPlaceholder = index == subTasks.length;
              final item = isPlaceholder ? null : subTasks[index];

              return SubTask(
                key: ValueKey('subtask_$index'),
                text: item?.title ?? '',
                isCompleted: item?.isCompleted ?? false,
                hintText: isPlaceholder ? 'Add sub task' : null,
                focusNode: _focusNodes[index],
                onCheckboxPressed: () {
                  if (!isPlaceholder) {
                    context.read<EditTaskBloc>().add(
                      EditTaskEvent.subTaskToggle(index),
                    );
                  }
                },
                onTextChanged: (value) {
                  if (!isPlaceholder && value.isEmpty) {
                    context.read<EditTaskBloc>().add(
                      EditTaskEvent.subTaskRemoved(index),
                    );
                    _pendingFocusIndex = index;
                    return;
                  }
                  context.read<EditTaskBloc>().add(
                    EditTaskEvent.subTaskTextChanged(index, value),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
