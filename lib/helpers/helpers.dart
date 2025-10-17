import 'package:flutter/services.dart';

class Helpers {
  static Future<void>  hapticFeedback() async {
    await HapticFeedback.heavyImpact();
  }
}
