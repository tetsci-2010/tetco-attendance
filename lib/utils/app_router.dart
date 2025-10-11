import 'package:go_router/go_router.dart';
import 'package:tetco_attendance/features/screens/initial_screens/login_screen.dart';
import 'package:tetco_attendance/features/screens/initial_screens/splash_screen.dart';

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
  ],
);
