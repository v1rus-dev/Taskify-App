import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/tags/models/default_tag_color.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';

part 'create_user_tag_event.dart';
part 'create_user_tag_state.dart';

class CreateUserTagBloc extends Bloc<CreateUserTagEvent, CreateUserTagState> {
  CreateUserTagBloc()
      : _tagInteractor = locator<TagInteractor>(),
        super(
          CreateUserTagEditing(
            name: '',
            color: DefaultTagColor.values.first.color,
            isValid: false,
          ),
        ) {
    on<CreateUserTagStarted>(_onStarted);
    on<CreateUserTagNameChanged>(_onNameChanged);
    on<CreateUserTagColorChanged>(_onColorChanged);
    on<CreateUserTagCreatePressed>(_onCreatePressed);
  }

  final TagInteractor _tagInteractor;

  void _onStarted(
    CreateUserTagStarted event,
    Emitter<CreateUserTagState> emit,
  ) {
    emit(
      CreateUserTagEditing(
        name: '',
        color: DefaultTagColor.values.first.color,
        isValid: false,
      ),
    );
  }

  void _onNameChanged(
    CreateUserTagNameChanged event,
    Emitter<CreateUserTagState> emit,
  ) {
    final name = event.name;
    final trimmed = name.trim();
    final currentColor = _currentColor(state);
    emit(
      CreateUserTagEditing(
        name: name,
        color: currentColor,
        isValid: trimmed.isNotEmpty,
      ),
    );
  }

  void _onColorChanged(
    CreateUserTagColorChanged event,
    Emitter<CreateUserTagState> emit,
  ) {
    final color = event.color;
    final currentName = _currentName(state);
    emit(
      CreateUserTagEditing(
        name: currentName,
        color: color,
        isValid: currentName.trim().isNotEmpty,
      ),
    );
  }

  Future<void> _onCreatePressed(
    CreateUserTagCreatePressed event,
    Emitter<CreateUserTagState> emit,
  ) async {
    final name = _currentName(state).trim();
    final color = _currentColor(state);
    if (name.isEmpty) {
      emit(
        CreateUserTagEditing(
          name: _currentName(state),
          color: color,
          isValid: false,
        ),
      );
      return;
    }
    emit(CreateUserTagSaving(name: name, color: color));
    final result = await _tagInteractor.createCustomTag(
      CustomTagEntity(id: 0, title: name, color: color),
    );
    String? errorMessage;
    result.fold(
      ifLeft: (failure) => errorMessage = failure.message,
      ifRight: (_) {},
    );
    if (errorMessage != null) {
      emit(
        CreateUserTagError(
          message: errorMessage!,
          name: name,
          color: color,
          isValid: true,
        ),
      );
      return;
    }
    emit(const CreateUserTagSuccess());
  }

  String _currentName(CreateUserTagState state) {
    if (state is CreateUserTagEditing) {
      return state.name;
    }
    if (state is CreateUserTagSaving) {
      return state.name;
    }
    if (state is CreateUserTagError) {
      return state.name;
    }
    return '';
  }

  Color _currentColor(CreateUserTagState state) {
    if (state is CreateUserTagEditing) {
      return state.color;
    }
    if (state is CreateUserTagSaving) {
      return state.color;
    }
    if (state is CreateUserTagError) {
      return state.color;
    }
    return DefaultTagColor.values.first.color;
  }
}
