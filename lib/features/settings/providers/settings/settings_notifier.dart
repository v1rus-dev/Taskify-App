// final settingsNotifierProvider =
//     NotifierProvider<SettingsNotifier, SettingsState>(
//       () => SettingsNotifier(db: locator<AppDatabase>()),
//     );

// class SettingsNotifier extends Notifier<SettingsState> {
//   SettingsNotifier({required this.db})
//     : interactor = AppConfigurationInteractor(db),
//       super();

//   final AppDatabase db;
//   final AppConfigurationInteractor interactor;
//   StreamSubscription<AppConfigurationsTableData?>? _configSubscription;

//   @override
//   SettingsState build() {

//     _observeTimeFormat();

//     return SettingsState(timeFormat: TimeFormatType.hour24);
//   }

//   void _observeTimeFormat() async {
//     _configSubscription = interactor.observeConfiguration().listen((config) {
//       final timeFormat = timeFormatTypeFromBool(config?.use24Hour ?? true);
//       state = state.copyWith(timeFormat: timeFormat);
//     });

//     ref.onDispose(() {
//       _configSubscription?.cancel();
//     });
//   }

//   Future<void> setTimeFormat(TimeFormatType type) async {
//     return await interactor.setTimeFormat(type);
//   }

//   Future<void> deleteAccount() async => Future.value();
// }
