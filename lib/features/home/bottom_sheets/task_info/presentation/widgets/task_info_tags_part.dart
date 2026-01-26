import 'package:flutter/cupertino.dart';
import 'package:taskify/core/widgets/tag_cheap.dart';
import 'package:taskify/domain/tags/models/tag.dart';

class TaskInfoTagsPart extends StatelessWidget {
  const TaskInfoTagsPart({super.key, required this.tags});

  final List<TagEntity> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      children: tags
          .map((tag) => TagCheap(tag: tag, onPressed: () {}))
          .toList(),
    );
  }
}
