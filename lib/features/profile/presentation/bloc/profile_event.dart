part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileTimeFormatChanged extends ProfileEvent {
  const ProfileTimeFormatChanged(this.timeFormat);

  final TimeFormatType timeFormat;

  @override
  List<Object?> get props => [timeFormat];
}

class ProfileUpdateTimeFormat extends ProfileEvent {
  const ProfileUpdateTimeFormat(this.timeFormat);

  final TimeFormatType timeFormat;

  @override
  List<Object?> get props => [timeFormat];
}

class ProfileRemoveAccount extends ProfileEvent {
  const ProfileRemoveAccount();
}
