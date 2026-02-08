part of 'friends_list_bloc.dart';

class FriendsListState extends Equatable {
  const FriendsListState({
    this.friends = const <FriendModelUi>[],
    this.incomingRequests = const <FriendRequestModelUi>[],
    this.outgoingRequests = const <FriendRequestModelUi>[],
  });

  final List<FriendModelUi> friends;
  final List<FriendRequestModelUi> incomingRequests;
  final List<FriendRequestModelUi> outgoingRequests;

  bool get isAllEmpty => friends.isEmpty && incomingRequests.isEmpty && outgoingRequests.isEmpty;

  bool get requestsIsEmpty => incomingRequests.isEmpty && outgoingRequests.isEmpty;
  bool get requestsIsNotEmpty => incomingRequests.isNotEmpty || outgoingRequests.isNotEmpty;

  FriendsListState copyWith({
    List<FriendModelUi>? friends,
    List<FriendRequestModelUi>? incomingRequests,
    List<FriendRequestModelUi>? outgoingRequests,
  }) {
    return FriendsListState(
      friends: friends ?? this.friends,
      incomingRequests: incomingRequests ?? this.incomingRequests,
      outgoingRequests: outgoingRequests ?? this.outgoingRequests,
    );
  }

  @override
  List<Object?> get props => [friends, incomingRequests, outgoingRequests];
}
