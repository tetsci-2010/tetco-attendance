import 'package:flutter/material.dart';

class AttendanceNotifiers extends ChangeNotifier {
  static late ValueNotifier<bool> showAppbarTitle;

  static void disposeShowAppbarTitle() {
    try {
      showAppbarTitle.dispose();
    } catch (_) {}
  }
}
