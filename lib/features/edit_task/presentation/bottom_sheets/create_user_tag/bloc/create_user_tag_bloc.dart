import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_tag_event.dart';
part 'create_user_tag_state.dart';
part 'create_user_tag_bloc.freezed.dart';

class CreateUserTagBloc extends Bloc<CreateUserTagEvent, CreateUserTagState> {
  CreateUserTagBloc() : super(_Initial()) {
    on<CreateUserTagEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
