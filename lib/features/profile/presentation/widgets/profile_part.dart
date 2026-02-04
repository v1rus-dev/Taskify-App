import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:taskify/features/profile/presentation/widgets/profile_card.dart';
import 'package:taskify/features/profile/presentation/widgets/sign_in_part.dart';
import 'package:taskify/features/profile/presentation/widgets/friends_part.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/services/talker_service.dart';

class ProfilePart extends StatelessWidget {
  const ProfilePart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.profileUser != curr.profileUser,
      builder: (context, state) {
        TalkerService.instance.info('ProfilePart build');
        final user = state.profileUser;
        if (user == null) {
          return const SignInPart();
        }
        return Column(
          children: [
            ProfileCard(user: user),
            const Gap(12),
            const FriendsPart(),
          ],
        );
      },
    );
  }
}
