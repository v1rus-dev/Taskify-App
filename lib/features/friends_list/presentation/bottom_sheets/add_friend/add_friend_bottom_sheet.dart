import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/add_friend/bloc/add_friend_bloc.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/add_friend/widgets/add_friend_header.dart';
import 'package:taskify/features/friends_list/presentation/models/add_friend_state_type.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/add_friend/widgets/add_friend_text_field.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/add_friend/widgets/add_friend_qr_code_scanner.dart';
import 'package:taskify/features/friends_list/domain/friend_code.dart';

class AddFriendBottomSheetPage extends StatelessWidget {
  const AddFriendBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddFriendBloc(),
      child: AddFriendBottomSheet(),
    );
  }
}

class AddFriendBottomSheet extends StatelessWidget {
  AddFriendBottomSheet({super.key});

  final TextEditingController friendCodeController = TextEditingController();

  void _onAddFriendPressed(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    return FloatingBottomSheetLayout(
      children: [
        const AddFriendHeader(),
        const Gap(16),
        BlocBuilder<AddFriendBloc, AddFriendState>(
          builder: (context, state) {
            return switch (state.stateType) {
                AddFriendStateType.textField => AddFriendTextField(
                    key: const ValueKey('textField'),
                    controller: friendCodeController,
                  ),
                AddFriendStateType.qrCode => AddFriendQrCodeScanner(
                    key: const ValueKey('qrCode'),
                    controller: friendCodeController,
                  ),
              };
          },
        ),
        const Gap(20),
        ValueListenableBuilder(
          valueListenable: friendCodeController,
          builder: (context, value, child) {
            final isValid = FriendCode.isValid(value.text);
            return AppTextButton(
              text: 'Add Friend',
              isEnabled: isValid,
              onPressed: () => _onAddFriendPressed(context),
            );
          },
        ),
      ],
    );
  }
}
