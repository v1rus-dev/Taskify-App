part of 'create_user_tag_bloc.dart';

@freezed
class CreateUserTagState with _$CreateUserTagState {
  const factory CreateUserTagState.editing({
    required String name,
    required Color color,
    required bool isValid,
  }) = _Editing;

  const factory CreateUserTagState.saving({
    required String name,
    required Color color,
  }) = _Saving;

  const factory CreateUserTagState.success() = _Success;

  const factory CreateUserTagState.error({
    required String message,
    required String name,
    required Color color,
    required bool isValid,
  }) = _Error;
}
