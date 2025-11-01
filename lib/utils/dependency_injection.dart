import 'package:get_it/get_it.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/bloc/localization_bloc.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/data/providers/employee_provider.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  // Providers (state management)
  di.registerFactory<AppProvider>(() => AppProvider());
  // Employee Provider
  di.registerFactory<EmployeeProvider>(() => EmployeeProvider());
  //
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());
}
