import 'package:flutter/material.dart';
import 'package:taskify/domain/entities/task.dart';
import 'package:design/design.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return AppShadow(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.task.title, style: AppTypography.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
