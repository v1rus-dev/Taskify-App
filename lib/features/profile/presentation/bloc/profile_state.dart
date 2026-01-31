part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.timeFormat = TimeFormatType.hour24,
  });

  final TimeFormatType timeFormat;

  ProfileState copyWith({
    TimeFormatType? timeFormat,
  }) {
    return ProfileState(timeFormat: timeFormat ?? this.timeFormat);
  }

  @override
  List<Object?> get props => [timeFormat];
}
