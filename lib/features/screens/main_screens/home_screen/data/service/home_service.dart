import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/models/home_initial_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/repository/local_ihome_repository.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/repository/online_ihome_repository.dart';

class HomeService {
  final OnlineHomeRepositoryImp onlineHomeRepositoryImp;
  final LocalHomeRepositoryImp localHomeRepositoryImp;

  const HomeService({required this.onlineHomeRepositoryImp, required this.localHomeRepositoryImp});

  Future<HomeInitialModel> initializeHome() async {
    try {
      final result = await onlineHomeRepositoryImp.initializeHome();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
