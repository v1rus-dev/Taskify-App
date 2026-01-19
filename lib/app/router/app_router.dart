import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/app_transitions.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_screen.dart';
import 'package:taskify/features/home/presentation/screen/home_screen.dart';
import 'package:taskify/features/root/presentation/root_screen.dart';
import 'package:taskify/features/profile/presentation/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterPaths.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RootScreen(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterPaths.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterPaths.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
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
  ],
);
