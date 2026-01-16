import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/app_transitions.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_screen.dart';
import 'package:taskify/features/home/presentation/screen/home_screen.dart';
import 'package:taskify/features/settings/presentation/settings_screen.dart';
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
      pageBuilder: (context, state) => BottomUpTransitionPage(
        key: state.pageKey,
        child: EditTaskScreen(taskId: state.extra as int?),
      ),
    ),
    GoRoute(
      path: RouterPaths.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

