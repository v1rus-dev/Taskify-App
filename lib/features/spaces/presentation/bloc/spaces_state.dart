part of 'spaces_bloc.dart';

class SpacesState extends Equatable {
  const SpacesState({
    this.spaces = const <SpaceEntity>[],
    this.isLoading = false,
    this.isCreating = false,
    this.errorMessage,
  });

  final List<SpaceEntity> spaces;
  final bool isLoading;
  final bool isCreating;
  final String? errorMessage;

  bool get isEmpty => spaces.isEmpty;

  SpacesState copyWith({
    List<SpaceEntity>? spaces,
    bool? isLoading,
    bool? isCreating,
    String? errorMessage,
  }) {
    return SpacesState(
      spaces: spaces ?? this.spaces,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [spaces, isLoading, isCreating, errorMessage];
}
