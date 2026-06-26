import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/models/home_initial_model.dart';

class HomeProvider extends ChangeNotifier {
  HomeInitialModel? homeInitialModel;
  void updateHomeInit(HomeInitialModel? homeInit) {
    homeInitialModel = homeInit;
    notifyListeners();
  }
}
