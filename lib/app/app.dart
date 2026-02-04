import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/auth/auth_cubit.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/sync/sync_coordinator.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';
import 'package:taskify/domain/auth/repository/auth_repository.dart';
import 'package:taskify/l10n/app_localizations.dart';
import 'package:taskify/app/router/app_router.dart';
import 'package:taskify/core/providers/locale_notifier.dart';
import 'package:taskify/core/providers/theme_notifier.dart';

class TaskifyApp extends StatefulWidget {
  const TaskifyApp({super.key});

  @override
  State<TaskifyApp> createState() => _TaskifyAppState();
}

class _TaskifyAppState extends State<TaskifyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        _onSystemThemeChanged;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        null;
    super.dispose();
  }

  void _onSystemThemeChanged() {
    context.read<ThemeCubit>().onSystemThemeChanged();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LocaleCubit>(create: (_) => LocaleCubit()),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            locator<AuthRepository>(),
            syncCoordinator: locator<SyncCoordinator>(),
          ),
        ),
        BlocProvider<TimeFormatCubit>(
          create: (_) => TimeFormatCubit(
            interactor: locator<AppConfigurationInteractor>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, Locale?>(
            builder: (context, localeOverride) {
              final themeMode = themeState.isLoading
                  ? ThemeMode.system
                  : themeState.isDark
                  ? ThemeMode.dark
                  : ThemeMode.light;

              final platformBrightness = View.of(
                context,
              ).platformDispatcher.platformBrightness;
              final isDarkEffective = themeMode == ThemeMode.system
                  ? (platformBrightness == Brightness.dark)
                  : (themeMode == ThemeMode.dark);

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: isDarkEffective
                      ? Brightness.light
                      : Brightness.dark,
                  statusBarBrightness: isDarkEffective
                      ? Brightness.dark
                      : Brightness.light,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarContrastEnforced: false,
                  systemNavigationBarIconBrightness: isDarkEffective
                      ? Brightness.light
                      : Brightness.dark,
                ),
                child: MaterialApp.router(
                  routerConfig: appRouter,
                  theme: themeFromScheme(lightScheme),
                  darkTheme: themeFromScheme(darkScheme),
                  themeMode: themeMode,
                  locale: localeOverride,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
