part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.started() = _Started;
  const factory SettingsEvent.onTimeFormatChanged(TimeFormatType timeFormat) = _OnTimeFormatChanged;
  const factory SettingsEvent.updateTimeFormat(TimeFormatType timeFormat) = _UpdateTimeFormat;
  const factory SettingsEvent.onRemoveAccount() = _OnRemoveAccount;
}