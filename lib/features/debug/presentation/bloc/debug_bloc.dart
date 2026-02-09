import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'debug_event.dart';
part 'debug_state.dart';

class DebugBloc extends Bloc<DebugEvent, DebugState> {
  DebugBloc() : super(DebugInitial()) {
    on<DebugEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
