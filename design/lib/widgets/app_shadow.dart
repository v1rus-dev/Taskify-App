import 'package:flutter/material.dart';

class AppShadow extends StatelessWidget {
  const AppShadow({
    super.key,
    required this.child,
    this.enabled = true,
    this.borderRadius,
  });

  final Widget child;
  final bool enabled;
  final BorderRadius? borderRadius;

  static List<BoxShadow> get defaultShadow => [
        BoxShadow(
          offset: const Offset(0, 6),
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
        boxShadow: enabled ? defaultShadow : [],
      ),
      child: child,
    );
  }
}
