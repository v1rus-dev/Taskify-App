import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:taskify/core/native_widgets/task_widget_constants.dart';
import 'package:taskify/core/native_widgets/task_widget_models.dart';
import 'package:taskify/core/native_widgets/task_widget_bridge.dart';

class TaskWidgetStore {
  TaskWidgetStore(this._bridge);

  final TaskWidgetBridge _bridge;

  Future<File> _resolveFile() async {
    if (Platform.isIOS) {
      final sharedPath = await _bridge.getSharedContainerPath();
      if (sharedPath != null && sharedPath.isNotEmpty) {
        return File('$sharedPath/$taskWidgetFileName');
      }
    }
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$taskWidgetFileName');
  }

  Future<WidgetSnapshot> readSnapshot() async {
    final file = await _resolveFile();
    if (!await file.exists()) {
      return WidgetSnapshot.emptyToday();
    }
    final contents = await file.readAsString();
    if (contents.trim().isEmpty) {
      return WidgetSnapshot.emptyToday();
    }
    return WidgetSnapshot.decode(contents);
  }

  Future<void> writeSnapshot(WidgetSnapshot snapshot) async {
    final file = await _resolveFile();
    await file.writeAsString(snapshot.encode());
  }
}
