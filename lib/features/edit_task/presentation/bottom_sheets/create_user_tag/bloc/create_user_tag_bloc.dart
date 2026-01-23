import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/tags/models/default_tag_color.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';

part 'create_user_tag_event.dart';
part 'create_user_tag_state.dart';
part 'create_user_tag_bloc.freezed.dart';

class CreateUserTagBloc extends Bloc<CreateUserTagEvent, CreateUserTagState> {
  CreateUserTagBloc()
      : _tagInteractor = locator<TagInteractor>(),
        super(
          CreateUserTagState.editing(
            name: '',
            color: DefaultTagColor.values.first.color,
            isValid: false,
          ),
        ) {
    on<CreateUserTagEvent>(_onEvent);
  }

  final TagInteractor _tagInteractor;

  Future<void> _onEvent(
    CreateUserTagEvent event,
    Emitter<CreateUserTagState> emit,
  ) async {
    await event.map(
      started: (_) async => _onStarted(emit),
      nameChanged: (event) async => _onNameChanged(event.name, emit),
      colorChanged: (event) async => _onColorChanged(event.color, emit),
      createPressed: (_) async => _onCreatePressed(emit),
    );
  }

  void _onStarted(Emitter<CreateUserTagState> emit) {
    emit(
      CreateUserTagState.editing(
        name: '',
        color: DefaultTagColor.values.first.color,
        isValid: false,
      ),
    );
  }

  void _onNameChanged(String name, Emitter<CreateUserTagState> emit) {
    final trimmed = name.trim();
    final currentColor = _currentColor(state);
    emit(
      CreateUserTagState.editing(
        name: name,
        color: currentColor,
        isValid: trimmed.isNotEmpty,
      ),
    );
  }

  void _onColorChanged(Color color, Emitter<CreateUserTagState> emit) {
    final currentName = _currentName(state);
    emit(
      CreateUserTagState.editing(
        name: currentName,
        color: color,
        isValid: currentName.trim().isNotEmpty,
      ),
    );
  }

  Future<void> _onCreatePressed(Emitter<CreateUserTagState> emit) async {
    final name = _currentName(state).trim();
    final color = _currentColor(state);
    if (name.isEmpty) {
      emit(
        CreateUserTagState.editing(
          name: _currentName(state),
          color: color,
          isValid: false,
        ),
      );
      return;
    }
    emit(CreateUserTagState.saving(name: name, color: color));
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
        CreateUserTagState.error(
          message: errorMessage!,
          name: name,
          color: color,
          isValid: true,
        ),
      );
      return;
    }
    emit(const CreateUserTagState.success());
  }

  String _currentName(CreateUserTagState state) {
    return state.maybeMap(
      editing: (state) => state.name,
      saving: (state) => state.name,
      error: (state) => state.name,
      orElse: () => '',
    );
  }

  Color _currentColor(CreateUserTagState state) {
    return state.maybeMap(
      editing: (state) => state.color,
      saving: (state) => state.color,
      error: (state) => state.color,
      orElse: () => DefaultTagColor.values.first.color,
    );
  }
}
