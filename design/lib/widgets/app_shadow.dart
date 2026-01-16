import 'package:flutter/material.dart';

class AppShadow extends StatelessWidget {
  const AppShadow({
    super.key,
    required this.child,
    this.borderRadius,
  });

  final Widget child;
  final BorderRadius? borderRadius;

  static List<BoxShadow> get defaultShadow => [
        BoxShadow(
          offset: Offset.zero,
          blurRadius: 8,
          color: const Color(0xFF000000).withValues(alpha: 0.05),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.zero,
        boxShadow: defaultShadow,
      ),
      child: child,
    );
  }
}
