import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/spaces/domain/models/space.dart';
import 'package:taskify/features/spaces/domain/models/space_invite.dart';
import 'package:taskify/features/spaces/domain/models/space_list.dart';
import 'package:taskify/features/spaces/domain/models/space_member.dart';
import 'package:taskify/features/spaces/domain/models/space_note.dart';
import 'package:taskify/features/spaces/domain/models/space_role.dart';
import 'package:taskify/features/spaces/domain/models/space_task.dart';
import 'package:taskify/features/spaces/domain/usecases/space_interactor.dart';

part 'space_details_event.dart';
part 'space_details_state.dart';

class SpaceDetailsBloc extends Bloc<SpaceDetailsEvent, SpaceDetailsState> {
  SpaceDetailsBloc({required this.space})
    : super(SpaceDetailsState(space: space)) {
    on<SpaceDetailsStarted>(_onStarted);
    on<SpaceDetailsRefreshed>(_onRefreshed);
    on<SpaceTaskCreated>(_onTaskCreated);
    on<SpaceListCreated>(_onListCreated);
    on<SpaceNoteCreated>(_onNoteCreated);
    on<SpaceMemberAdded>(_onMemberAdded);
    on<SpaceInviteCreated>(_onInviteCreated);
    on<_SpaceListsUpdated>(_onListsUpdated);
    on<_SpaceTasksUpdated>(_onTasksUpdated);
    on<_SpaceNotesUpdated>(_onNotesUpdated);
    on<_SpaceMembersUpdated>(_onMembersUpdated);
    on<_SpaceInvitesUpdated>(_onInvitesUpdated);
  }

  final SpaceEntity space;
  final SpaceInteractor _interactor = locator<SpaceInteractor>();
  StreamSubscription<List<SpaceListEntity>>? _listsSubscription;
  StreamSubscription<List<SpaceTaskEntity>>? _tasksSubscription;
  StreamSubscription<List<SpaceNoteEntity>>? _notesSubscription;
  StreamSubscription<List<SpaceMemberEntity>>? _membersSubscription;
  StreamSubscription<List<SpaceInviteEntity>>? _invitesSubscription;

  Future<void> _onStarted(
    SpaceDetailsStarted event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    _listsSubscription ??= _interactor
        .observeLists(space.id)
        .listen((items) => add(_SpaceListsUpdated(items)));
    _tasksSubscription ??= _interactor
        .observeTasks(space.id)
        .listen((items) => add(_SpaceTasksUpdated(items)));
    _notesSubscription ??= _interactor
        .observeNotes(space.id)
        .listen((items) => add(_SpaceNotesUpdated(items)));
    _membersSubscription ??= _interactor
        .observeMembers(space.id)
        .listen((items) => add(_SpaceMembersUpdated(items)));
    _invitesSubscription ??= _interactor
        .observeInvites(space.id)
        .listen((items) => add(_SpaceInvitesUpdated(items)));

    add(const SpaceDetailsRefreshed());
  }

  Future<void> _onRefreshed(
    SpaceDetailsRefreshed event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final results = await Future.wait([
      _interactor.refreshLists(space.id),
      _interactor.refreshTasks(space.id),
      _interactor.refreshNotes(space.id),
      _interactor.refreshMembers(space.id),
      _interactor.refreshInvites(space.id),
    ]);
    String? error;
    for (final result in results) {
      result.fold(
        ifLeft: (failure) => error ??= failure.message,
        ifRight: (_) {},
      );
    }
    emit(state.copyWith(isLoading: false, errorMessage: error));
  }

  Future<void> _onTaskCreated(
    SpaceTaskCreated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    if (event.title.trim().isEmpty) {
      return;
    }
    final result = await _interactor.createTask(
      spaceId: space.id,
      title: event.title,
      listId: event.listId,
      description: event.description,
    );
    result.fold(
      ifLeft: (failure) => emit(state.copyWith(errorMessage: failure.message)),
      ifRight: (_) {},
    );
  }

  Future<void> _onListCreated(
    SpaceListCreated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    if (event.title.trim().isEmpty) {
      return;
    }
    final result = await _interactor.createList(
      spaceId: space.id,
      title: event.title,
    );
    result.fold(
      ifLeft: (failure) => emit(state.copyWith(errorMessage: failure.message)),
      ifRight: (_) {},
    );
  }

  Future<void> _onNoteCreated(
    SpaceNoteCreated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    if (event.title.trim().isEmpty) {
      return;
    }
    final result = await _interactor.createNote(
      spaceId: space.id,
      title: event.title,
      body: event.body,
    );
    result.fold(
      ifLeft: (failure) => emit(state.copyWith(errorMessage: failure.message)),
      ifRight: (_) {},
    );
  }

  Future<void> _onMemberAdded(
    SpaceMemberAdded event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    if (event.userId.trim().isEmpty) {
      return;
    }
    final result = await _interactor.addMember(
      spaceId: space.id,
      userId: event.userId,
      role: event.role,
    );
    result.fold(
      ifLeft: (failure) => emit(state.copyWith(errorMessage: failure.message)),
      ifRight: (_) {},
    );
  }

  Future<void> _onInviteCreated(
    SpaceInviteCreated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    final result = await _interactor.createInvite(
      spaceId: space.id,
      role: event.role,
      expiresAt: event.expiresAt,
    );
    result.fold(
      ifLeft: (failure) => emit(state.copyWith(errorMessage: failure.message)),
      ifRight: (_) {},
    );
  }

  Future<void> _onListsUpdated(
    _SpaceListsUpdated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(lists: event.items));
  }

  Future<void> _onTasksUpdated(
    _SpaceTasksUpdated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(tasks: event.items));
  }

  Future<void> _onNotesUpdated(
    _SpaceNotesUpdated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(notes: event.items));
  }

  Future<void> _onMembersUpdated(
    _SpaceMembersUpdated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(members: event.items));
  }

  Future<void> _onInvitesUpdated(
    _SpaceInvitesUpdated event,
    Emitter<SpaceDetailsState> emit,
  ) async {
    emit(state.copyWith(invites: event.items));
  }

  @override
  Future<void> close() async {
    await _listsSubscription?.cancel();
    await _tasksSubscription?.cancel();
    await _notesSubscription?.cancel();
    await _membersSubscription?.cancel();
    await _invitesSubscription?.cancel();
    return super.close();
  }
}
