import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/bloc/localization_bloc.dart';
import 'package:tetco_attendance/utils/app_theme.dart';
import 'package:tetco_attendance/utils/app_router.dart';
import 'package:tetco_attendance/utils/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di<LocalizationBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.72727272727275, 856.7272727272727),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        buildWhen: (previous, current) => previous.selectedLanguage != current.selectedLanguage,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'TETCO Attendance',
            themeMode: ThemeMode.system,
            darkTheme: AppTheme.darkTheme(context),
            theme: AppTheme.lightTheme(context),
            debugShowCheckedModeBanner: false,
            routerDelegate: appRouter.routerDelegate,
            routeInformationParser: appRouter.routeInformationParser,
            routeInformationProvider: appRouter.routeInformationProvider,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.selectedLanguage.value,
          );
        },
      ),
    );
  }
}
