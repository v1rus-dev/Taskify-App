part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.started() = _Started;
  const factory SettingsEvent.timeFormatChanged(TimeFormatType timeFormat) = _TimeFormatChanged;
  const factory SettingsEvent.setTimeFormat(TimeFormatType timeFormat) = _SetTimeFormat;
}