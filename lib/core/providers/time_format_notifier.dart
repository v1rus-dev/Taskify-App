import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/data/database/app_database.dart';
import 'package:taskify/domain/entities/time_format_type.dart';

class TimeFormatState {
  final TimeFormatType type;

  const TimeFormatState({required this.type});

  bool get use24Hour => type.is24Hour;
}

final timeFormatProvider = StreamProvider<TimeFormatState>((ref) {
  final interactor = AppConfigurationInteractor(locator<AppDatabase>());
  return interactor.observeConfiguration().map(
        (row) => TimeFormatState(
          type: timeFormatTypeFromBool(row?.use24Hour ?? true),
        ),
      );
});
