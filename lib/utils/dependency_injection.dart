import 'package:get_it/get_it.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/provider/employee_provider.dart';
import 'package:tetco_attendance/features/data/providers/project_attendance_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/providers/project_provider.dart';
import 'package:tetco_attendance/features/data/repository/online_data_repository/online_idata_repository.dart';
import 'package:tetco_attendance/features/data/services/employee_service.dart';
import 'package:tetco_attendance/features/data/blocs/employee_bloc/employee_bloc.dart';
import 'package:tetco_attendance/features/data/source/online_data_data_source/online_idata_data_source.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  /// 🔹 DATA SOURCES
  di.registerLazySingleton<OnlineDataSourceImp>(() => OnlineDataSourceImp());

  /// 🔹 REPOSITORIES
  di.registerLazySingleton<OnlineIDataRepositoryImp>(() => OnlineIDataRepositoryImp(onlineIDataDataSource: di<OnlineDataSourceImp>()));

  /// 🔹 SERVICES
  di.registerLazySingleton<EmployeeService>(() => EmployeeService(onlineRepositoryImp: di<OnlineIDataRepositoryImp>()));

  /// 🔹 BLOCS
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());
  di.registerFactory<EmployeeBloc>(() => EmployeeBloc(di<EmployeeService>()));

  /// 🔹 PROVIDERS
  di.registerLazySingleton<AppProvider>(() => AppProvider());
  di.registerLazySingleton<EmployeeProvider>(() => EmployeeProvider());
  di.registerLazySingleton<ProjectProvider>(() => ProjectProvider());
  di.registerLazySingleton<ProjectAttendanceProvider>(() => ProjectAttendanceProvider());
}
