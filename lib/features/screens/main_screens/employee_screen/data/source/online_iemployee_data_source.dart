import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/constants/status_codes.dart';
import 'package:tetco_attendance/features/data/models/employee_role.dart';
import 'package:tetco_attendance/features/data/models/paginate_result_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_create_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/packages/firebase_packages/firebase_database_package.dart';
import 'package:tetco_attendance/packages/uuid_package/uuid_package.dart';

abstract class OnlineIEmployeeDataSource {
  Future<String> createEmployee(EmployeeCreateModel employee);
  Future<PaginateResult> fetchEmployees({String? searchKey, bool isRefresh = false, String? status, QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc});
}

class OnlineEmployeeDataSourceImp implements OnlineIEmployeeDataSource {
  @override
  Future<String> createEmployee(EmployeeCreateModel employee) async {
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
          'status': employee.statusId,
          'nick_name': employee.nickName,
          'phone': employee.phone,
          'description': employee.description,
          'photo': imageProf,
          'color': employee.imageHolderColor,
          'role_id': employee.roleId,
          'created_at': Timestamp.now(),
          'updated_at': Timestamp.now(),
        },
      );
      // }
      return StatusCodes.successCode;
    } on FirebaseException catch (e) {
      throw AppException(errorMessage: e.message ?? '${e.stackTrace ?? e.plugin}', statusCode: e.code);
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }

  @override
  Future<PaginateResult> fetchEmployees({
    String? searchKey,
    bool isRefresh = false,
    String? status,
    QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc,
  }) async {
    try {
      final x = await FirebaseFirestore.instance.collection('employees').get();
      print(x.docs);
      final result = await FirebaseFirestoreService.readPaginate(
        'employees',
        limit: 30,
        searchKey: searchKey,
        lastDoc: lastDoc,
      );
      final employees = result.items;
      print(employees);
      List<EmployeeModel> pEmployees = [];
      for (var i = 0; i < employees.length; i++) {
        final role = await FirebaseFirestoreService.read('emp_roles', '${employees[i]['role_id']}');
        final parsedRole = EmployeeRole.fromJson(role!);
        EmployeeModel emp = EmployeeModel.fromJson(employees[i], parsedRole);
        pEmployees.insert(0, emp);
      }
      final response = PaginateResult(items: pEmployees, lastDoc: lastDoc);
      return response;
    } on FirebaseException catch (e) {
      throw AppException(errorMessage: e.message ?? '${e.stackTrace ?? e.plugin}', statusCode: e.code);
    } catch (e) {
      throw AppException(errorMessage: e.toString());
    }
  }
}
