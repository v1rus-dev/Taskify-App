import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/app/router/app_transitions.dart';
import 'package:taskify/app/router/router_paths.dart';
import 'package:taskify/features/edit_task/presentation/edit_task_screen.dart';
import 'package:taskify/features/home/presentation/screen/home_screen.dart';
import 'package:taskify/features/root/presentation/root_screen.dart';
import 'package:taskify/features/profile/presentation/profile_screen.dart';
import 'package:taskify/features/spaces/presentation/screen/spaces_screen.dart';
import 'package:taskify/features/spaces/presentation/screen/space_details_screen.dart';
import 'package:taskify/features/activity/presentation/screen/activity_screen.dart';
import 'package:taskify/features/friends_list/presentation/friends_list_screen.dart';
import 'package:taskify/features/debug/presentation/debug_screen.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterPaths.home,
  redirect: (context, state) {
    final loc = state.uri.toString();
    final path = state.uri.path;
    if (loc == 'taskify://create' ||
        loc.endsWith('://create') ||
        path == '/create' ||
        path == 'create') {
      return RouterPaths.createTask;
    }
    if (loc.startsWith('taskify://task/') || path.startsWith('task/')) {
      final segments = state.uri.pathSegments;
      final id = segments.isNotEmpty ? segments.last : state.uri.path.split('/').lastOrNull;
      if (id != null && id.isNotEmpty) {
        return '${RouterPaths.editTask}?id=$id';
      }
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
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
              path: RouterPaths.spaces,
              builder: (context, state) => const SpacesScreenPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterPaths.activity,
              builder: (context, state) => const AcitivityScreenPage(),
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
        final taskId = state.extra as int? ??
            int.tryParse(state.uri.queryParameters['id'] ?? '');
        return bottomUpTransitionBuilder(
          ValueKey('editTask-$taskId'),
          context,
          EditTaskPage(taskId: taskId),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.createTask,
      pageBuilder: (context, state) {
        return bottomUpTransitionBuilder(
          const ValueKey('createTask'),
          context,
          const EditTaskPage(taskId: null),
        );
      },
    ),
    GoRoute(
      path: RouterPaths.friendsList,
      builder: (context, state) => const FriendsListPage(),
    ),
    GoRoute(
      path: '${RouterPaths.spaceDetails}/:spaceId',
      builder: (context, state) {
        final extra = state.extra;
        final space = extra is SpaceEntity
            ? extra
            : SpaceEntity(
                id: state.pathParameters['spaceId'] ?? '',
                name: 'Space',
                role: SpaceRole.viewer,
                isLightweight: false,
              );
        return SpaceDetailsPage(space: space);
      },
    ),
    GoRoute(
      path: RouterPaths.debug,
      builder: (context, state) => const DebugScreenPage(),
    ),
  ],
);
