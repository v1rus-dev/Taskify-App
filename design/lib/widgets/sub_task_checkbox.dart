import 'package:design/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubTaskCheckbox extends StatelessWidget {
  const SubTaskCheckbox({
    super.key,
    required this.isChecked,
    required this.onPressed,
  });

  final bool isChecked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        onTap: onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isChecked
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
}
