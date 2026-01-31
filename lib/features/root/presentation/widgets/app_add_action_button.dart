import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAddActionButton extends StatelessWidget {
  const AppAddActionButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: AppColorExtensions.getPrimaryAccentColor(context),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.add,
              package: AppIcons.packageName,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
