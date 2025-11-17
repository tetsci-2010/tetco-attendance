import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  DocumentSnapshot? lastEmpDoc;

  // Map stores employees by ID for O(1) access and deduplication
  Map<String, EmployeeModel> _employeesMap = {};

  // Optional: maintain order for UI
  List<String> _employeeOrder = [];

  List<EmployeeModel> get employees => _employeeOrder.map((id) => _employeesMap[id]!).toList();

  /// Add a batch of employees (for pagination)
  void addEmployees(List<EmployeeModel> newEmployees) {
    for (var emp in newEmployees) {
      if (!_employeesMap.containsKey(emp.id)) {
        _employeeOrder.add(emp.id);
      }
      _employeesMap[emp.id] = emp; // insert or update
    }
    notifyListeners();
  }

  /// Optional: remove employee
  void removeEmployee(String id) {
    _employeesMap.remove(id);
    _employeeOrder.remove(id);
    notifyListeners();
  }

  /// Optional: clear all
  void clearEmployees() {
    _employeesMap.clear();
    _employeeOrder.clear();
    notifyListeners();
  }

  String? empName;
  String? fName;
  String? nickname;
  String? phone;
  String? description;
  String? pickedImage;

  void updatePickedImage(String? path) {
    pickedImage = path;
    notifyListeners();
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }

  void updateEmpName(String? name) {
    empName = name;
    notifyListeners();
  }

  void clearEmpName() {
    empName = null;
    notifyListeners();
  }

  void updateFName(String? fName) {
    this.fName = fName;
    notifyListeners();
  }

  void clearFName() {
    fName = null;
    notifyListeners();
  }

  void updateNickName(String? nickname) {
    this.nickname = nickname;
    notifyListeners();
  }

  void clearNickName() {
    nickname = null;
    notifyListeners();
  }

  void updatePhone(String? phone) {
    this.phone = phone;
    notifyListeners();
  }

  void clearPhone() {
    phone = null;
    notifyListeners();
  }

  void updateDescription(String? desc) {
    description = desc;
    notifyListeners();
  }

  void clearDescription() {
    description = null;
    notifyListeners();
  }
}
