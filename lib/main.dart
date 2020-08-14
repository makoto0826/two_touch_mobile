import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:two_touch_mobile/app.dart';
import 'package:two_touch_mobile/infra/infra.dart';
import 'package:two_touch_mobile/worker.dart';

Future<void> main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  final isDevelopment = flavor == 'DEV';

  await initializeHive();
  await initializeWorker(isDevelopment);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(
    ProviderScope(
      child: App(isDevelopment: isDevelopment),
    ),
  );
}
