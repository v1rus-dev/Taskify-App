import 'package:animated_visibility/animated_visibility.dart';
import 'package:design/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
    
class ColorCard extends StatelessWidget {
  const ColorCard({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final ValueChanged<Color> onTap;
  final bool isSelected;

  void _onPressed() {
    onTap(color);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 54,
          height: 54,
          child: Center(
            child: AnimatedVisibility(
              visible: isSelected,
              exitDuration: const Duration(milliseconds: 160),
              enterDuration: const Duration(milliseconds: 160),
              enter: fadeIn() + scaleIn(),
              exit: fadeOut() + scaleOut(),
              child: SvgPicture.asset(
                AppIcons.checkFilled,
                width: 24,
                height: 24,
                package: AppIcons.packageName,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
