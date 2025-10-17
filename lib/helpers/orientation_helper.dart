import 'package:flutter/services.dart';

/// 🔒 Lock the app to portrait mode only
Future<void> lockPortrait() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// 🔓 Unlock (allow all orientations)
Future<void> releaseOrientationLock() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
