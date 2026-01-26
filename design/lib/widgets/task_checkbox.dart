import 'package:design/constants/animation_durations.dart';
import 'package:design/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    super.key,
    required this.isChecked,
    required this.onPressed,
  });

  final bool isChecked;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: AnimationDurations.defaultDuration,
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 100),
                child: isChecked
                    ? SvgPicture.asset(
                        AppIcons.fillChecked,
                        key: const ValueKey('checked'),
                        package: AppIcons.packageName,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          Color(0xFF27C255).withValues(alpha: 0.6),
                          BlendMode.srcIn,
                        ),
                      )
                    : SvgPicture.asset(
                        AppIcons.circle,
                        key: const ValueKey('circle'),
                        package: AppIcons.packageName,
                        width: 24,
                        height: 24,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
