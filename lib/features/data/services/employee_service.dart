import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/repository/online_data_repository/online_idata_repository.dart';

class EmployeeService {
  final OnlineIDataRepositoryImp onlineRepositoryImp;

  const EmployeeService({required this.onlineRepositoryImp});

  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      final result = await onlineRepositoryImp.createEmployee(employee);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }

  Future<List<EmployeeModel>> fetchAllEmployees() async {
    try {
      final result = await onlineRepositoryImp.fetchAllEmployees();
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
