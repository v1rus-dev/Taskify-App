part of 'space_details_bloc.dart';

class SpaceDetailsState extends Equatable {
  const SpaceDetailsState({
    required this.space,
    this.isLoading = false,
    this.errorMessage,
    this.lists = const <SpaceListEntity>[],
    this.tasks = const <SpaceTaskEntity>[],
    this.notes = const <SpaceNoteEntity>[],
    this.members = const <SpaceMemberEntity>[],
    this.invites = const <SpaceInviteEntity>[],
  });

  final SpaceEntity space;
  final bool isLoading;
  final String? errorMessage;
  final List<SpaceListEntity> lists;
  final List<SpaceTaskEntity> tasks;
  final List<SpaceNoteEntity> notes;
  final List<SpaceMemberEntity> members;
  final List<SpaceInviteEntity> invites;

  SpaceDetailsState copyWith({
    SpaceEntity? space,
    bool? isLoading,
    String? errorMessage,
    List<SpaceListEntity>? lists,
    List<SpaceTaskEntity>? tasks,
    List<SpaceNoteEntity>? notes,
    List<SpaceMemberEntity>? members,
    List<SpaceInviteEntity>? invites,
  }) {
    return SpaceDetailsState(
      space: space ?? this.space,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lists: lists ?? this.lists,
      tasks: tasks ?? this.tasks,
      notes: notes ?? this.notes,
      members: members ?? this.members,
      invites: invites ?? this.invites,
    );
  }

  @override
  List<Object?> get props => [
    space,
    isLoading,
    errorMessage,
    lists,
    tasks,
    notes,
    members,
    invites,
  ];
}
