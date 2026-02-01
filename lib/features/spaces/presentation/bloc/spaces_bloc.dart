import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spaces_event.dart';
part 'spaces_state.dart';

class SpacesBloc extends Bloc<SpacesEvent, SpacesState> {
  SpacesBloc() : super(SpacesInitial()) {
    on<SpacesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
