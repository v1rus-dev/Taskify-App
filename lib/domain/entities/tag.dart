import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:taskify/domain/entities/default_tag.dart';

abstract class TagEntity extends Equatable {
  final int id;
  final String title;
  final Color color;

  const TagEntity({
    required this.id,
    required this.title,
    required this.color,
  });

  bool get isCustom;

  @override
  List<Object?> get props => [id, title, color, isCustom];
}

class DefaultTagEntity extends TagEntity {
  final DefaultTag defaultTag;

  DefaultTagEntity({
    required this.defaultTag,
  }) : super(
          id: defaultTag.id,
          title: defaultTag.title,
          color: defaultTag.color,
        );

  @override
  bool get isCustom => false;
}

class CustomTagEntity extends TagEntity {
  const CustomTagEntity({
    required super.id,
    required super.title,
    required super.color,
  });

  @override
  bool get isCustom => true;
}
