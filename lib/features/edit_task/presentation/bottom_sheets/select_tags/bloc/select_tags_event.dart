part of 'select_tags_bloc.dart';

@freezed
class SelectTagsEvent with _$SelectTagsEvent {
  const factory SelectTagsEvent.started() = _Started;

  const factory SelectTagsEvent.tagToggled(TagEntity tag) = _TagToggled;

  const factory SelectTagsEvent.createTagPressed() = _CreateTagPressed;

  const factory SelectTagsEvent.updateUserTags(List<TagEntity> tags) = _UpdateUserTags;
}
