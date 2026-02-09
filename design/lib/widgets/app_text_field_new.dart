import 'package:flutter/material.dart';
import 'package:design/design.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';

class AppTextFieldNew extends StatelessWidget {
  const AppTextFieldNew({
    super.key,
    required this.hint,
    required this.controller,
    this.decoration,
    this.inputFormatters,
      this.trailing,
  });

  final String hint;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? trailing;

  void _onClearPressed() {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const clearButtonSize = 24.0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              inputFormatters: inputFormatters,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.textPrimaryColor,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final hasText = value.text.isNotEmpty;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: clearButtonSize,
                    height: clearButtonSize,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            axisAlignment: -1,
                            child: child,
                          ),
                        );
                      },
                      child: hasText
                          ? Material(
                              key: const ValueKey('clear_button'),
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _onClearPressed,
                                customBorder: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset(
                                    AppIcons.clear,
                                    package: AppIcons.packageName,
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(
                                      context.iconColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(key: ValueKey('clear_placeholder')),
                    ),
                  ),
                  if (trailing != null) ...[
                    if (hasText) const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
