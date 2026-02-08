part of 'friend_info_bloc.dart';

sealed class FriendInfoEvent extends Equatable {
  const FriendInfoEvent();

  @override
  List<Object> get props => [];
}

final class FriendInfoStarted extends FriendInfoEvent {
  const FriendInfoStarted();
}