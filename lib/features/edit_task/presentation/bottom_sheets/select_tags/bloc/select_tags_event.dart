part of 'select_tags_bloc.dart';

abstract class SelectTagsEvent extends Equatable {
  const SelectTagsEvent();

  @override
  List<Object?> get props => [];
}

class SelectTagsStarted extends SelectTagsEvent {
  const SelectTagsStarted();
}

class SelectTagsTagToggled extends SelectTagsEvent {
  const SelectTagsTagToggled(this.tag);

  final TagEntity tag;

  @override
  List<Object?> get props => [tag];
}

class SelectTagsCreateTagPressed extends SelectTagsEvent {
  const SelectTagsCreateTagPressed();
}

class SelectTagsUpdateUserTags extends SelectTagsEvent {
  const SelectTagsUpdateUserTags(this.tags);

  final List<TagEntity> tags;

  @override
  List<Object?> get props => [tags];
}
