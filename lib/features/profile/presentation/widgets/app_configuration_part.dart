import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/providers/locale_notifier.dart';
import 'package:taskify/core/providers/theme_notifier.dart';
import 'package:taskify/domain/models/time_format_type.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/features/profile/presentation/language_selection.dart';
import 'package:taskify/features/profile/presentation/select_language_bottom_sheet.dart';
import 'package:taskify/features/profile/presentation/select_theme_bottom_sheet.dart';
import 'package:taskify/features/profile/presentation/select_time_format_bottom_sheet.dart';
import 'package:taskify/l10n/app_localizations.dart';

class AppConfigurationPart extends StatelessWidget {
  const AppConfigurationPart({super.key});

  Future<void> _openTimeFormatSheet(
    BuildContext context,
    TimeFormatType selectedType,
  ) async {
    final result = await showAppBottomSheet<TimeFormatType>(
      context: context,
      type: AppBottomSheetType.floating,
      child: SelectTimeFormatBottomSheet(selectedType: selectedType),
    );
    if (context.mounted && result != null) {
      context.read<ProfileBloc>().add(ProfileTimeFormatChanged(result));
    }
  }

  String _timeFormatLabel(BuildContext context, TimeFormatType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case TimeFormatType.hour24:
        return l10n?.timeFormat24 ?? '';
      case TimeFormatType.hour12:
        return l10n?.timeFormat12 ?? '';
    }
  }

  String _themeLabel(BuildContext context, AppThemeMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case AppThemeMode.light:
        return l10n?.themeLight ?? '';
      case AppThemeMode.dark:
        return l10n?.themeDark ?? '';
      case AppThemeMode.system:
        return l10n?.themeSystem ?? '';
    }
  }

  Future<void> _openThemeSheet(BuildContext context) async {
    final themeCubit = context.read<ThemeCubit>();
    final result = await showAppBottomSheet<AppThemeMode>(
      context: context,
      type: AppBottomSheetType.floating,
      child: SelectThemeBottomSheet(selectedMode: themeCubit.state.themeMode),
    );
    if (context.mounted && result != null) {
      await themeCubit.setThemeMode(result);
    }
  }

  Future<void> _openLanguageSheet(BuildContext context) async {
    final localeCubit = context.read<LocaleCubit>();
    final result = await showAppBottomSheet<LanguageSelection>(
      context: context,
      type: AppBottomSheetType.floating,
      child: SelectLanguageBottomSheet(
        selectedLocale: localeCubit.state,
      ),
    );
    if (context.mounted && result != null) {
      await localeCubit.setLocale(
        result is LanguageSelectionOverride ? result.locale : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LocaleCubit, Locale?>(
              builder: (context, locale) {
                return CardWithActions(
                  actions: [
                    CardActionEntry(
                      CardAction(
                        title: l10n?.timeFormat ?? '',
                        description: _timeFormatLabel(
                          context,
                          state.timeFormat,
                        ),
                        onPressed: () =>
                            _openTimeFormatSheet(context, state.timeFormat),
                      ),
                    ),
                    CardActionEntry(
                      CardAction(
                        title: l10n?.language ?? '',
                        description:
                            l10n?.localeDisplayName(locale) ?? '',
                        onPressed: () => _openLanguageSheet(context),
                      ),
                    ),
                    CardActionEntry(
                      CardAction(
                        title: l10n?.theme ?? '',
                        description: themeState.isLoading
                            ? ''
                            : _themeLabel(
                                context,
                                themeState.themeMode,
                              ),
                        onPressed: () => _openThemeSheet(context),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
