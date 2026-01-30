part of 'profile_bloc.dart';

abstract class ProfileSideEffect extends Equatable {
  const ProfileSideEffect();

  @override
  List<Object?> get props => [];
}

class ProfileShowLoadingDialog extends ProfileSideEffect {
  const ProfileShowLoadingDialog();
}

class ProfileDismissLoadingDialog extends ProfileSideEffect {
  const ProfileDismissLoadingDialog();
}
