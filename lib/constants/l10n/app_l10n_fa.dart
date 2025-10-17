// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get hi => 'سلام';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get emailAddress => 'ایمیل آدرس';

  @override
  String get enterEmailAddress => 'ایمیل آدرس را وارد کنید';

  @override
  String get password => 'رمز عبور';

  @override
  String get enterPassword => 'رمز عبور را وارد کنید';

  @override
  String get pleaseLoginBeforeContinue =>
      'برای ادامه لطفا وارد حساب کاربری خود شوید';

  @override
  String get login => 'ورود';

  @override
  String get thisFieldIsRequired => 'این فیلد ضروری می‌باشد';

  @override
  String get pleaseFillAllRequiredFields =>
      'لطفا تمامی فیلد های لازم را پر کنید';
}
