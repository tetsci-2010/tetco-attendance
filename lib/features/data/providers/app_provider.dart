import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';

class AppProvider extends ChangeNotifier {
  int selectedScreen = 0;
  void updateSelectedScreen(int index) {
    selectedScreen = index;
    notifyListeners();
  }

  bool isSearchingEmp = false;
  void toggleIsSearchingEmp([bool? isSearching]) {
    if (isSearching == null) {
      isSearchingEmp = !isSearchingEmp;
    } else {
      isSearchingEmp = isSearching;
    }
    notifyListeners();
  }

  AttStatusEnums? sStatusFilter;
  void updateSelectedStatus(AttStatusEnums status) {
    sStatusFilter = status;
    notifyListeners();
  }

  void resetFilter() {
    sStatusFilter = null;
    notifyListeners();
  }

  Jalali? pickedDate = Jalali.now();
  void updatePickedDate(Jalali? date) {
    pickedDate = date;
    notifyListeners();
  }

  void clearPickedDate() {
    pickedDate = null;
    notifyListeners();
  }
}
