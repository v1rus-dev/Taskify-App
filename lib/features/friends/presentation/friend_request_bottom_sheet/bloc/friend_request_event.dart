part of 'friend_request_bloc.dart';

sealed class FriendRequestEvent extends Equatable {
  const FriendRequestEvent();

  @override
  List<Object> get props => [];
}

final class FriendRequestCancelEvent extends FriendRequestEvent {
  const FriendRequestCancelEvent();
}

final class FriendRequestAcceptEvent extends FriendRequestEvent {
  const FriendRequestAcceptEvent();
}

final class FriendRequestRejectEvent extends FriendRequestEvent {
  const FriendRequestRejectEvent();
}
