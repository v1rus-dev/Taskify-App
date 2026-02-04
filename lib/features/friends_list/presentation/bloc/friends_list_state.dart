part of 'friends_list_bloc.dart';

class FriendsListState extends Equatable {
  const FriendsListState({
    this.friends = const <FriendUiModel>[],
  });

  final List<FriendUiModel> friends;

  FriendsListState copyWith({
    List<FriendUiModel>? friends,
  }) {
    return FriendsListState(
      friends: friends ?? this.friends,
    );
  }

  @override
  List<Object?> get props => [friends];
}
