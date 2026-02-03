part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.timeFormat = TimeFormatType.hour24,
    this.profileUser,
  });

  final TimeFormatType timeFormat;
  final AuthUserModel? profileUser;

  ProfileState copyWith({
    TimeFormatType? timeFormat,
    AuthUserModel? profileUser,
    bool clearProfileUser = false,
  }) {
    return ProfileState(
      timeFormat: timeFormat ?? this.timeFormat,
      profileUser:
          clearProfileUser ? null : (profileUser ?? this.profileUser),
    );
  }

  @override
  List<Object?> get props => [timeFormat, profileUser];
}
