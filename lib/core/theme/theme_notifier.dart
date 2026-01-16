import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design/design.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final AppThemeMode themeMode;
  final bool isDark;

  ThemeState({
    required this.themeMode,
    required this.isDark,
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    bool? isDark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
    );
  }
}

final themeNotifierProvider = AsyncNotifierProvider<ThemeNotifier, ThemeState>(
  () => ThemeNotifier(),
);

class ThemeNotifier extends AsyncNotifier<ThemeState> {
  static const String _themeModeKey = 'theme_mode';

  @override
  Future<ThemeState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final int? storedIndex = prefs.getInt(_themeModeKey);
    final AppThemeMode mode = AppThemeMode.values[
      storedIndex ?? AppThemeMode.system.index
    ];

    final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    return ThemeState(
      themeMode: mode,
      isDark: _calculateIsDark(mode, isSystemDark),
    );
  }

  Future<void> toggleTheme() async {
    if (!state.hasValue) return;
    final stateValue = state.value!;

    final AppThemeMode newThemeMode = switch (stateValue.themeMode) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.system,
      AppThemeMode.system => AppThemeMode.light,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, newThemeMode.index);

    final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    state = AsyncData(
      stateValue.copyWith(
        themeMode: newThemeMode,
        isDark: _calculateIsDark(newThemeMode, isSystemDark),
      ),
    );
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    if (!state.hasValue) return;
    final stateValue = state.value!;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, themeMode.index);

    final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    state = AsyncData(
      stateValue.copyWith(
        themeMode: themeMode,
        isDark: _calculateIsDark(themeMode, isSystemDark),
      ),
    );
  }

  void onSystemThemeChanged() {
    if (!state.hasValue) return;
    final stateValue = state.value!;

    final Brightness systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isSystemDark = systemBrightness == Brightness.dark;

    state = AsyncData(
      stateValue.copyWith(
        isDark: _calculateIsDark(stateValue.themeMode, isSystemDark),
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