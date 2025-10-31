// Afghan/Dari weekday names (Saturday = 0)
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DateHelper {
  //
  static List<String> weekDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  // Afghan/Dari month names (numeric order 1-12)
  static List<String> monthNames = ['حمل', 'ثور', 'جوزا', 'سرطان', 'اسد', 'سنبله', 'میزان', 'عقرب', 'قوس', 'جدی', 'دلو', 'حوت'];

  static String formatJalaliDate(Jalali? date) {
    if (date != null) {
      final weekDayName = weekDays[date.weekDay - 1]; // correct mapping
      final monthName = monthNames[date.month - 1];
      return '$weekDayName، ${date.day} $monthName ${date.year}';
    } else {
      return currentDate();
    }
  }

  static String currentDate() {
    try {
      final date = DateTime.now();
      //* Converts to Jalali
      final jDate = Jalali.fromDateTime(date);
      //* Jalali Parsed Date
      final jpDate = formatJalaliDate(jDate);
      return jpDate;
    } catch (e) {
      try {
        final date = DateTime.now().toString().split('T');
        final year = date[0];
        final month = date[1];
        final day = date[2];
        return '$year $month $day';
      } catch (e) {
        return '--';
      }
    }
  }

  static Jalali nextDay(Jalali date) {
    return date.addDays(1);
  }

  static Jalali previousDay(Jalali date) {
    return date.addDays(-1);
  }
}
