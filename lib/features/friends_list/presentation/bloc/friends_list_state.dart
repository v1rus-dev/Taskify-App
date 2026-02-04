part of 'friends_list_bloc.dart';

sealed class FriendsListState extends Equatable {
  const FriendsListState();
  
  @override
  List<Object> get props => [];
}

final class FriendsListInitial extends FriendsListState {}
