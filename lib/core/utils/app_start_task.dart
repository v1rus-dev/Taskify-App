abstract class AppStartTask {
  String get id;
  bool get requiresAuth;
  Future<void> run();
}
