import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/bloc/localization_bloc.dart';
import 'package:tetco_attendance/features/data/enums/language.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context, LocalizationState localizationState) {
    return ThemeData(
      fontFamily: localizationState.selectedLanguage == Language.persian ? 'BYekan' : 'Poppins',
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kWarningColor,
        linearTrackColor: kWarningTrackColor,
        refreshBackgroundColor: kWarningBgColor,
      ),
      cardColor: kGreyColor200,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor.withAlpha(80), fontWeight: FontWeight.bold),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kRedColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kSecondaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      textTheme: getLightTextTheme(),
    );
  }

  static ThemeData darkTheme(BuildContext context, LocalizationState localizationState) {
    return ThemeData(
      fontFamily: localizationState.selectedLanguage == Language.persian ? 'BYekan' : 'Poppins',
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kWarningColor,
        linearTrackColor: kWarningTrackColor,
        refreshBackgroundColor: kWarningBgColor,
      ),
      cardColor: kGreyColor800,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor.withAlpha(80), fontWeight: FontWeight.bold),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kRedColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kSecondaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      textTheme: getDarkTextTheme(),
    );
  }
}

TextTheme getLightTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: sizeConstants.fontDisplayLarge,
      fontWeight: FontWeight.bold,
      color: kBlackColor87,
    ),
    displayMedium: TextStyle(
      fontSize: sizeConstants.fontDisplayMedium,
      fontWeight: FontWeight.w600,
      color: kBlackColor87,
    ),
    headlineLarge: TextStyle(
      fontSize: sizeConstants.fontHeadlineLarge,
      fontWeight: FontWeight.w600,
      color: kBlackColor87,
    ),
    headlineMedium: TextStyle(
      fontSize: sizeConstants.fontHeadlineMedium,
      fontWeight: FontWeight.w500,
      color: kBlackColor87,
    ),
    titleLarge: TextStyle(
      fontSize: sizeConstants.fontTitleLarge,
      fontWeight: FontWeight.w600,
      color: kBlackColor87,
    ),
    titleMedium: TextStyle(
      fontSize: sizeConstants.fontTitleMedium,
      color: kBlackColor87,
    ),
    bodyLarge: TextStyle(
      fontSize: sizeConstants.fontBodyLarge,
      color: kBlackColor87,
    ),
    bodyMedium: TextStyle(
      fontSize: sizeConstants.fontBodyMedium,
      color: kBlackColor87,
    ),
    labelLarge: TextStyle(
      fontSize: sizeConstants.fontLabelLarge,
      color: kGreyColor700,
    ),
    labelSmall: TextStyle(
      fontSize: sizeConstants.fontLabelSmall,
      color: kGreyColor600,
    ),
  );
}

TextTheme getDarkTextTheme() {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: sizeConstants.fontDisplayLarge,
      fontWeight: FontWeight.bold,
      color: kWhiteColor,
    ),
    displayMedium: TextStyle(
      fontSize: sizeConstants.fontDisplayMedium,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ),
    headlineLarge: TextStyle(
      fontSize: sizeConstants.fontHeadlineLarge,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ),
    headlineMedium: TextStyle(
      fontSize: sizeConstants.fontHeadlineMedium,
      fontWeight: FontWeight.w500,
      color: kWhiteColor,
    ),
    titleLarge: TextStyle(
      fontSize: sizeConstants.fontTitleLarge,
      fontWeight: FontWeight.w600,
      color: kWhiteColor,
    ),
    titleMedium: TextStyle(
      fontSize: sizeConstants.fontTitleMedium,
      color: kWhiteColor,
    ),
    bodyLarge: TextStyle(
      fontSize: sizeConstants.fontBodyLarge,
      color: kWhiteColor,
    ),
    bodyMedium: TextStyle(
      fontSize: sizeConstants.fontBodyMedium,
      color: kWhiteColor70,
    ),
    labelLarge: TextStyle(
      fontSize: sizeConstants.fontLabelLarge,
      color: kGreyColor400,
    ),
    labelSmall: TextStyle(
      fontSize: sizeConstants.fontLabelSmall,
      color: kGreyColor500,
    ),
  );
}
