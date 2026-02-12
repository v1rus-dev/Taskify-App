import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/create_user_tag/bloc/create_user_tag_bloc.dart';
import 'package:taskify/features/tasks/presentation/bottom_sheets/create_user_tag/create_user_tag_bottom_sheet.dart';


class CreateUserTagPage extends StatelessWidget {
  const CreateUserTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateUserTagBloc()..add(const CreateUserTagStarted()),
      child: const CreateUserTagBottomSheet(),
    );
  }
}
