part of 'select_tags_bloc.dart';

@freezed
class SelectTagsState with _$SelectTagsState {
  const factory SelectTagsState.initial() = _Initial;

  const factory SelectTagsState.success({
    required List<TagEntity> defaultTags,
    required List<TagEntity> customTags,
    required Set<String> selectedTagKeys,
  }) = _Success;

  const factory SelectTagsState.error(String message) = _Error;
}
