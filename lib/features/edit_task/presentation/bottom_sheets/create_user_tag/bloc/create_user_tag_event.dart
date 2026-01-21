part of 'create_user_tag_bloc.dart';

@freezed
class CreateUserTagEvent with _$CreateUserTagEvent {
  const factory CreateUserTagEvent.started() = _Started;
}