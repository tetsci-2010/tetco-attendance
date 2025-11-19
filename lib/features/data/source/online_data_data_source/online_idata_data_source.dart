import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/providers/employee_provider.dart';
import 'package:tetco_attendance/packages/firebase_packages/firebase_database_package.dart';
import 'package:tetco_attendance/packages/uuid_package/uuid_package.dart';
import 'package:tetco_attendance/utils/dependency_injection.dart';

abstract class OnlineIDataDataSource {
  Future<EmployeeModel> createEmployee(EmployeeModel employee);
  Future<List<EmployeeModel>> fetchAllEmployees({bool isRefresh = false});
}

final class OnlineDataSourceImp implements OnlineIDataDataSource {
  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      String? imageProf;
      // if (employee.image != null) {
      //   imageProf = await firebase.uploadUserImage(File(employee.image!), id);
      // }
      // for (var i = 0; i < 100; i++) {
      String id = UuidPackage.generateNumber();
      await FirebaseFirestoreService.create(
        'employees',
        {
          'id': id,
          'name': employee.name,
          'fName': employee.fName,
          'status': employee.status?.name,
          'nick_name': employee.nickName,
          'phone': employee.phone,
          'description': employee.description,
          'photo': imageProf,
          'created_at': Timestamp.now(),
          'updated_at': Timestamp.now(),
        },
      );
      // }
      return employee;
    } on FirebaseException catch (e) {
      throw AppException(errorMessage: e.toString(), statusCode: e.code);
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<EmployeeModel>> fetchAllEmployees({bool isRefresh = false}) async {
    try {
      List<Map<String, dynamic>> employees = await FirebaseFirestoreService.readPaginate('employees', refresh: isRefresh, limit: 15);
      List<EmployeeModel> pEmployees = [];
      for (var i = 0; i < employees.length; i++) {
        EmployeeModel emp = EmployeeModel.fromJson(employees[i]);
        pEmployees.add(emp);
      }
      if (isRefresh) di<EmployeeProvider>().clearEmployees();
      di<EmployeeProvider>().addEmployees(pEmployees);
      return pEmployees;
    } on FirebaseException catch (e) {
      throw AppException(errorMessage: e.toString(), statusCode: e.code);
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
