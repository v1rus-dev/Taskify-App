part of 'select_tags_bloc.dart';

@freezed
class SelectTagsEvent with _$SelectTagsEvent {
  const factory SelectTagsEvent.started() = _Started;
}