import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/utils/random_color.dart';

class AppProvider extends ChangeNotifier {
  int selectedScreen = 0;
  void updateSelectedScreen(int index) {
    selectedScreen = index;
    notifyListeners();
  }

  List<EmployeeModel> employees = [];

  void populateEmployees() {
    employees = [
      EmployeeModel(id: 1, name: 'بهرام', fName: 'افشار', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 2, name: 'احمد', fName: 'محمدی', status: AttStatusEnums.latee, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 3, name: 'فاطمه', fName: 'نوری', status: AttStatusEnums.absent, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 4, name: 'مهدی', fName: 'کاظمی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 5, name: 'رضا', fName: 'جعفری', status: AttStatusEnums.latee, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 6, name: 'زهرا', fName: 'احمدی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 7, name: 'حمید', fName: 'قادری', status: AttStatusEnums.absent, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 8, name: 'نسیم', fName: 'پناهی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 9, name: 'کیوان', fName: 'صالح', status: AttStatusEnums.latee, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 10, name: 'مریم', fName: 'حسینی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 11, name: 'فرهاد', fName: 'نعمتی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 12, name: 'شیرین', fName: 'اکبری', status: AttStatusEnums.latee, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 13, name: 'پوریا', fName: 'دلاوری', status: AttStatusEnums.absent, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 14, name: 'سمیرا', fName: 'هاشمی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 15, name: 'محمد', fName: 'قاسمی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 16, name: 'الناز', fName: 'رستمی', status: AttStatusEnums.latee, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 17, name: 'کیوان', fName: 'عباسی', status: AttStatusEnums.absent, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 18, name: 'نرگس', fName: 'یزدانی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 19, name: 'حسین', fName: 'صادقی', status: AttStatusEnums.latee, imageHolderColor: randomVibrantColorWithAlpha()),
      EmployeeModel(id: 20, name: 'پریسا', fName: 'شریفی', status: AttStatusEnums.present, imageHolderColor: randomVibrantColorWithAlpha()),
    ];
    notifyListeners();
  }

  List<SuperTooltipController> tooltipControllers = [];

  void populateControllers() {
    print(employees.length);
    for (var i = 0; i < employees.length; i++) {
      tooltipControllers.add(SuperTooltipController());
    }
    notifyListeners();
  }

  void disposeControllers() {
    for (var contr in tooltipControllers) {
      contr.dispose();
    }
    notifyListeners();
  }

  bool isSearchingEmp = false;
  void toggleIsSearchingEmp() {
    isSearchingEmp = !isSearchingEmp;
    notifyListeners();
  }
}
