import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/features/debug/presentation/bloc/debug_bloc.dart';
import 'package:taskify/features/notifications/domain/models/pending_notification_entity.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_all_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/cancel_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/get_pending_notifications_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/reconcile_task_reminders_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/schedule_test_notification_use_case.dart';
import 'package:taskify/features/notifications/domain/usecases/show_instant_test_notification_use_case.dart';

class DebugNotificationsScreenPage extends StatelessWidget {
  const DebugNotificationsScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DebugBloc(
        getPendingNotificationsUseCase:
            locator<GetPendingNotificationsUseCase>(),
        showInstantTestNotificationUseCase:
            locator<ShowInstantTestNotificationUseCase>(),
        scheduleTestNotificationUseCase:
            locator<ScheduleTestNotificationUseCase>(),
        cancelNotificationUseCase: locator<CancelNotificationUseCase>(),
        cancelAllNotificationsUseCase: locator<CancelAllNotificationsUseCase>(),
        reconcileTaskRemindersUseCase: locator<ReconcileTaskRemindersUseCase>(),
      )..add(const DebugStarted()),
      child: const DebugNotificationsScreen(),
    );
  }
}

class DebugNotificationsScreen extends StatefulWidget {
  const DebugNotificationsScreen({super.key});

  @override
  State<DebugNotificationsScreen> createState() =>
      _DebugNotificationsScreenState();
}

class _DebugNotificationsScreenState extends State<DebugNotificationsScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _delayController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Debug notification');
    _bodyController = TextEditingController(text: 'This is a test message');
    _delayController = TextEditingController(text: '10');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _delayController.dispose();
    super.dispose();
  }

  void _onBackPressed(BuildContext context) {
    context.pop();
  }

  void _showLocalError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  String _readTitle() {
    final value = _titleController.text.trim();
    if (value.isNotEmpty) {
      return value;
    }
    return 'Debug notification';
  }

  String _readBody() {
    final value = _bodyController.text.trim();
    if (value.isNotEmpty) {
      return value;
    }
    return 'This is a test message';
  }

  void _showNow() {
    context.read<DebugBloc>().add(
      DebugShowInstantNotificationRequested(
        title: _readTitle(),
        body: _readBody(),
      ),
    );
  }

  void _scheduleDelayed() {
    final delaySeconds = int.tryParse(_delayController.text.trim());
    if (delaySeconds == null) {
      _showLocalError('Delay must be a number');
      return;
    }

    context.read<DebugBloc>().add(
      DebugScheduleNotificationRequested(
        title: _readTitle(),
        body: _readBody(),
        delaySeconds: delaySeconds,
      ),
    );
  }

  Widget _buildTestNotificationCard(DebugState state) {
    return CardWithActions(
      actions: [
        CardCustomEntry(
          showTrailingIcon: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test notification',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const Gap(12),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
              const Gap(12),
              TextField(
                controller: _delayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Delay (seconds)'),
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: AppTextButton(
                      text: 'Show now',
                      onPressed: _showNow,
                      isEnabled: !state.isSubmitting,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AppTextButton(
                      text: 'Schedule delay',
                      onPressed: _scheduleDelayed,
                      isEnabled: !state.isSubmitting,
                      backgroundColor: AppColorExtensions.getCardColor(context),
                      textColor: AppColorExtensions.getTextPrimaryColor(
                        context,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      showAppShadow: false,
    );
  }

  Widget _buildPendingControls(DebugState state) {
    return CardWithActions(
      actions: [
        CardActionEntry(
          CardAction(
            title: 'Refresh pending notifications',
            onPressed: () =>
                context.read<DebugBloc>().add(const DebugPendingRequested()),
            isEnabled: !state.isLoadingPending && !state.isSubmitting,
          ),
        ),
        CardActionEntry(
          CardAction(
            title: 'Reconcile task reminders',
            onPressed: () => context.read<DebugBloc>().add(
              const DebugReconcileRemindersRequested(),
            ),
            isEnabled: !state.isLoadingPending && !state.isSubmitting,
          ),
        ),
        CardActionEntry(
          CardAction(
            title: 'Cancel all notifications',
            titleColor: Theme.of(context).colorScheme.error,
            onPressed: () => context.read<DebugBloc>().add(
              const DebugNotificationsCancelAllRequested(),
            ),
            showArrow: false,
            isEnabled: !state.isLoadingPending && !state.isSubmitting,
          ),
        ),
      ],
      showAppShadow: false,
    );
  }

  Widget _buildPendingCard(
    PendingNotificationEntity notification,
    DebugState state,
  ) {
    final title = notification.title?.trim();
    final body = notification.body?.trim();
    final payload = notification.payload?.trim();

    return CardWithActions(
      actions: [
        CardCustomEntry(
          showTrailingIcon: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID ${notification.id}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Gap(8),
              Text('Title: ${title?.isNotEmpty == true ? title : '-'}'),
              const Gap(4),
              Text('Body: ${body?.isNotEmpty == true ? body : '-'}'),
              const Gap(4),
              Text('Payload: ${payload?.isNotEmpty == true ? payload : '-'}'),
            ],
          ),
        ),
        CardActionEntry(
          CardAction(
            title: 'Cancel',
            titleColor: Theme.of(context).colorScheme.error,
            showArrow: false,
            isEnabled: !state.isSubmitting,
            onPressed: () => context.read<DebugBloc>().add(
              DebugNotificationCancelRequested(notification.id),
            ),
          ),
        ),
      ],
      showAppShadow: false,
    );
  }

  Widget _buildPendingList(DebugState state) {
    if (state.isLoadingPending) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.pendingNotifications.isEmpty) {
      return Text(
        'No pending notifications',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Column(
      children: state.pendingNotifications
          .map(
            (notification) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPendingCard(notification, state),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenAppBar(
        title: 'Debug Notifications',
        onBack: () => _onBackPressed(context),
      ),
      body: BlocConsumer<DebugBloc, DebugState>(
        listenWhen: (previous, current) {
          return previous.feedbackId != current.feedbackId &&
              current.feedbackMessage != null;
        },
        listener: (context, state) {
          final text = state.feedbackMessage;
          if (text == null) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(text),
              backgroundColor: state.isErrorFeedback
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification tools',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Gap(8),
                  Text(
                    'Task reminders use taskId as notificationId. Test notifications use IDs from 900000.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(16),
                  _buildTestNotificationCard(state),
                  const Gap(16),
                  _buildPendingControls(state),
                  const Gap(16),
                  Text(
                    'Pending notifications (${state.pendingNotifications.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(12),
                  _buildPendingList(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
