import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/features/friends_list/presentation/models/add_friend_state_type.dart';

part 'add_friend_event.dart';
part 'add_friend_state.dart';

class AddFriendBloc extends Bloc<AddFriendEvent, AddFriendState> {
  AddFriendBloc() : super(const AddFriendState()) {
    on<AddFriendEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
