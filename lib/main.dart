import 'package:flutter/material.dart';
import 'package:taskify/app/setup/setup_app.dart';
import 'package:taskify/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await setupApp();

  runApp(const ProviderScope(child: TaskifyApp()));
}