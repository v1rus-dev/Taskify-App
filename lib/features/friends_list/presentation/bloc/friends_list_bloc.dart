import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'friends_list_event.dart';
part 'friends_list_state.dart';

class FriendsListBloc extends Bloc<FriendsListEvent, FriendsListState> {
  FriendsListBloc() : super(FriendsListInitial()) {
    on<FriendsListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
