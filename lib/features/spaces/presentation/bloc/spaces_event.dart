part of 'spaces_bloc.dart';

sealed class SpacesEvent extends Equatable {
  const SpacesEvent();

  @override
  List<Object?> get props => [];
}

final class SpacesStarted extends SpacesEvent {
  const SpacesStarted();
}

final class SpacesRefreshed extends SpacesEvent {
  const SpacesRefreshed();
}

final class SpacesCreateRequested extends SpacesEvent {
  const SpacesCreateRequested({
    required this.name,
    this.description,
    this.isLightweight = false,
  });

  final String name;
  final String? description;
  final bool isLightweight;

  @override
  List<Object?> get props => [name, description, isLightweight];
}

final class _SpacesUpdated extends SpacesEvent {
  const _SpacesUpdated(this.spaces);

  final List<SpaceEntity> spaces;

  @override
  List<Object?> get props => [spaces];
}
