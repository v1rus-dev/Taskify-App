part of 'add_friend_bloc.dart';

class AddFriendState extends Equatable {
  const AddFriendState({
    this.friendCode = '',
    this.stateType = AddFriendStateType.qrCode,
  });

  final String friendCode;
  final AddFriendStateType stateType;

  AddFriendState copyWith({
    String? friendCode,
  }) {
    return AddFriendState(
      friendCode: friendCode ?? this.friendCode,
    );
  }

  @override
  List<Object?> get props => [friendCode];
}