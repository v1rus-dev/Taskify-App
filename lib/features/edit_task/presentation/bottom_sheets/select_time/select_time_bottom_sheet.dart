import 'package:design/constants/app_insets.dart';
import 'package:design/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:taskify/core/providers/time_format_notifier.dart';

class SelectTimeBottomSheet extends StatelessWidget {
  const SelectTimeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final use24Hour = context.select<TimeFormatCubit, bool>(
      (cubit) => cubit.state.use24Hour,
    );
    return Padding(
      padding: AppInsets.sheetHorizontalSmallPadding,
      child: Column(
        children: [
          const Gap(24),
          Text(
            'from',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppTimePicker(
            initialTime: TimeOfDay.now(),
            use24hFormat: use24Hour,
            canSelectPastTime: true,
            onTimeChanged: _onStartTimeChanged,
          ),
          const Gap(12),
          Text(
            'to',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppTimePicker(
            initialTime: TimeOfDay.now(),
            use24hFormat: use24Hour,
            canSelectPastTime: false,
            onTimeChanged: _onEndTimeChanged,
          ),
        ],
      ),
    );
  }

  void _onStartTimeChanged(TimeOfDay time) {
    print(time);
  }

  void _onEndTimeChanged(TimeOfDay time) {
    print(time);
  }
}
