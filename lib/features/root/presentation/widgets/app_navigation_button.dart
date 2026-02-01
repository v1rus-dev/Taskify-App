import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNavigationButton extends StatelessWidget {
  const AppNavigationButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.packageName,
    required this.isSelected,
    required this.onPressed,
  });

  final String title;
  final String iconPath;
  final String packageName;
  final bool isSelected;
  final VoidCallback onPressed;

  Color _getColor(BuildContext context) =>
      isSelected ? context.primaryAccentColor : context.primarySecondaryColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                package: packageName,
                colorFilter: ColorFilter.mode(
                  _getColor(context),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
