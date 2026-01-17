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
  });

  final String text;
  final bool isCompleted;
  final VoidCallback onCheckboxPressed;
  final ValueChanged<String> onTextChanged;
  final String? hintText;
  final FocusNode? focusNode;

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

  Widget _buildCheckbox() {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: widget.onCheckboxPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: widget.isCompleted
              ? SizedBox(
                  key: const ValueKey('checked'),
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppIcons.subtaskCheckBoxChecked,
                    package: AppIcons.packageName,
                    fit: BoxFit.contain,
                  ),
                )
              : SizedBox(
                  key: const ValueKey('unchecked'),
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppIcons.subtaskCheckBoxEmpty,
                    package: AppIcons.packageName,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildCheckbox(),
        const Gap(16),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: widget.focusNode,
            onChanged: widget.onTextChanged,
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
