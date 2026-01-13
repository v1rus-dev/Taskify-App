import 'package:flutter/foundation.dart';
import 'package:taskify/core/services/talker_service.dart';

Future<void> setupLogging() async {
  if (kDebugMode) {
    TalkerService.init();
  }
}