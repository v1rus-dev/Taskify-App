import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_tags_event.dart';
part 'select_tags_state.dart';
part 'select_tags_bloc.freezed.dart';

class SelectTagsBloc extends Bloc<SelectTagsEvent, SelectTagsState> {
  SelectTagsBloc() : super(_Initial()) {
    on<SelectTagsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
