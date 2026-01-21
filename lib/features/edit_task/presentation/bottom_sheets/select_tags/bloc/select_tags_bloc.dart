import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/domain/entities/default_tag.dart';
import 'package:taskify/domain/entities/tag.dart';

part 'select_tags_event.dart';
part 'select_tags_state.dart';
part 'select_tags_bloc.freezed.dart';

class SelectTagsBloc extends Bloc<SelectTagsEvent, SelectTagsState> {
  SelectTagsBloc() : super(const SelectTagsState.initial()) {
    on<SelectTagsEvent>(_onEvent);
  }

  Future<void> _onEvent(
    SelectTagsEvent event,
    Emitter<SelectTagsState> emit,
  ) async {
    await event.map(
      started: (_) async => _onStarted(emit),
      tagToggled: (event) async => _onTagToggled(event.tag, emit),
      createTagPressed: (_) async {},
    );
  }

  void _onStarted(Emitter<SelectTagsState> emit) {
    emit(
      SelectTagsState.success(
        defaultTags: _buildDefaultTags(),
        customTags: const [],
        selectedTagIds: <int>{},
      ),
    );
  }

  void _onTagToggled(TagEntity tag, Emitter<SelectTagsState> emit) {
    state.maybeMap(
      success: (state) {
        final updated = Set<int>.from(state.selectedTagIds);
        if (updated.contains(tag.id)) {
          updated.remove(tag.id);
        } else {
          updated.add(tag.id);
        }
        emit(state.copyWith(selectedTagIds: updated));
      },
      orElse: () {},
    );
  }

  List<TagEntity> _buildDefaultTags() {
    return DefaultTag.values
        .map((tag) => DefaultTagEntity(defaultTag: tag))
        .toList(growable: false);
  }
}
