import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/core/widgets/bloc_side_effect_listener.dart';
import 'package:taskify/features/friends_list/presentation/bottom_sheets/friend_request/bloc/friend_request_bloc.dart';
import 'package:taskify/features/friends_list/presentation/models/friend_request_model_ui.dart';
import 'package:flutter_svg/svg.dart';

class FriendRequestBottomSheetPage extends StatelessWidget {
  const FriendRequestBottomSheetPage({super.key, required this.request});

  final FriendRequestModelUi request;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendRequestBloc(request: request),
      child: const FriendRequestBottomSheet(),
    );
  }
}

class FriendRequestBottomSheet extends StatelessWidget {
  const FriendRequestBottomSheet({super.key});

  List<CardActionEntry> getCardActions(
    BuildContext context,
    FriendRequestModelUi request,
    FriendRequestBloc bloc,
  ) {
    if (!request.isIncoming) {
      return [
        CardActionEntry(
          CardAction(
            title: 'Cancel',
            onPressed: () => bloc.add(const FriendRequestCancelEvent()),
            showArrow: false,
            icon: SvgPicture.asset(
              AppIcons.reject,
              package: AppIcons.packageName,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColorExtensions.getErrorColor(context),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ];
    }

    return [
      CardActionEntry(
        CardAction(
          title: 'Accept',
          onPressed: () => bloc.add(const FriendRequestAcceptEvent()),
          showArrow: false,
          icon: SvgPicture.asset(
            AppIcons.check,
            package: AppIcons.packageName,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColorExtensions.getSuccessColor(context),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      CardActionEntry(
        CardAction(
          title: 'Reject',
          onPressed: () => bloc.add(const FriendRequestRejectEvent()),
          showArrow: false,
          icon: SvgPicture.asset(
            AppIcons.reject,
            package: AppIcons.packageName,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColorExtensions.getErrorColor(context),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    ];
  }

  void _onSideEffect(BuildContext context, FriendRequestSideEffect effect) {
    switch (effect) {
      case FriendRequestCloseBottomSheet():
        context.pop();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSideEffectListener<FriendRequestBloc, FriendRequestSideEffect>(
      listener: (effect) => _onSideEffect(context, effect),
      child: BlocBuilder<FriendRequestBloc, FriendRequestState>(
        builder: (context, state) {
          return FloatingBottomSheetLayout(
            children: [
              Text(
                state.request.user.name ?? '',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                state.request.isIncoming
                    ? 'Incoming friend request'
                    : 'Outgoing friend request',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColorExtensions.getTextSecondaryColor(context),
                ),
              ),
              const Gap(16),
              CardWithActions(
                actions: getCardActions(
                  context,
                  state.request,
                  context.read<FriendRequestBloc>(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
