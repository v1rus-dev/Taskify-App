part of 'friends_list_bloc.dart';

sealed class FriendsListEvent extends Equatable {
  const FriendsListEvent();

  @override
  List<Object> get props => [];
}

final class FriendsListStarted extends FriendsListEvent {
  const FriendsListStarted();
}