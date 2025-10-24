import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/widgets/employee_attendance_check_card.dart';
import 'package:tetco_attendance/packages/searchfield_package/searchfield_package.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/random_color.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_screen';
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<AppProvider>().populateEmployees();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* Date
        Selector<AppProvider, bool>(
          selector: (context, appProvider) => appProvider.isSearchingEmp,
          builder: (context, isSearching, child) {
            return isSearching
                ? SearchfieldPackage<EmployeeModel>(
                    suggestions: [],
                    hint: AppLocalizations.of(context)!.search,
                    onSearchTextChanged: (value) {
                      try {} catch (e) {}
                    },
                    onCloseTap: () {
                      try {
                        context.read<AppProvider>().toggleIsSearchingEmp();
                      } catch (_) {}
                    },
                  )
                : Container(
                    width: getMediaQueryWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_rounded)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_back_ios_new_rounded, size: sizeConstants.iconS),
                            ),
                            SizedBox(width: sizeConstants.spacing4),
                            Text('چهار شنبه، ۳۰ میزان ۱۴۰۴'),
                            SizedBox(width: sizeConstants.spacing4),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_rounded, size: sizeConstants.iconS),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<AppProvider>().toggleIsSearchingEmp();
                          },
                          icon: Icon(Icons.search_rounded),
                        ),
                      ],
                    ),
                  );
          },
        ),
        //* Body
        Expanded(
          child: Selector<AppProvider, List<EmployeeModel>>(
            selector: (context, appProvider) => appProvider.employees,
            builder: (context, employees, child) {
              return MasonryGridView.builder(
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                padding: EdgeInsets.all(sizeConstants.spacing16),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  return EmployeeAttendanceCheckCard(
                    employee: employees[index],
                    avatarColor: employees[index].imageHolderColor ?? randomVibrantColorWithAlpha(),
                    onTap: () {},
                    onPresent: (emp) {},
                    onAbsent: (emp) {},
                    onDetails: (emp) {},
                    onLate: (emp) {},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
