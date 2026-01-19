part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;
  const factory ProfileEvent.onTimeFormatChanged(TimeFormatType timeFormat) = _OnTimeFormatChanged;
  const factory ProfileEvent.updateTimeFormat(TimeFormatType timeFormat) = _UpdateTimeFormat;
  const factory ProfileEvent.onRemoveAccount() = _OnRemoveAccount;
}