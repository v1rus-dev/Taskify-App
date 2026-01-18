import 'package:design/design.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final AppThemeMode themeMode;
  final bool isDark;
  final bool isLoading;

  const ThemeState({
    required this.themeMode,
    required this.isDark,
    required this.isLoading,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isDark,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeModeKey = 'theme_mode';

  ThemeCubit() : super(_createInitialState()) {
    _init();
  }

  static ThemeState _createInitialState() {
    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    return ThemeState(
      themeMode: AppThemeMode.system,
      isDark: isSystemDark,
      isLoading: true,
    );
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final int? storedIndex = prefs.getInt(_themeModeKey);
    final AppThemeMode mode = AppThemeMode.values[
      storedIndex ?? AppThemeMode.system.index
    ];

    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    emit(
      ThemeState(
        themeMode: mode,
        isDark: _calculateIsDark(mode, isSystemDark),
        isLoading: false,
      ),
    );
  }

  Future<void> toggleTheme() async {
    if (state.isLoading) return;

    final AppThemeMode newThemeMode = switch (state.themeMode) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.system,
      AppThemeMode.system => AppThemeMode.light,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, newThemeMode.index);

    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    emit(
      state.copyWith(
        themeMode: newThemeMode,
        isDark: _calculateIsDark(newThemeMode, isSystemDark),
      ),
    );
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    if (state.isLoading) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);

    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    emit(
      state.copyWith(
        themeMode: themeMode,
        isDark: _calculateIsDark(themeMode, isSystemDark),
      ),
    );
  }

  void onSystemThemeChanged() {
    if (state.isLoading) return;

    final Brightness systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    emit(
      state.copyWith(
        isDark: _calculateIsDark(state.themeMode, isSystemDark),
      ),
    );
  }

  bool _calculateIsDark(AppThemeMode mode, bool isSystemDark) {
    switch (mode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return isSystemDark;
    }
  }
}
