part of 'settings_bloc.dart';

@freezed
abstract class SettingsState with _$SettingsState {
    const factory SettingsState({
    @Default(TimeFormatType.hour24) TimeFormatType timeFormat
  }) = _SettingsState;
}
