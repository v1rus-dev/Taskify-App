import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/app_transitions.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/core/services/talker_service.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_screen.dart';
import 'package:taskify/features/home/presentation/screen/home_screen.dart';
import 'package:taskify/features/root/presentation/root_screen.dart';
import 'package:taskify/features/profile/presentation/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterPaths.home,
  redirect: (context, state) {
    TalkerService.instance.info('redirect: ${state.uri}');
    final uri = state.uri;
    if (uri.scheme == 'glance-action') {
      return RouterPaths.home;
    }
    if (uri.scheme == 'taskify' && uri.host == 'widget') {
      final path = uri.path.isEmpty ? RouterPaths.home : uri.path;
      final query = uri.query;
      return query.isEmpty ? path : '$path?$query';
    }
    return null;
  },
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
              builder: (context, state) => const HomeScreenPage(),
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
        final taskIdFromQuery = int.tryParse(
          state.uri.queryParameters['taskId'] ?? '',
        );
        final taskId = taskIdFromQuery ?? (state.extra as int?);
        final fromWidget = state.uri.queryParameters['fromWidget'] == 'true';
        return bottomUpTransitionBuilder(
          ValueKey('editTask-$taskId'),
          context,
          EditTaskPage(
            taskId: taskId,
            fromWidget: fromWidget,
          ),
        );
      },
    ),
  ],
);
