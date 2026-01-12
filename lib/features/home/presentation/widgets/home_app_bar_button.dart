import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:design/design.dart';

class HomeAppBarButton extends StatelessWidget {
  final String svgIconPath;
  final String? packageName;
  final VoidCallback? onPressed;

  const HomeAppBarButton({
    super.key,
    required this.svgIconPath,
    this.packageName,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppShadow(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              svgIconPath,
              package: packageName,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
