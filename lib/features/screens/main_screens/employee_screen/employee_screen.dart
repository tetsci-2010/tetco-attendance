import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_role.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/provider/employee_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/models/project_model.dart';
import 'package:tetco_attendance/utils/popup_helper.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/custom_form_field.dart';
import 'package:tetco_attendance/widgets/custom_simple_appbar.dart';
import 'package:tetco_attendance/widgets/empty_screen_with_action.dart';

class EmployeeScreen extends StatelessWidget {
  static const String name = 'employee_screen';
  static const String id = '/employee_screen';
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var personnel = context.watch<EmployeeProvider>();
    List<EmployeeModel> employees = personnel.employees;
    employees = [
      EmployeeModel(
        id: '1',
        name: 'امیر محسن',
        fName: 'محمدداود',
        role: EmployeeRole(id: 1, role: 'کارگر ساده'),
        status: AttStatusEnums.present,
        nickName: 'زاهد',
        phone: '07316871272',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
          ProjectModel(id: '2', name: 'شیدایی'),
          ProjectModel(id: '3', name: 'پل پشتو'),
          ProjectModel(id: '4', name: 'پنج راهی آب بخش'),
        ],
      ),
      EmployeeModel(
        id: '2',
        name: 'محمدرضا',
        fName: 'سلطان علی',
        role: EmployeeRole(id: 2, role: 'سرکارگر'),
        status: AttStatusEnums.present,
        nickName: 'اکبری',
        phone: '07812631923',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
          ProjectModel(id: '3', name: 'پل پشتو'),
          ProjectModel(id: '4', name: 'پنج راهی آب بخش'),
        ],
      ),
      EmployeeModel(
        id: '3',
        name: 'علی اکبر',
        fName: 'احمد',
        role: EmployeeRole(id: 3, role: 'چفتی'),
        status: AttStatusEnums.absent,
        nickName: 'محمدی',
        phone: '0738172371',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
          ProjectModel(id: '4', name: 'پنج راهی آب بخش'),
        ],
      ),
      EmployeeModel(
        id: '4',
        name: 'صادق',
        fName: 'محمدرضا',
        role: EmployeeRole(id: 1, role: 'کارگر ساده'),
        status: AttStatusEnums.absent,
        nickName: 'رضایی',
        phone: '079187318123',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
          ProjectModel(id: '2', name: 'شیدایی'),
          ProjectModel(id: '3', name: 'پل پشتو'),
          ProjectModel(id: '4', name: 'پنج راهی آب بخش'),
        ],
      ),
      EmployeeModel(
        id: '5',
        name: 'سجاد',
        fName: 'علی محمد',
        role: EmployeeRole(id: 1, role: 'کارگر ساده'),
        status: AttStatusEnums.present,
        nickName: 'حسینی',
        phone: '077137613821',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
        ],
      ),
      EmployeeModel(
        id: '6',
        name: 'محمد',
        fName: 'اسدالله',
        role: EmployeeRole(id: 6, role: 'برقکار'),
        status: AttStatusEnums.present,
        nickName: 'کبیر',
        phone: '07986317812',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
          ProjectModel(id: '2', name: 'شیدایی'),
          ProjectModel(id: '3', name: 'پل پشتو'),
        ],
      ),
      EmployeeModel(
        id: '7',
        name: 'میر آقا',
        fName: 'شیرعلی',
        role: EmployeeRole(id: 7, role: 'شاگرد برقکار'),
        status: AttStatusEnums.present,
        nickName: 'محمدی',
        phone: '079837872197',
        projects: [
          ProjectModel(id: '1', name: 'بادمرغان'),
          ProjectModel(id: '2', name: 'شیدایی'),
          ProjectModel(id: '3', name: 'پل پشتو'),
          ProjectModel(id: '4', name: 'پنج راهی آب بخش'),
        ],
      ),
    ];

    return Scaffold(
      appBar: CustomSimpleAppbar(
        title: Text('پرسونل'),
        actions: [
          IconButton(onPressed: () => _createEmployeeModal(context), icon: Icon(Icons.group_add_rounded)),
          SizedBox(width: 10),
        ],
      ),
      body: employees.isEmpty
          ? EmptyScreenWithAction(
              iconData: Icons.group_add_rounded,
              title: 'پرسونل جدید اضافه کنید',
              description: 'برای مدیریت بهتر پروژه ها و دسترسی راحت و سریع به اطلاعات پرسونل/کارمندانتان اینجا اضافه کنید',
              actionText: 'پرسونل جدید',
              onCreate: () => _createEmployeeModal(context),
            )
          : Column(
              children: [
                SizedBox(height: sizeConstants.spacing12),
                _EmployeeOverview(
                  employees: employees,
                ),
                SizedBox(height: sizeConstants.spacing12),
                Expanded(
                  child: ListView.separated(
                    physics: Constants.bouncingScrollPhysics,
                    itemBuilder: (context, index) => _EmployeeCard(employee: employees[index]),
                    separatorBuilder: (context, index) => Divider(height: 4, color: kTransparentColor),
                    itemCount: employees.length,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
        onPressed: () => _createEmployeeModal(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('کارمند/پرسونل جدید'),
      ),
    );
  }
}

_createEmployeeModal(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final nickNameController = TextEditingController();
  final phoneController = TextEditingController();
  final descController = TextEditingController();

  final done =
      await PopupHelper.showCustomFormSheet<bool>(
        context: context,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('پرسونل/کارمند جدید', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: sizeConstants.spacing12),
            Flexible(
              child: SingleChildScrollView(
                physics: Constants.bouncingScrollPhysics,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: nameController,
                        builder: (context, nameCont, child) {
                          return CustomTextFormField(
                            labelText: 'نام',
                            hintText: 'نام پرسونل را وارد کنید',
                            isRequired: true,
                            onClearTap: () {
                              try {
                                nameController.clear();
                              } catch (e) {}
                            },
                            showClearBtn: nameCont.text.isNotEmpty,
                            prefixIcon: Icons.person_2_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.requiredField;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                      ValueListenableBuilder(
                        valueListenable: fatherNameController,
                        builder: (context, fNameCont, child) {
                          return CustomTextFormField(
                            labelText: 'نام پدر',
                            hintText: 'نام پدر را وارد کنید',
                            isRequired: true,
                            onClearTap: () {
                              try {
                                fatherNameController.clear();
                              } catch (e) {}
                            },
                            showClearBtn: fNameCont.text.isNotEmpty,
                            prefixIcon: Icons.person_2_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.requiredField;
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                      ValueListenableBuilder(
                        valueListenable: nickNameController,
                        builder: (context, nickNameCont, child) {
                          return CustomTextFormField(
                            labelText: 'تخلص',
                            hintText: 'تخلص را وارد کنید',
                            onClearTap: () {
                              try {
                                nickNameController.clear();
                              } catch (e) {}
                            },
                            showClearBtn: nickNameCont.text.isNotEmpty,
                            prefixIcon: Icons.person_2_rounded,
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                      ValueListenableBuilder(
                        valueListenable: phoneController,
                        builder: (context, phoneCont, child) {
                          return CustomTextFormField(
                            labelText: 'شماره تماس',
                            hintText: 'شماره تماس را وارد کنید',
                            textInputType: TextInputType.phone,
                            onClearTap: () {
                              try {
                                phoneController.clear();
                              } catch (e) {}
                            },
                            showClearBtn: phoneCont.text.isNotEmpty,
                            prefixIcon: Icons.phone,
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                      ValueListenableBuilder(
                        valueListenable: descController,
                        builder: (context, descCont, child) {
                          return CustomTextFormField(
                            labelText: 'توضیحات',
                            hintText: 'توضیحات را وارد کنید',
                            isDescription: true,
                            onClearTap: () {
                              try {
                                descController.clear();
                              } catch (e) {}
                            },
                            showClearBtn: descCont.text.isNotEmpty,
                            prefixIcon: Icons.description_rounded,
                          );
                        },
                      ),
                      SizedBox(height: sizeConstants.spacing12),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: sizeConstants.spacing12),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: sizeConstants.spacing16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextButton(onPressed: () {}, child: Text('لغو'), bgColor: kRedColor),
                  SizedBox(width: sizeConstants.spacing8),
                  CustomTextButton(
                    onPressed: () {
                      try {
                        formKey.currentState?.validate();
                      } catch (e) {}
                    },
                    child: Text('ثبت'),
                    bgColor: kGreenColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ) ??
      false;
  if (done) {
    nameController.dispose();
    fatherNameController.dispose();
    nickNameController.dispose();
    descController.dispose();
    phoneController.dispose();
  }
}

class _EmployeeOverview extends StatelessWidget {
  const _EmployeeOverview({required this.employees});

  final List<EmployeeModel> employees;

  @override
  Widget build(BuildContext context) {
    // final active = employees.where((project) => project.isActive).length;
    // final assignedEmployees = employees.expand((project) => project.employeeIds).toSet().length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
      child: Row(
        children: [
          Expanded(
            child: _OverviewTile(
              icon: Icons.people_alt_rounded,
              value: employees.length.toString(),
              label: 'کل پرسونل',
              color: Theme.of(context).primaryColor,
              onTap: () {},
            ),
          ),
          SizedBox(width: sizeConstants.spacing12),
          Expanded(
            child: _OverviewTile(
              icon: Icons.playlist_add_check_circle,
              value: employees.where((element) => element.status == AttStatusEnums.present).toList().length.toString(),
              label: 'فعال',
              color: kGreenColor,
            ),
          ),
          SizedBox(width: sizeConstants.spacing12),
          Expanded(
            child: _OverviewTile(
              icon: Icons.person_off_rounded,
              value: employees.where((element) => element.status == AttStatusEnums.absent).toList().length.toString(),
              label: 'غیر فعال',
              color: kRedColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    this.onTap,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sizeConstants.spacing12),
        decoration: BoxDecoration(
          color: color.withAlpha(24),
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            SizedBox(height: sizeConstants.spacing8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: kGreyColor600),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({super.key, required this.employee});
  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: kBlackColor.withAlpha(15),
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
                      color: Colors.pink,
                    ),
                    child: Icon(Icons.person_4_rounded, color: kWhiteColor),
                  ),
                  SizedBox(width: sizeConstants.spacing12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(employee.name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                          Text(' - '),
                          Text('«${employee.nickName ?? '--'}»', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kGreyColor600)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            employee.fName,
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: kGreyColor, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone, color: kGreenColor, size: 10),
                              SizedBox(width: 3),
                              Text(
                                employee.phone ?? '--',
                                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: kGreyColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.query_stats_outlined, size: 12, color: Colors.pink),
                      SizedBox(width: 5),
                      Text('وضعیت فعلی:', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Text(
                    _getStatus(employee.status?.name),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: _getStatusColor(employee.status?.name)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, size: 12, color: Colors.pink),
                      SizedBox(width: 5),
                      Text('وظیفه:', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Text(employee.role.role, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: _getStatusColor(employee.status?.name))),
                ],
              ),
            ],
          ),
          SizedBox(height: sizeConstants.spacing8),
          Divider(height: 1),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(
                employee.projects?.length ?? 0,
                (index) => Padding(
                  padding: EdgeInsets.only(left: sizeConstants.spacing8),
                  child: Chip(
                    side: BorderSide(color: _getStatusColor(employee.status?.name).withAlpha(100)),
                    color: WidgetStatePropertyAll(_getStatusColor(employee.status?.name).withAlpha(15)),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.location_on,
                          size: sizeConstants.iconS,
                          color: kRedColor,
                        ),
                        SizedBox(width: sizeConstants.spacing2),
                        Text(employee.projects?[index].name ?? '--'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_getStatus(String? status) {
  if (status == AttStatusEnums.absent.name) {
    return 'غیر حاضر';
  } else if (status == AttStatusEnums.present.name) {
    return 'حاضر';
  } else if (status == AttStatusEnums.latee.name) {
    return 'تاخیر';
  } else {
    return status;
  }
}

_getStatusColor(String? status) {
  if (status == AttStatusEnums.absent.name) {
    return kRedColor;
  } else if (status == AttStatusEnums.present.name) {
    return kGreenColor;
  } else if (status == AttStatusEnums.latee.name) {
    return kOrangeAccentColor;
  } else {
    return kGreyColor;
  }
}
