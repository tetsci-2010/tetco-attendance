import 'package:get_it/get_it.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/bloc/localization_bloc.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());
}
