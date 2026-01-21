part of 'create_user_tag_bloc.dart';

@freezed
class CreateUserTagEvent with _$CreateUserTagEvent {
  const factory CreateUserTagEvent.started() = _Started;
  const factory CreateUserTagEvent.nameChanged(String name) = _NameChanged;
  const factory CreateUserTagEvent.colorChanged(Color color) = _ColorChanged;
  const factory CreateUserTagEvent.createPressed() = _CreatePressed;
}
