import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';

class AttendanceProvider extends ChangeNotifier {
  List<EmployeeModel> employees = [];
  void updateEmployees(List<EmployeeModel> employees) {
    this.employees = employees;
    notifyListeners();
  }

  int totalRows = 0;
}
