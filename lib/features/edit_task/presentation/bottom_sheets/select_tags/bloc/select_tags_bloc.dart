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
    : _initialSelectedTagKeys = Set<String>.from(initialSelectedTagKeys ?? {}),
      _tagInteractor = locator<TagInteractor>(),
      super(const SelectTagsState.initial()) {
    on<_Started>(_onStarted);
    on<_TagToggled>(_onTagToggled);
    on<_CreateTagPressed>(_onCreateTagPressed);
    on<_UpdateUserTags>(_onUpdateUserTags);
  }

  final Set<String> _initialSelectedTagKeys;
  final TagInteractor _tagInteractor;
  StreamSubscription<List<TagEntity>>? _customTagsSubscription;

  Future<void> _onStarted(_Started event, Emitter<SelectTagsState> emit) async {
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

    _initSubscription();
  }

  void _onTagToggled(_TagToggled event, Emitter<SelectTagsState> emit) {
    state.maybeMap(
      success: (state) {
        final updated = Set<String>.from(state.selectedTagKeys);
        if (updated.contains(event.tag.key)) {
          updated.remove(event.tag.key);
        } else {
          updated.add(event.tag.key);
        }
        emit(state.copyWith(selectedTagKeys: updated));
      },
      orElse: () {},
    );
  }

  void _onUpdateUserTags(_UpdateUserTags event, Emitter<SelectTagsState> emit) {
    state.maybeMap(
      success: (state) {
        emit(state.copyWith(customTags: event.tags));
      },
      orElse: () {},
    );
  }

  void _onCreateTagPressed(
    _CreateTagPressed event,
    Emitter<SelectTagsState> emit,
  ) {}

  List<TagEntity> _buildDefaultTags() {
    return DefaultTag.values
        .map((tag) => DefaultTagEntity(defaultTag: tag))
        .toList(growable: false);
  }

  void _initSubscription() async {
    await _customTagsSubscription?.cancel();
    _customTagsSubscription = _tagInteractor.observeCustomTags().listen((tags) {
      add(SelectTagsEvent.updateUserTags(tags));
    });
  }

  @override
  Future<void> close() async {
    await _customTagsSubscription?.cancel();
    return super.close();
  }
}
