part of 'add_friend_bloc.dart';

sealed class AddFriendEvent extends Equatable {
  const AddFriendEvent();

  @override
  List<Object> get props => [];
}

final class AddFriendSwitchMode extends AddFriendEvent {
  const AddFriendSwitchMode(this.stateType);

  final AddFriendStateType stateType;

  @override
  List<Object> get props => [stateType];
}
