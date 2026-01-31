import 'package:flutter/services.dart';
import 'package:taskify/core/native_widgets/task_widget_constants.dart';

class TaskWidgetBridge {
  static const MethodChannel _channel = MethodChannel(taskWidgetChannelName);

  Future<String?> getSharedContainerPath() async {
    final path = await _channel.invokeMethod<String>('getSharedContainerPath');
    return path;
  }

  Future<void> refreshWidgets() async {
    await _channel.invokeMethod<void>('refreshWidgets');
  }
}
