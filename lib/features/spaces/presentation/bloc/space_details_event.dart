part of 'space_details_bloc.dart';

sealed class SpaceDetailsEvent extends Equatable {
  const SpaceDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class SpaceDetailsStarted extends SpaceDetailsEvent {
  const SpaceDetailsStarted();
}

final class SpaceDetailsRefreshed extends SpaceDetailsEvent {
  const SpaceDetailsRefreshed();
}

final class SpaceTaskCreated extends SpaceDetailsEvent {
  const SpaceTaskCreated({required this.title, this.listId, this.description});

  final String title;
  final String? listId;
  final String? description;

  @override
  List<Object?> get props => [title, listId, description];
}

final class SpaceListCreated extends SpaceDetailsEvent {
  const SpaceListCreated({required this.title});

  final String title;

  @override
  List<Object?> get props => [title];
}

final class SpaceNoteCreated extends SpaceDetailsEvent {
  const SpaceNoteCreated({required this.title, this.body});

  final String title;
  final String? body;

  @override
  List<Object?> get props => [title, body];
}

final class SpaceMemberAdded extends SpaceDetailsEvent {
  const SpaceMemberAdded({required this.userId, required this.role});

  final String userId;
  final SpaceRole role;

  @override
  List<Object?> get props => [userId, role];
}

final class SpaceInviteCreated extends SpaceDetailsEvent {
  const SpaceInviteCreated({required this.role, this.expiresAt});

  final SpaceRole role;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => [role, expiresAt];
}

final class _SpaceListsUpdated extends SpaceDetailsEvent {
  const _SpaceListsUpdated(this.items);

  final List<SpaceListEntity> items;

  @override
  List<Object?> get props => [items];
}

final class _SpaceTasksUpdated extends SpaceDetailsEvent {
  const _SpaceTasksUpdated(this.items);

  final List<SpaceTaskEntity> items;

  @override
  List<Object?> get props => [items];
}

final class _SpaceNotesUpdated extends SpaceDetailsEvent {
  const _SpaceNotesUpdated(this.items);

  final List<SpaceNoteEntity> items;

  @override
  List<Object?> get props => [items];
}

final class _SpaceMembersUpdated extends SpaceDetailsEvent {
  const _SpaceMembersUpdated(this.items);

  final List<SpaceMemberEntity> items;

  @override
  List<Object?> get props => [items];
}

final class _SpaceInvitesUpdated extends SpaceDetailsEvent {
  const _SpaceInvitesUpdated(this.items);

  final List<SpaceInviteEntity> items;

  @override
  List<Object?> get props => [items];
}
