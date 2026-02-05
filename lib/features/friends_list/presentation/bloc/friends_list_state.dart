part of 'friends_list_bloc.dart';

class FriendsListState extends Equatable {
  const FriendsListState({
    this.friends = const <FriendModelUi>[],
  });

  final List<FriendModelUi> friends;

  FriendsListState copyWith({
    List<FriendModelUi>? friends,
  }) {
    return FriendsListState(
      friends: friends ?? this.friends,
    );
  }

  @override
  List<Object?> get props => [friends];
}
