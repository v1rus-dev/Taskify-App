import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/data/interactors/app_configuration_interactor.dart';
import 'package:taskify/core/services/locator.dart';
import 'package:taskify/core/database/app_database.dart';
import 'package:taskify/domain/models/time_format_type.dart';

class TimeFormatState {
  final TimeFormatType type;

  const TimeFormatState({required this.type});

  bool get use24Hour => type.is24Hour;
}

class TimeFormatCubit extends Cubit<TimeFormatState> {
  TimeFormatCubit({required AppConfigurationInteractor interactor})
      : _interactor = interactor,
        super(
          const TimeFormatState(
            type: TimeFormatType.hour24,
          ),
        ) {
    _subscription = _interactor.observeConfiguration().listen(_onConfigChanged);
  }

  factory TimeFormatCubit.withLocator() {
    return TimeFormatCubit(
      interactor: AppConfigurationInteractor(locator<AppDatabase>()),
    );
  }

  final AppConfigurationInteractor _interactor;
  StreamSubscription<AppConfigurationsTableData?>? _subscription;

  void _onConfigChanged(AppConfigurationsTableData? row) {
    final bool use24Hour = row?.use24Hour ?? true;
    emit(
      TimeFormatState(
        type: timeFormatTypeFromBool(use24Hour),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
