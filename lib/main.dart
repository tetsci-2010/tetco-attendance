import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/blocs/employee_bloc/employee_bloc.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/data/providers/employee_provider.dart';
import 'package:tetco_attendance/utils/app_theme.dart';
import 'package:tetco_attendance/utils/app_router.dart';
import 'package:tetco_attendance/utils/dependency_injection.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAbi4nBFon-4RzocuSo3lgVvTVnRoY8X-M',
      appId: '1:859791268607:android:8ecd97ec292b8b8fd30aca',
      messagingSenderId: '859791268607',
      projectId: 'tetco-roll',
    ),
  );
  await setupDI();
  await di.allReady();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di<AppProvider>()),
        ChangeNotifierProvider(create: (context) => di<EmployeeProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di<LocalizationBloc>()),
          BlocProvider(create: (context) => di<EmployeeBloc>()),
        ],
        child: ScreenUtilInit(
          designSize: Size(392.72727272727275, 856.7272727272727),
          minTextAdapt: true,
          splitScreenMode: true,
          child: Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return BlocBuilder<LocalizationBloc, LocalizationState>(
                buildWhen: (previous, current) => previous.selectedLanguage != current.selectedLanguage,
                builder: (context, localizationState) {
                  return MaterialApp.router(
                    title: 'TETCO Attendance',
                    themeMode: ThemeMode.system,
                    darkTheme: AppTheme.darkTheme(context, localizationState),
                    theme: AppTheme.lightTheme(context, localizationState),
                    debugShowCheckedModeBanner: false,
                    routerDelegate: appRouter.routerDelegate,
                    routeInformationParser: appRouter.routeInformationParser,
                    routeInformationProvider: appRouter.routeInformationProvider,
                    localizationsDelegates: AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: localizationState.selectedLanguage.value,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
