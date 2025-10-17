import 'package:go_router/go_router.dart';
import 'package:tetco_attendance/features/screens/initial_screens/login_screen.dart';
import 'package:tetco_attendance/features/screens/initial_screens/splash_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/main_home_screen.dart';

final GoRouter appRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: SplashScreen.id,
  routes: [
    GoRoute(
      path: SplashScreen.id,
      name: SplashScreen.name,
      builder: (context, state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: LoginScreen.id,
      name: LoginScreen.name,
      builder: (context, state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      path: MainHomeScreen.id,
      name: MainHomeScreen.name,
      builder: (context, state) {
        return MainHomeScreen();
      },
    ),
    GoRoute(
      path: HomeScreen.id,
      name: HomeScreen.name,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
  ],
);
