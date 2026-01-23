import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/domain/tags/models/default_tag.dart';
import 'package:taskify/domain/tags/models/tag.dart';
import 'package:taskify/features/edit_task/domain/usecases/tag_interactor.dart';

part 'select_tags_event.dart';
part 'select_tags_state.dart';
part 'select_tags_bloc.freezed.dart';

class SelectTagsBloc extends Bloc<SelectTagsEvent, SelectTagsState> {
  SelectTagsBloc({Set<String>? initialSelectedTagKeys})
      : _initialSelectedTagKeys =
            Set<String>.from(initialSelectedTagKeys ?? {}),
        _tagInteractor = locator<TagInteractor>(),
        super(const SelectTagsState.initial()) {
    on<SelectTagsEvent>(_onEvent);
  }

  final Set<String> _initialSelectedTagKeys;
  final TagInteractor _tagInteractor;
  StreamSubscription<List<TagEntity>>? _customTagsSubscription;

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

  Future<void> _onStarted(Emitter<SelectTagsState> emit) async {
    final customTagsResult = await _tagInteractor.getCustomTags();
    List<TagEntity> customTags = const [];
    customTagsResult.fold(
      ifLeft: (_) => customTags = const [],
      ifRight: (tags) => customTags = tags,
    );
    emit(
      SelectTagsState.success(
        defaultTags: _buildDefaultTags(),
        customTags: customTags,
        selectedTagKeys: _initialSelectedTagKeys,
      ),
    );
    await _customTagsSubscription?.cancel();
    _customTagsSubscription = _tagInteractor.observeCustomTags().listen((tags) {
      state.maybeMap(
        success: (state) =>
            emit(state.copyWith(customTags: tags)),
        orElse: () => emit(
          SelectTagsState.success(
            defaultTags: _buildDefaultTags(),
            customTags: tags,
            selectedTagKeys: _initialSelectedTagKeys,
          ),
        ),
      );
    });
  }

  void _onTagToggled(TagEntity tag, Emitter<SelectTagsState> emit) {
    state.maybeMap(
      success: (state) {
        final updated = Set<String>.from(state.selectedTagKeys);
        if (updated.contains(tag.key)) {
          updated.remove(tag.key);
        } else {
          updated.add(tag.key);
        }
        emit(state.copyWith(selectedTagKeys: updated));
      },
      orElse: () {},
    );
  }

  List<TagEntity> _buildDefaultTags() {
    return DefaultTag.values
        .map((tag) => DefaultTagEntity(defaultTag: tag))
        .toList(growable: false);
  }

  @override
  Future<void> close() async {
    await _customTagsSubscription?.cancel();
    return super.close();
  }
}
