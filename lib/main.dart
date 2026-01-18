import 'package:flutter/material.dart';
import 'package:taskify/app/setup/setup_app.dart';
import 'package:taskify/app/app.dart';

void main() async {
  await setupApp();

  runApp(const TaskifyApp());
}