import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/domain/models/tasks_view_type.dart';
import 'package:taskify/features/home/presentation/screen/home_screen_state.dart';
import 'package:taskify/core/services/talker_service.dart';

final homeScreenNotifierProvider = NotifierProvider<HomeScreenNotifier, HomeScreenState>(() => HomeScreenNotifier());

class HomeScreenNotifier extends Notifier<HomeScreenState>{

  HomeScreenNotifier() : super() {
    TalkerService.instance.info('HomeScreenNotifier initialized');
  }

  @override
  HomeScreenState build() {
    return HomeScreenState(isLoading: true);
  }

  void updateLoading() async {
    state = state.copyWith(isLoading: !state.isLoading, message: 'Home data fetched successfully');
  }

  void changeCalendarState() {
    TalkerService.instance.info('Calendar currentState: ${state.isHeaderExpanded}');
    state = state.copyWith(isHeaderExpanded: !state.isHeaderExpanded);
    TalkerService.instance.info('Calendar newState: ${state.isHeaderExpanded}');
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void changeTasksViewType(TasksViewType tasksViewType) {
    state = state.copyWith(tasksViewType: tasksViewType);
  }
}