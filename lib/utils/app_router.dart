import 'package:go_router/go_router.dart';
import 'package:tetco_attendance/features/screens/initial_screens/login_screen.dart';
import 'package:tetco_attendance/features/screens/initial_screens/splash_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/home_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/main_home_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/attendance_screen/attendance_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/payroll_screen/payroll_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/employee_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/project_roll_call_screen/project_roll_call_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/projects_screen.dart';

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
    GoRoute(
      path: PayrollScreen.id,
      name: PayrollScreen.name,
      builder: (context, state) {
        return PayrollScreen();
      },
    ),
    GoRoute(
      path: AttendanceScreen.id,
      name: AttendanceScreen.name,
      builder: (context, state) {
        return AttendanceScreen();
      },
    ),
    // GoRoute(
    //   path: AttendanceScreen.id,
    //   name: AttendanceScreen.name,
    //   builder: (context, state) {
    //     return AttendanceScreen();
    //   },
    // ),
    GoRoute(
      path: ProjectsScreen.id,
      name: ProjectsScreen.name,
      builder: (context, state) {
        return ProjectsScreen();
      },
    ),
    GoRoute(
      path: ProjectRollCallScreen.id,
      name: ProjectRollCallScreen.name,
      builder: (context, state) {
        return ProjectRollCallScreen(projectId: state.extra as String?);
      },
    ),
    GoRoute(
      path: EmployeeScreen.id,
      name: EmployeeScreen.name,
      builder: (context, state) {
        return EmployeeScreen();
      },
    ),
  ],
);
