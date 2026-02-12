part of 'add_friend_bloc.dart';

class AddFriendState extends Equatable {
  const AddFriendState({
    this.friendCode = '',
    this.stateType = AddFriendStateType.textField,
  });

  final String friendCode;
  final AddFriendStateType stateType;

  AddFriendState copyWith({String? friendCode, AddFriendStateType? stateType}) {
    return AddFriendState(
      friendCode: friendCode ?? this.friendCode,
      stateType: stateType ?? this.stateType,
    );
  }

  @override
  List<Object?> get props => [friendCode, stateType];
}
