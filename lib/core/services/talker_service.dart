import 'package:talker/talker.dart';

class TalkerService {
  static Talker? _instance;

  static Talker get instance {
    _instance ??= Talker();
    return _instance!;
  }

  static void init() {
    instance;
  }
}