part of 'activity_bloc.dart';

sealed class ActivityState extends Equatable {
  const ActivityState();
  
  @override
  List<Object> get props => [];
}

final class ActivityInitial extends ActivityState {}
