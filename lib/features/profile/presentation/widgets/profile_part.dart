import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/features/profile/presentation/widgets/profile_card.dart';

class ProfilePart extends StatelessWidget {
  const ProfilePart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.profileUser != curr.profileUser,
      builder: (context, state) {
        final user = state.profileUser;
        if (user == null) return const SizedBox.shrink();
        return ProfileCard(user: user);
      },
    );
  }
}
