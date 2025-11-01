import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/providers/app_provider.dart';
import 'package:tetco_attendance/features/data/providers/employee_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/widgets/employee_attendance_check_card.dart';
import 'package:tetco_attendance/packages/flutter_datetime_picker_plus_package/flutter_datetime_picker_plus_package.dart';
import 'package:tetco_attendance/packages/searchfield_package/searchfield_package.dart';
import 'package:tetco_attendance/utils/date_helper.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/popup_menu_option.dart';
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
  late TextEditingController searchController;
  late GlobalKey _menuKey;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _menuKey = GlobalKey();
    try {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<EmployeeProvider>().populateEmployees();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    searchController.dispose();
    _menuKey.currentState?.dispose();
    super.dispose();
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
                    controller: searchController,
                    hint: AppLocalizations.of(context)!.search,
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
                        Selector<AppProvider, AttStatusEnums?>(
                          selector: (context, appProvider) => appProvider.sStatusFilter,
                          builder: (context, statusFilter, child) {
                            return IconButton(
                              key: _menuKey,
                              color: statusFilter != null ? kOrangeAccentColor : null,
                              onPressed: () async {
                                final RenderBox button = _menuKey.currentContext!.findRenderObject() as RenderBox;
                                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                                // Get the position and size of the button
                                final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
                                final Size buttonSize = button.size;

                                // Build position relative to overlay
                                final RelativeRect position = RelativeRect.fromRect(
                                  Rect.fromLTWH(
                                    buttonPosition.dx,
                                    buttonPosition.dy + buttonSize.height, // appear below button
                                    buttonSize.width,
                                    buttonSize.height,
                                  ),
                                  Offset.zero & overlay.size,
                                );
                                try {
                                  await showMenu(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    context: context,
                                    position: position,
                                    items: [
                                      popupMenuOpt(
                                        context: context,
                                        icon: Icons.done_all_rounded,
                                        title: AppLocalizations.of(context)!.present,
                                        isSelected: statusFilter == AttStatusEnums.present,
                                        onTap: () {
                                          try {
                                            if (statusFilter == AttStatusEnums.present) {
                                              context.read<AppProvider>().resetFilter();
                                            } else {
                                              context.read<AppProvider>().updateSelectedStatus(AttStatusEnums.present);
                                            }
                                          } catch (e) {}
                                        },
                                        value: AttStatusEnums.present.name,
                                        color: kGreenColor,
                                      ),
                                      popupMenuOpt(
                                        context: context,
                                        icon: Icons.close,
                                        isSelected: statusFilter == AttStatusEnums.absent,
                                        title: AppLocalizations.of(context)!.absent,
                                        onTap: () {
                                          try {
                                            if (statusFilter == AttStatusEnums.absent) {
                                              context.read<AppProvider>().resetFilter();
                                            } else {
                                              context.read<AppProvider>().updateSelectedStatus(AttStatusEnums.absent);
                                            }
                                          } catch (e) {}
                                        },
                                        value: AttStatusEnums.absent.name,
                                        color: kRedColor,
                                      ),
                                      popupMenuOpt(
                                        context: context,
                                        icon: Icons.hourglass_bottom_rounded,
                                        title: AppLocalizations.of(context)!.late,
                                        isSelected: statusFilter == AttStatusEnums.latee,
                                        onTap: () {
                                          try {
                                            if (statusFilter == AttStatusEnums.latee) {
                                              context.read<AppProvider>().resetFilter();
                                            } else {
                                              context.read<AppProvider>().updateSelectedStatus(AttStatusEnums.latee);
                                            }
                                          } catch (e) {}
                                        },
                                        value: AttStatusEnums.latee.name,
                                        color: kOrangeColor,
                                      ),
                                    ],
                                  );
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              icon: Icon(Icons.filter_alt_rounded),
                            );
                          },
                        ),
                        Selector<AppProvider, Jalali?>(
                          selector: (context, appProvider) => appProvider.pickedDate,
                          builder: (context, pDate, child) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (pDate != null) {
                                      context.read<AppProvider>().updatePickedDate(DateHelper.nextDay(pDate));
                                    }
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: sizeConstants.iconS),
                                ),
                                SizedBox(width: sizeConstants.spacing4),
                                GestureDetector(
                                  onTap: () async {
                                    try {
                                      Jalali? picked = await FlutterDatetimePickerPlusPackage.showAfghanDatePicker(context: context);
                                      if (picked != null) {
                                        context.read<AppProvider>().updatePickedDate(picked);
                                      }
                                    } catch (e) {}
                                  },
                                  child: Text(DateHelper.formatJalaliDate(pDate)),
                                ),
                                SizedBox(width: sizeConstants.spacing4),
                                IconButton(
                                  onPressed: () {
                                    if (pDate != null) {
                                      context.read<AppProvider>().updatePickedDate(DateHelper.previousDay(pDate));
                                    }
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_rounded, size: sizeConstants.iconS),
                                ),
                              ],
                            );
                          },
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
          child: Selector<AppProvider, AttStatusEnums?>(
            selector: (context, appProvider) => appProvider.sStatusFilter,
            builder: (context, statusFilter, child) {
              return ValueListenableBuilder(
                valueListenable: searchController,
                builder: (context, searchCont, child) {
                  return Selector<EmployeeProvider, List<EmployeeModel>>(
                    selector: (context, appProvider) => appProvider.employees,
                    builder: (context, employees, child) {
                      List<EmployeeModel> emps = employees;
                      if (searchCont.text.isNotEmpty) {
                        emps = employees.where((employee) {
                          return employee.name.contains(searchCont.text.trim()) ||
                              employee.fName.contains(searchCont.text.trim()) ||
                              ('${employee.name} ${employee.fName}').contains(searchCont.text.trim()) ||
                              ('${employee.name}${employee.fName}').contains(searchCont.text.trim());
                        }).toList();
                        if (statusFilter != null) {
                          emps = emps.where((element) => element.status == statusFilter).toList();
                        }
                      } else {
                        emps = employees;
                        if (statusFilter != null) {
                          emps = emps.where((element) => element.status == statusFilter).toList();
                        }
                      }
                      return MasonryGridView.builder(
                        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        padding: EdgeInsets.all(sizeConstants.spacing16),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemCount: emps.length,
                        itemBuilder: (context, index) {
                          return EmployeeAttendanceCheckCard(
                            employee: emps[index],
                            avatarColor: emps[index].imageHolderColor ?? randomVibrantColorWithAlpha(),
                            onTap: () {},
                            onPresent: (emp) {
                              try {
                                emp = emp.copyWith(status: AttStatusEnums.present);
                                List<EmployeeModel> list = context.read<EmployeeProvider>().employees;
                                list.removeWhere((element) => element.id == emp.id);
                                list.insert(0, emp);
                                context.read<EmployeeProvider>().updateEmployees(list);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            onAbsent: (emp) {},
                            onDetails: (emp) {},
                            onLate: (emp) {},
                          );
                        },
                      );
                    },
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
