import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/tasks/domain/models/default_tag.dart';
import 'package:taskify/features/tasks/domain/models/tag.dart';
import 'package:taskify/features/tasks/domain/usecases/tag_interactor.dart';

part 'select_tags_event.dart';
part 'select_tags_state.dart';

class SelectTagsBloc extends Bloc<SelectTagsEvent, SelectTagsState> {
  SelectTagsBloc({Set<String>? initialSelectedTagKeys})
    : _initialSelectedTagKeys = Set<String>.from(initialSelectedTagKeys ?? {}),
      _tagInteractor = locator<TagInteractor>(),
      super(const SelectTagsInitial()) {
    on<SelectTagsStarted>(_onStarted);
    on<SelectTagsTagToggled>(_onTagToggled);
    on<SelectTagsCreateTagPressed>(_onCreateTagPressed);
    on<SelectTagsUpdateUserTags>(_onUpdateUserTags);
  }

  final Set<String> _initialSelectedTagKeys;
  final TagInteractor _tagInteractor;
  StreamSubscription<List<TagEntity>>? _customTagsSubscription;

  Future<void> _onStarted(
    SelectTagsStarted event,
    Emitter<SelectTagsState> emit,
  ) async {
    final customTagsResult = await _tagInteractor.getCustomTags();
    List<TagEntity> customTags = const [];
    customTagsResult.fold(
      ifLeft: (_) => customTags = const [],
      ifRight: (tags) => customTags = tags,
    );
    emit(
      SelectTagsSuccess(
        defaultTags: _buildDefaultTags(),
        customTags: customTags,
        selectedTagKeys: _initialSelectedTagKeys,
      ),
    );

    _initSubscription();
  }

  void _onTagToggled(
    SelectTagsTagToggled event,
    Emitter<SelectTagsState> emit,
  ) {
    final current = state;
    if (current is! SelectTagsSuccess) {
      return;
    }
    final updated = Set<String>.from(current.selectedTagKeys);
    if (updated.contains(event.tag.key)) {
      updated.remove(event.tag.key);
    } else {
      updated.add(event.tag.key);
    }
    emit(current.copyWith(selectedTagKeys: updated));
  }

  void _onUpdateUserTags(
    SelectTagsUpdateUserTags event,
    Emitter<SelectTagsState> emit,
  ) {
    final current = state;
    if (current is! SelectTagsSuccess) {
      return;
    }
    emit(current.copyWith(customTags: event.tags));
  }

  void _onCreateTagPressed(
    SelectTagsCreateTagPressed event,
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
      add(SelectTagsUpdateUserTags(tags));
    });
  }

  @override
  Future<void> close() async {
    await _customTagsSubscription?.cancel();
    return super.close();
  }
}

