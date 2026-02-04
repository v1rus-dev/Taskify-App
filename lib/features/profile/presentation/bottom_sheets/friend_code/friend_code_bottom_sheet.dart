import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/bloc/friend_code_bloc.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/components/friend_code_actions.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/components/friend_code_caption.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/components/friend_code_loader.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/components/friend_code_qr_card.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/components/friend_code_title.dart';
import 'package:taskify/features/profile/presentation/bottom_sheets/friend_code/components/friend_code_value_card.dart';

class FriendCodeBottomSheetPage extends StatelessWidget {
  const FriendCodeBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FriendCodeBloc()..add(const FriendCodeStarted()),
      child: const FriendCodeBottomSheet(),
    );
  }
}

class FriendCodeBottomSheet extends StatelessWidget {
  const FriendCodeBottomSheet({super.key});

  void _onGeneratePressed(BuildContext context) {
    context.read<FriendCodeBloc>().add(
          const FriendCodeGeneratePressed(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: AppInsets.sheetHorizontal,
        vertical: AppInsets.sheetVertical,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FriendCodeTitle(),
          const Gap(24),
          BlocBuilder<FriendCodeBloc, FriendCodeState>(
            builder: (context, state) {
              final isLoading = state is FriendCodeLoading;
              final friendCode = state.friendCode;
              return Column(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: isLoading
                        ? const FriendCodeLoader(key: ValueKey('loader'))
                        : Column(
                            key: const ValueKey('content'),
                            children: [
                              FriendCodeValueCard(friendCode: friendCode),
                              const Gap(16),
                              FriendCodeQrCard(friendCode: friendCode),
                              const Gap(12),
                              const FriendCodeCaption(),
                            ],
                          ),
                  ),
                  const Gap(24),
                  FriendCodeActions(
                    friendCode: friendCode,
                    isLoading: isLoading,
                    onGeneratePressed: () => _onGeneratePressed(context),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
