part of 'friend_info_bloc.dart';

sealed class FriendInfoState extends Equatable {
  const FriendInfoState();

  @override
  List<Object> get props => [];
}

final class FriendInfoLoading extends FriendInfoState {
  const FriendInfoLoading();
}

final class FriendInfoSuccess extends FriendInfoState {
  const FriendInfoSuccess({required this.friend});

  final FriendModelUi friend;

  @override
  List<Object> get props => [friend];
}
