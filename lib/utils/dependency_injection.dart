import 'package:get_it/get_it.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/bloc/localization_bloc.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  // Providers (state management)
  di.registerFactory<AppProvider>(() => AppProvider());
  //
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());
}
