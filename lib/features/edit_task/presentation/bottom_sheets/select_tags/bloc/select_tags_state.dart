part of 'select_tags_bloc.dart';

abstract class SelectTagsState extends Equatable {
  const SelectTagsState();

  @override
  List<Object?> get props => [];
}

class SelectTagsInitial extends SelectTagsState {
  const SelectTagsInitial();
}

class SelectTagsSuccess extends SelectTagsState {
  const SelectTagsSuccess({
    required this.defaultTags,
    required this.customTags,
    required this.selectedTagKeys,
  });

  final List<TagEntity> defaultTags;
  final List<TagEntity> customTags;
  final Set<String> selectedTagKeys;

  SelectTagsSuccess copyWith({
    List<TagEntity>? defaultTags,
    List<TagEntity>? customTags,
    Set<String>? selectedTagKeys,
  }) {
    return SelectTagsSuccess(
      defaultTags: defaultTags ?? this.defaultTags,
      customTags: customTags ?? this.customTags,
      selectedTagKeys: selectedTagKeys ?? this.selectedTagKeys,
    );
  }

  @override
  List<Object?> get props => [defaultTags, customTags, selectedTagKeys];
}

class SelectTagsError extends SelectTagsState {
  const SelectTagsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
