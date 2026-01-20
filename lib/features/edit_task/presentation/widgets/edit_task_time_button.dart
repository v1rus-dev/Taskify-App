import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:design/constants/app_icons.dart';

class EditTaskTimeButton extends StatelessWidget {
  const EditTaskTimeButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    this.showIndicator = false,
  });

  final bool isEnabled;
  final VoidCallback onPressed;
  final bool showIndicator;

  Color _getBackgroundColor() =>
      isEnabled ? Color(0xFF002FFF).withValues(alpha: 0.6) : Color(0xFFDEDEDE);
  Color _getIconColor() => isEnabled ? Colors.white : Color(0xFF898989);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: isEnabled ? onPressed : null,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: ColorFiltered(
                      key: ValueKey(_getIconColor()),
                      colorFilter: ColorFilter.mode(
                        _getIconColor(),
                        BlendMode.srcIn,
                      ),
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
          if (showIndicator)
            const Positioned(
              top: -0.5,
              right: -0.5,
              child: _EditTaskTimeIndicator(),
            ),
        ],
      ),
    );
  }
}

class _EditTaskTimeIndicator extends StatelessWidget {
  const _EditTaskTimeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        shape: BoxShape.circle,
      ),
    );
  }
}
