import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

class ActivityTopTag extends Equatable {
  const ActivityTopTag({
    required this.tagId,
    required this.isCustom,
    required this.title,
    required this.colorValue,
    required this.usageCount,
  });

  final int tagId;
  final bool isCustom;
  final String title;
  final int colorValue;
  final int usageCount;

  @override
  List<Object?> get props => [tagId, isCustom, title, colorValue, usageCount];
}
