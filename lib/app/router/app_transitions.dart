import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomUpTransitionPage<T> extends Page<T> {
  final Widget child;

  const BottomUpTransitionPage({required LocalKey key, required this.child})
    : super(key: key);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
    );
  }
}

CustomTransitionPage<dynamic> bottomUpTransitionBuilder(
  ValueKey<String> key,
  BuildContext context,
  Widget child,
) => CustomTransitionPage(
  key: key,
  child: child,
  barrierDismissible: true,
  opaque: false,
  maintainState: true,
  fullscreenDialog: false,
  transitionDuration: const Duration(milliseconds: 260),
  reverseTransitionDuration: const Duration(milliseconds: 260),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: Tween(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
      ),
      child: child,
    );
  },
);
