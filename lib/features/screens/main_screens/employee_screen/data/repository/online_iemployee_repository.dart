import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/paginate_result_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_create_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/source/online_iemployee_data_source.dart';

abstract class OnlineIEmployeeRepository extends OnlineIEmployeeDataSource {
  static final OnlineEmployeeRepositoryImp onlineEmployeeRepositoryImp = OnlineEmployeeRepositoryImp(
    onlineEmployeeDataSourceImp: OnlineEmployeeDataSourceImp(),
  );
}

class OnlineEmployeeRepositoryImp implements OnlineIEmployeeRepository {
  final OnlineEmployeeDataSourceImp onlineEmployeeDataSourceImp;

  const OnlineEmployeeRepositoryImp({required this.onlineEmployeeDataSourceImp});

  @override
  Future<String> createEmployee(EmployeeCreateModel employee) async {
    try {
      final result = await onlineEmployeeDataSourceImp.createEmployee(employee);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }

  @override
  Future<PaginateResult> fetchEmployees({
    bool isRefresh = false,
    String? searchKey,
    String? status,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
  }) async {
    try {
      final result = await onlineEmployeeDataSourceImp.fetchEmployees(isRefresh: isRefresh, searchKey: searchKey, status: status, lastDoc: lastDoc);
      // if (isRefresh) di<EmployeeProvider>().clearEmployees();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
