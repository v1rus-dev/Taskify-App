part of 'friend_code_bloc.dart';

sealed class FriendCodeState extends Equatable {
  const FriendCodeState({
    required this.friendCode,
  });

  final String friendCode;

  @override
  List<Object?> get props => [friendCode];
}

final class FriendCodeInitial extends FriendCodeState {
  const FriendCodeInitial() : super(friendCode: '');
}

final class FriendCodeLoading extends FriendCodeState {
  const FriendCodeLoading({required super.friendCode});
}

final class FriendCodeSuccess extends FriendCodeState {
  const FriendCodeSuccess({required super.friendCode});
}

final class FriendCodeError extends FriendCodeState {
  const FriendCodeError({
    required super.friendCode,
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object?> get props => [friendCode, failure];
}
