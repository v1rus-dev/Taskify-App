import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/app_transitions.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_screen.dart';
import 'package:taskify/features/home/presentation/screen/home_screen.dart';
import 'package:taskify/features/settings/presentation/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterPaths.home,
  routes: [
    GoRoute(
      path: RouterPaths.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouterPaths.editTask,
      pageBuilder: (context, state) {
        final taskId = state.extra as int?;
        return bottomUpTransitionBuilder(
          ValueKey('editTask-$taskId'),
          context,
          EditTaskPage(taskId: taskId),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
