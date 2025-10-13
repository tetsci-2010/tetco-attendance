import 'package:flutter/material.dart';

bool isRTLDirection(BuildContext context) {
  try {
    if (context.mounted) {
      return Directionality.of(context) == TextDirection.rtl;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
