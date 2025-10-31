import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class FlutterDatetimePickerPlusPackage {
  static Future<Jalali?> showAfghanDatePicker({
    required BuildContext context,
    Jalali? initialDate,
    Jalali? firstDate,
    Jalali? lastDate,
  }) async {
    return showPersianDatePicker(
      context: context,
      initialDate: initialDate ?? Jalali.now(),
      firstDate: firstDate ?? Jalali(1300, 1),
      lastDate: lastDate ?? Jalali(1500, 12),
      locale: Locale('fa'),
    );
  }
}
