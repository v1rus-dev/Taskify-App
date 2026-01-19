import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:design/design.dart';

class AppDateTimePicker {
  const AppDateTimePicker._();

  static Future<DateTime?> pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String doneText = 'Done',
  }) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _showCupertinoPicker(
        context: context,
        initialDateTime: initialDate,
        mode: CupertinoDatePickerMode.date,
        doneText: doneText,
      );
    }

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
    required TimeOfDay initialTime,
    bool use24hFormat = false,
    Locale? localeOverride,
    String doneText = 'Done',
  }) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final initialDateTime = _timeToDateTime(initialTime);
      final selected = await _showCupertinoPicker(
        context: context,
        initialDateTime: initialDateTime,
        mode: CupertinoDatePickerMode.time,
        use24hFormat: use24hFormat,
        doneText: doneText,
      );
      return selected == null ? null : TimeOfDay.fromDateTime(selected);
    }

    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        Widget content = MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24hFormat),
          child: child,
        );

        if (localeOverride != null) {
          content = Localizations.override(
            context: context,
            locale: localeOverride,
            child: content,
          );
        }

        return content;
      },
    );
  }

  static Future<DateTime?> _showCupertinoPicker({
    required BuildContext context,
    required DateTime initialDateTime,
    required CupertinoDatePickerMode mode,
    bool use24hFormat = false,
    String doneText = 'Done',
  }) async {
    DateTime selected = initialDateTime;
    DateTime? result;

    void onDonePressed() {
      result = selected;
      Navigator.of(context).pop();
    }

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final bottomSafeArea = MediaQuery.viewPaddingOf(context).bottom;
        return Container(
          height: 320,
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColorExtensions.getBackgroundColor(context),
            borderRadius: AppRadius.bottomSheetTop,
          ),
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: mode,
                  initialDateTime: initialDateTime,
                  use24hFormat: use24hFormat,
                  onDateTimeChanged: (date) {
                    selected = date;
                  },
                ),
              ),
              const Gap(12),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 20 + bottomSafeArea,
                  left: 20,
                  right: 20,
                ),
                child: AppTextButton(
                  text: doneText,
                  onPressed: onDonePressed,
                ),
              ),
            ],
          ),
        );
      },
    );

    return result;
  }

  static DateTime _timeToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
  }
}
