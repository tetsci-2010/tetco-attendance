import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/models/home_initial_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/source/online_ihome_data_source.dart';

abstract class OnlineIHomeRepository extends OnlineIHomeDataSource {
  static OnlineHomeRepositoryImp onlineHomeRepositoryImp = OnlineHomeRepositoryImp(onlineHomeDataSourceImp: OnlineHomeDataSourceImp());
}

class OnlineHomeRepositoryImp implements OnlineIHomeRepository {
  final OnlineHomeDataSourceImp onlineHomeDataSourceImp;

  const OnlineHomeRepositoryImp({required this.onlineHomeDataSourceImp});

  @override
  Future<HomeInitialModel> initializeHome() async {
    try {
      final result = await onlineHomeDataSourceImp.initializeHome();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
