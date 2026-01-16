import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/domain/entities/time_format_type.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(TimeFormatType.hour24) TimeFormatType timeFormat
  }) = _SettingsState;
}
