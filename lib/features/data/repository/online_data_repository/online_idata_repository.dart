import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/source/online_data_data_source/online_idata_data_source.dart';

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
  Future<List<EmployeeModel>> fetchAllEmployees({bool isRefresh = false}) async {
    try {
      final result = await onlineIDataDataSource.fetchAllEmployees(isRefresh: isRefresh);
      return result;
    } on AppException catch (_) {
      rethrow;
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
