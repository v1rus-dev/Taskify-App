import 'package:flutter/material.dart';
import 'package:taskify/features/edit_task/presentation/widgets/sub_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_sub_task/edit_sub_task_bloc.dart';
import 'package:taskify/l10n/app_localizations.dart';

class SubTaskPart extends StatefulWidget {
  const SubTaskPart({super.key});

  @override
  State<SubTaskPart> createState() => _SubTaskPartState();
}

class _SubTaskPartState extends State<SubTaskPart> {
  final List<FocusNode> _focusNodes = [];
  final FocusNode _addFocusNode = FocusNode();
  int? _pendingFocusIndex;
  String _draftText = '';
  int _lastSubTaskCount = 0;
  bool _isAddFieldUnlocked = false;

  @override
  void initState() {
    super.initState();
    _addFocusNode.addListener(_onAddFocusChange);
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    _focusNodes.clear();
    _addFocusNode
      ..removeListener(_onAddFocusChange)
      ..dispose();
    super.dispose();
  }

  FocusNode _createFocusNode() {
    final node = FocusNode();
    node.addListener(_onAnyFocusChange);
    return node;
  }

  void _syncFocusNodes(int count) {
    if (_focusNodes.length == count) {
      return;
    }
    if (_focusNodes.length < count) {
      _focusNodes.addAll(
        List.generate(
          count - _focusNodes.length,
          (_) => _createFocusNode(),
        ),
      );
      return;
    }
    final removeCount = _focusNodes.length - count;
    for (int i = 0; i < removeCount; i++) {
      _focusNodes.removeLast().dispose();
    }
  }

  void _onAnyFocusChange() {
    if (!mounted) return;
    setState(() {});
  }

  void _onAddFocusChange() {
    if (!mounted) return;
    if (!_addFocusNode.hasFocus) {
      _commitDraftSubTask();
    }
    setState(() {});
  }

  void _onSubTaskSubmitted(int index, int subTaskCount) {
    if (index < subTaskCount - 1) {
      _focusNodes[index + 1].requestFocus();
      return;
    }
    _isAddFieldUnlocked = true;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _addFocusNode.requestFocus();
      }
    });
  }

  void _commitDraftSubTask() {
    final text = _draftText.trim();
    if (text.isEmpty) {
      return;
    }
    context.read<EditSubTaskBloc>().add(
      EditSubTaskEvent.subTaskTextChanged(_lastSubTaskCount, text),
    );
    _draftText = '';
    _isAddFieldUnlocked = true;
    if (mounted) {
      setState(() {});
    }
  }

  bool _shouldShowAddField(int subTaskCount) {
    if (subTaskCount == 0) {
      _isAddFieldUnlocked = true;
      return true;
    }
    if (_focusNodes.length < subTaskCount) {
      return _isAddFieldUnlocked;
    }
    if (!_focusNodes.last.hasFocus) {
      _isAddFieldUnlocked = true;
    }
    return _isAddFieldUnlocked;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_pendingFocusIndex != null) {
      final focusIndex = _pendingFocusIndex!;
      _pendingFocusIndex = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusIndex < _focusNodes.length) {
          _focusNodes[focusIndex].requestFocus();
        }
      });
    }

    return BlocBuilder<EditSubTaskBloc, EditSubTaskState>(
      builder: (context, state) {
        final subTasks = state.subTasks;
        final subTaskCount = subTasks.length;
        _lastSubTaskCount = subTaskCount;
        _syncFocusNodes(subTaskCount);
        final showAddField = _shouldShowAddField(subTaskCount);
        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: [
              ...List.generate(subTaskCount, (index) {
                final item = subTasks[index];

                return SubTask(
                  key: ValueKey('subtask_$index'),
                  text: item.title,
                  isCompleted: item.isCompleted,
                  focusNode: _focusNodes[index],
                  textInputAction: TextInputAction.next,
                  onCheckboxPressed: () {
                    context.read<EditSubTaskBloc>().add(
                      EditSubTaskEvent.subTaskToggle(index),
                    );
                  },
                  onTextChanged: (value) {
                    if (value.isEmpty) {
                      context.read<EditSubTaskBloc>().add(
                        EditSubTaskEvent.subTaskRemoved(index),
                      );
                      _pendingFocusIndex = index;
                      return;
                    }
                    context.read<EditSubTaskBloc>().add(
                      EditSubTaskEvent.subTaskTextChanged(index, value),
                    );
                  },
                  onSubmitted: (_) => _onSubTaskSubmitted(index, subTaskCount),
                  onEditingComplete:
                      () => _onSubTaskSubmitted(index, subTaskCount),
                );
              }),
              if (showAddField)
                SubTask(
                  key: const ValueKey('subtask_add'),
                  text: _draftText,
                  isCompleted: false,
                  hintText: l10n?.addSubTask ?? '',
                  focusNode: _addFocusNode,
                  textInputAction: TextInputAction.done,
                  onCheckboxPressed: () {},
                  onTextChanged: (value) => _draftText = value,
                  onSubmitted: (_) => _commitDraftSubTask(),
                  onEditingComplete: _commitDraftSubTask,
                ),
            ],
          ),
        );
      },
    );
  }
}
