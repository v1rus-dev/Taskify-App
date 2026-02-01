part of 'spaces_bloc.dart';

sealed class SpacesState extends Equatable {
  const SpacesState();
  
  @override
  List<Object> get props => [];
}

final class SpacesInitial extends SpacesState {}
