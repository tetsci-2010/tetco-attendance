import 'package:go_router/go_router.dart';
import 'package:tetco_attendance/main.dart';

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
  ],
);
