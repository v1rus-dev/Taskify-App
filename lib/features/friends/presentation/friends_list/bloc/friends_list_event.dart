part of 'friends_list_bloc.dart';

sealed class FriendsListEvent extends Equatable {
  const FriendsListEvent();

  @override
  List<Object> get props => [];
}

final class FriendsListStarted extends FriendsListEvent {
  const FriendsListStarted();

  @override
  List<Object> get props => [];
}

final class UpdateFriendsList extends FriendsListEvent {
  const UpdateFriendsList(this.friends);

  final List<FriendModelUi> friends;

  @override
  List<Object> get props => [friends];
}

final class UpdateIncomingRequests extends FriendsListEvent {
  const UpdateIncomingRequests(this.requests);

  final List<FriendRequestModelUi> requests;

  @override
  List<Object> get props => [requests];
}

final class UpdateOutgoingRequests extends FriendsListEvent {
  const UpdateOutgoingRequests(this.requests);

  final List<FriendRequestModelUi> requests;

  @override
  List<Object> get props => [requests];
}

final class TryAddFriend extends FriendsListEvent {
  const TryAddFriend(this.friendCode);

  final String friendCode;

  @override
  List<Object> get props => [friendCode];
}
