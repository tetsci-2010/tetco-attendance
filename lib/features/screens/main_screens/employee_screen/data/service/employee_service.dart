import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/paginate_result_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_create_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/repository/local_iemployee_repository.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/repository/online_iemployee_repository.dart';

class EmployeeService {
  final OnlineEmployeeRepositoryImp onlineEmployeeRepositoryImp;
  final LocalEmployeeRepositoryImp localEmployeeRepositoryImp;

  const EmployeeService({required this.onlineEmployeeRepositoryImp, required this.localEmployeeRepositoryImp});

  Future<String> createEmployee(EmployeeCreateModel employee) async {
    try {
      final result = await onlineEmployeeRepositoryImp.createEmployee(employee);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }

  Future<PaginateResult> fetchEmployees({
    bool isRefresh = false,
    String? searchKey,
    String? status,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
  }) async {
    try {
      final result = await onlineEmployeeRepositoryImp.fetchEmployees(isRefresh: isRefresh, lastDoc: lastDoc);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
