part of 'friend_code_bloc.dart';

sealed class FriendCodeEvent extends Equatable {
  const FriendCodeEvent();

  @override
  List<Object?> get props => [];
}

class FriendCodeStarted extends FriendCodeEvent {
  const FriendCodeStarted();
}

class FriendCodeProfileUpdated extends FriendCodeEvent {
  const FriendCodeProfileUpdated(this.friendCode);

  final String friendCode;

  @override
  List<Object?> get props => [friendCode];
}

class FriendCodeProfileFailed extends FriendCodeEvent {
  const FriendCodeProfileFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

class FriendCodeGeneratePressed extends FriendCodeEvent {
  const FriendCodeGeneratePressed();
}
