part of 'settings_bloc.dart';

@freezed
class SettingsSideEffect with _$SettingsSideEffect {
  const factory SettingsSideEffect.showLoadingDialog() = _ShowLoadingDialog;
  const factory SettingsSideEffect.dismissLoadingDialog() = _DismissLoadingDialog;
}