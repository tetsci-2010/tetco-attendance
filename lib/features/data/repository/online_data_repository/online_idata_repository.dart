import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/providers/employee_provider.dart';
import 'package:tetco_attendance/features/data/source/online_data_data_source/online_idata_data_source.dart';
import 'package:tetco_attendance/utils/dependency_injection.dart';

final onlineDataSourceImp = OnlineIDataRepositoryImp(onlineIDataDataSource: OnlineDataSourceImp());

abstract class OnlineIDataRepository extends OnlineIDataDataSource {}

final class OnlineIDataRepositoryImp implements OnlineIDataRepository {
  final OnlineDataSourceImp onlineIDataDataSource;
  OnlineIDataRepositoryImp({required this.onlineIDataDataSource});

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      final result = await onlineIDataDataSource.createEmployee(employee);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<EmployeeModel>> fetchAllEmployees({bool isRefresh = false, String? searchKey, String? status}) async {
    try {
      final result = await onlineIDataDataSource.fetchAllEmployees(isRefresh: isRefresh, searchKey: searchKey, status: status);
      if (isRefresh) di<EmployeeProvider>().clearEmployees();
      di<EmployeeProvider>().addEmployees(result);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
