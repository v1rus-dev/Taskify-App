part of 'debug_bloc.dart';

sealed class DebugState extends Equatable {
  const DebugState();
  
  @override
  List<Object> get props => [];
}

final class DebugInitial extends DebugState {}
