import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/utils/go_router.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.72727272727275, 856.7272727272727),
      minTextAdapt: true,
      splitScreenMode: true,

      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = '/splash_screen';
  static const String name = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {},
    );
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
        child: Text('data'),
      ),
    );
  }
}
