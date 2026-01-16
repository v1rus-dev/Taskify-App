import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:design/constants/app_icons.dart';

class EditTaskTimeButton extends StatelessWidget {
  const EditTaskTimeButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isEnabled;
  final VoidCallback onPressed;

  Color _getBackgroundColor() =>
      isEnabled ? Color(0xFF002FFF).withValues(alpha: 0.6) : Color(0xFFDEDEDE);
  Color _getIconColor() => isEnabled ? Colors.white : Color(0xFF898989);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: ColorFiltered(
                  key: ValueKey(_getIconColor()),
                  colorFilter: ColorFilter.mode(_getIconColor(), BlendMode.srcIn),
                  child: SvgPicture.asset(
                    AppIcons.clockPlus,
                    package: AppIcons.packageName,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
