import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/infrastructure/theme/theme_notifier.dart';

class TaskifyApp extends ConsumerWidget {
  const TaskifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeNotifierProvider);

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      ref.read(themeNotifierProvider.notifier).onSystemThemeChanged();
    };

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.when(
        data: (data) => data.isDark ? ThemeMode.dark : ThemeMode.light,
        loading: () => ThemeMode.system,
        error: (error, stackTrace) => ThemeMode.system,
      ),
    );
  }
}