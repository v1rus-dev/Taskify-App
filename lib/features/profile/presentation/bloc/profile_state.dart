part of 'profile_bloc.dart';

@freezed
abstract class ProfileState with _$ProfileState {
    const factory ProfileState({
    @Default(TimeFormatType.hour24) TimeFormatType timeFormat
  }) = _ProfileState;
}
