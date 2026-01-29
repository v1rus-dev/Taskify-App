import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/edit_task/presentation/bloc/edit_task/edit_task_bloc.dart';
import 'package:design/design.dart';

class EditTaskDatePeriodCard extends StatelessWidget {
  const EditTaskDatePeriodCard({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditTaskBloc, EditTaskState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorExtensions.getCardColor(context),
          ),
        );
      },
    );
  }
}
