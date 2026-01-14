import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_screen.dart';
import 'package:taskify/features/home/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterPaths.home,
  routes: [
    GoRoute(
      path: RouterPaths.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouterPaths.editTask,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const EditTaskScreen(),
      ),
    ),
  ],
);

class CustomTransitionPage<T> extends Page<T> {
  final Widget child;

  const CustomTransitionPage({
    required LocalKey key,
    required this.child,
  }) : super(key: key);

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}