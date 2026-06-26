import 'package:get_it/get_it.dart';
import 'package:tetco_attendance/features/data/blocs/localization_bloc/localization_bloc.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/data/repository/online_data_repository/online_idata_repository.dart';
import 'package:tetco_attendance/features/data/source/online_data_data_source/online_idata_data_source.dart';

final di = GetIt.instance;

Future<void> setupDI() async {
  /// 🔹 REPOSITORIES
  di.registerLazySingleton<OnlineIDataRepositoryImp>(() => OnlineIDataRepositoryImp(onlineIDataDataSource: di<OnlineDataSourceImp>()));

  /// 🔹 BLOCS
  di.registerLazySingleton<LocalizationBloc>(() => LocalizationBloc());

  /// 🔹 PROVIDERS
  di.registerLazySingleton<AppProvider>(() => AppProvider());
}
