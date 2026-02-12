part of 'create_user_tag_bloc.dart';

abstract class CreateUserTagEvent extends Equatable {
  const CreateUserTagEvent();

  @override
  List<Object?> get props => [];
}

class CreateUserTagStarted extends CreateUserTagEvent {
  const CreateUserTagStarted();
}

class CreateUserTagNameChanged extends CreateUserTagEvent {
  const CreateUserTagNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class CreateUserTagColorChanged extends CreateUserTagEvent {
  const CreateUserTagColorChanged(this.color);

  final Color color;

  @override
  List<Object?> get props => [color];
}

class CreateUserTagCreatePressed extends CreateUserTagEvent {
  const CreateUserTagCreatePressed();
}
