import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/features/spaces/domain/usecases/space_interactor.dart';

part 'spaces_event.dart';
part 'spaces_state.dart';

class SpacesBloc extends Bloc<SpacesEvent, SpacesState> {
  SpacesBloc() : super(const SpacesState()) {
    on<SpacesStarted>(_onStarted);
    on<SpacesRefreshed>(_onRefreshed);
    on<SpacesCreateRequested>(_onCreateRequested);
    on<_SpacesUpdated>(_onSpacesUpdated);
  }

  final SpaceInteractor _interactor = locator<SpaceInteractor>();
  StreamSubscription<List<SpaceEntity>>? _spacesSubscription;

  Future<void> _onStarted(
    SpacesStarted event,
    Emitter<SpacesState> emit,
  ) async {
    _spacesSubscription ??= _interactor.observeSpaces().listen(
      (spaces) => add(_SpacesUpdated(spaces)),
    );
    await _refreshRemote(emit);
  }

  Future<void> _onRefreshed(
    SpacesRefreshed event,
    Emitter<SpacesState> emit,
  ) async {
    await _refreshRemote(emit);
  }

  Future<void> _refreshRemote(Emitter<SpacesState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _interactor.refreshSpaces();
    result.fold(
      ifLeft: (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      ifRight: (_) {
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> _onCreateRequested(
    SpacesCreateRequested event,
    Emitter<SpacesState> emit,
  ) async {
    if (event.name.trim().isEmpty) {
      return;
    }
    emit(state.copyWith(isCreating: true, errorMessage: null));
    final result = await _interactor.createSpace(
      name: event.name.trim(),
      description: event.description?.trim().isEmpty == true
          ? null
          : event.description?.trim(),
      isLightweight: event.isLightweight,
    );
    result.fold(
      ifLeft: (failure) {
        emit(state.copyWith(isCreating: false, errorMessage: failure.message));
      },
      ifRight: (_) {
        emit(state.copyWith(isCreating: false));
      },
    );
  }

  Future<void> _onSpacesUpdated(
    _SpacesUpdated event,
    Emitter<SpacesState> emit,
  ) async {
    emit(state.copyWith(spaces: event.spaces));
  }

  @override
  Future<void> close() async {
    await _spacesSubscription?.cancel();
    return super.close();
  }
}
