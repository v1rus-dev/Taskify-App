part of 'create_user_tag_bloc.dart';

abstract class CreateUserTagState extends Equatable {
  const CreateUserTagState();

  @override
  List<Object?> get props => [];
}

class CreateUserTagEditing extends CreateUserTagState {
  const CreateUserTagEditing({
    required this.name,
    required this.color,
    required this.isValid,
  });

  final String name;
  final Color color;
  final bool isValid;

  @override
  List<Object?> get props => [name, color, isValid];
}

class CreateUserTagSaving extends CreateUserTagState {
  const CreateUserTagSaving({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;

  @override
  List<Object?> get props => [name, color];
}

class CreateUserTagSuccess extends CreateUserTagState {
  const CreateUserTagSuccess();
}

class CreateUserTagError extends CreateUserTagState {
  const CreateUserTagError({
    required this.message,
    required this.name,
    required this.color,
    required this.isValid,
  });

  final String message;
  final String name;
  final Color color;
  final bool isValid;

  @override
  List<Object?> get props => [message, name, color, isValid];
}
