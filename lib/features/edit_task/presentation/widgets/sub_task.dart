import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:design/constants/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubTask extends StatefulWidget {
  const SubTask({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onCheckboxPressed,
    required this.onTextChanged,
    this.hintText,
    this.focusNode,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
  });

  final String text;
  final bool isCompleted;
  final VoidCallback onCheckboxPressed;
  final ValueChanged<String> onTextChanged;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;

  @override
  State<SubTask> createState() => _SubTaskState();
}

class _SubTaskState extends State<SubTask> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant SubTask oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != _controller.text) {
      _controller.text = widget.text;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SubTaskCheckbox(
          isChecked: widget.isCompleted,
          onPressed: widget.onCheckboxPressed,
        ),
        const Gap(16),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: widget.focusNode,
            onChanged: widget.onTextChanged,
            onSubmitted: widget.onSubmitted,
            onEditingComplete: widget.onEditingComplete,
            textInputAction: widget.textInputAction,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColorExtensions.getTextPrimaryColor(context),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppColorExtensions.getTextSecondaryColor(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
