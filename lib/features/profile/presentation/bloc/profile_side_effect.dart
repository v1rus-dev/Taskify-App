part of 'profile_bloc.dart';

@freezed
class ProfileSideEffect with _$ProfileSideEffect {
  const factory ProfileSideEffect.showLoadingDialog() = _ShowLoadingDialog;
  const factory ProfileSideEffect.dismissLoadingDialog() = _DismissLoadingDialog;
}