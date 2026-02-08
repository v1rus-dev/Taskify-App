part of 'friend_request_bloc.dart';

abstract class FriendRequestSideEffect extends Equatable {
  const FriendRequestSideEffect();

  @override
  List<Object> get props => [];
}

final class FriendRequestCloseBottomSheet extends FriendRequestSideEffect {
  const FriendRequestCloseBottomSheet();
}
