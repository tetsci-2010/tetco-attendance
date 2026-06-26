import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/models/home_initial_model.dart';

abstract class OnlineIHomeDataSource {
  Future<HomeInitialModel> initializeHome();
}

class OnlineHomeDataSourceImp implements OnlineIHomeDataSource {
  @override
  Future<HomeInitialModel> initializeHome() async {
    try {
      final presentsSnap = await FirebaseFirestore.instance.collection('employees').where('status', isEqualTo: 'PRESENT').count().get();
      final absentsSnap = await FirebaseFirestore.instance.collection('employees').where('status', isEqualTo: 'ABSENT').count().get();
      final latesSnap = await FirebaseFirestore.instance.collection('employees').where('status', isEqualTo: 'LATE').count().get();
      final noStatusesSnap = await FirebaseFirestore.instance.collection('employees').where('status', isEqualTo: null).count().get();
      final allProjects = await FirebaseFirestore.instance.collection('projects').count().get();
      final initializedEmployeesSnap = await FirebaseFirestore.instance.collection('projects').get();
      List employees = initializedEmployeesSnap.docs.map((e) => e.data()['employees']).toSet().toList();
      final allEmployees = await FirebaseFirestore.instance.collection('employees').count().get();

      return HomeInitialModel(
        presents: presentsSnap.count ?? 0,
        absents: absentsSnap.count ?? 0,
        lates: latesSnap.count ?? 0,
        noStatuses: noStatusesSnap.count ?? 0,
        totalProjects: allProjects.count ?? 0,
        totalEmployeesProjects: employees.length,
        totalEmployees: allEmployees.count ?? 0,
      );
    } on FirebaseException catch (e) {
      throw AppException(errorMessage: e.message ?? '${e.stackTrace ?? e.plugin}', statusCode: e.code);
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
