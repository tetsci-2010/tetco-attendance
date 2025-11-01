import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/constants/lists.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/widgets/add_employee_modal_body.dart';
import 'package:tetco_attendance/utils/popup_helper.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class MainHomeScreen extends StatelessWidget {
  static const String id = '/main_home_screen';
  static const String name = 'main_home_screen';
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: context.watch<AppProvider>().isSearchingEmp == false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        try {
          if (context.read<AppProvider>().isSearchingEmp) {
            context.read<AppProvider>().toggleIsSearchingEmp(false);
          }
        } catch (e) {}
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              //* Appbar
              Container(
                padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing4),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.menu,
                        size: sizeConstants.iconL,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_active_rounded,
                        color: kOrangeColor,
                        size: sizeConstants.iconL,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Selector<AppProvider, int>(
                  selector: (context, appProvider) => appProvider.selectedScreen,
                  builder: (context, selectedScreen, child) {
                    return screens[selectedScreen];
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(1000)),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: kWhiteColor,
          onPressed: () async {
            await PopupHelper.showCustomFormSheet<EmployeeModel?>(
              context: context,
              content: AddEmployeeModalBody(),
            );
          },
          child: Icon(Icons.person_add_alt_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Selector<AppProvider, int>(
          selector: (context, appProvider) => appProvider.selectedScreen,
          builder: (context, selectedIndex, child) {
            return AnimatedBottomNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              icons: [Icons.calendar_month_rounded, Icons.money],
              activeColor: Theme.of(context).primaryColor,
              borderColor: Theme.of(context).primaryColor,
              inactiveColor: kGreyColor,
              gapLocation: GapLocation.center,
              activeIndex: selectedIndex,
              onTap: (index) {
                try {
                  context.read<AppProvider>().updateSelectedScreen(index);
                } catch (e) {}
              },
            );
          },
        ),
      ),
    );
  }
}

Color getStatusColor(AttStatusEnums status) {
  switch (status) {
    case AttStatusEnums.present:
      return kGreenColor;
    case AttStatusEnums.absent:
      return kRedColor;
    case AttStatusEnums.latee:
      return kOrangeAccentColor;
  }
}

String getStatus(BuildContext context, AttStatusEnums status) {
  switch (status) {
    case AttStatusEnums.present:
      return AppLocalizations.of(context)!.h;
    case AttStatusEnums.absent:
      return AppLocalizations.of(context)!.gh;
    case AttStatusEnums.latee:
      return AppLocalizations.of(context)!.t;
  }
}
