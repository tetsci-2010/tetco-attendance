import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/screens/initial_screens/login_screen.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/splash_screen';
  static const String name = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      context.go(LoginScreen.id);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: Container(
        height: getMediaQueryHeight(context),
        width: getMediaQueryWidth(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesPaths.splashBackgroundPng),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TETCO',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kWhiteColor),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.welcome,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
