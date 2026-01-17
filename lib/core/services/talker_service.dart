import 'package:talker/talker.dart';

class TalkerService {
  static Talker? _instance;

  static Talker get instance {
    _instance ??= Talker(
      settings: TalkerSettings(
        colors: Map<String, AnsiPen>.fromEntries([
          MapEntry('info', AnsiPen()..rgb(r: 0.2, g: 0.6, b: 1.0)),
          MapEntry('error', AnsiPen()..rgb(r: 1.0, g: 0.2, b: 0.2)),
          MapEntry('warning', AnsiPen()..rgb(r: 1.0, g: 0.7, b: 0.0)),
          MapEntry('debug', AnsiPen()..rgb(r: 0.5, g: 0.5, b: 0.5)),
          MapEntry('verbose', AnsiPen()..rgb(r: 0.7, g: 0.7, b: 0.7)),
        ]),
      ),
    );
    return _instance!;
  }

  static void init() {
    instance;
  }
}
