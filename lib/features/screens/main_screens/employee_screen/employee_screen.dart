import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_role.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/employee_bloc/employee_bloc.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_create_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/provider/employee_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/repository/local_iemployee_repository.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/repository/online_iemployee_repository.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/service/employee_service.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/models/project_model.dart';
import 'package:tetco_attendance/packages/toast_package/toast_package.dart';
import 'package:tetco_attendance/packages/uuid_package/uuid_package.dart';
import 'package:tetco_attendance/utils/popup_helper.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/custom_form_field.dart';
import 'package:tetco_attendance/widgets/custom_simple_appbar.dart';
import 'package:tetco_attendance/widgets/empty_screen_with_action.dart';

List<EmployeeModel> _employees = [
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
];

class EmployeeScreen extends StatelessWidget {
  static const String name = 'employee_screen';
  static const String id = '/employee_screen';
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmployeeProvider(),
      builder: (context, child) {
        return BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(
            EmployeeService(
              onlineEmployeeRepositoryImp: OnlineIEmployeeRepository.onlineEmployeeRepositoryImp,
              localEmployeeRepositoryImp: LocalIEmployeeRepository.localEmployeeRepositoryImp,
            ),
          )..add(FetchAllEmployees()),
          child: BlocConsumer<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is FetchAllEmployeesSuccess) {
                context.read<EmployeeProvider>().updateEmployees(state.employees);
              } else if (state is FetchAllEmployeesFailure) {
                ToastPackage.showSimpleToast(message: state.errorMessage);
              }
            },
            builder: (context, state) {
              return Consumer<EmployeeProvider>(
                builder: (context, employeeProvider, child) {
                  return Scaffold(
                    appBar: CustomSimpleAppbar(
                      title: Text('پرسونل'),
                      actions: [
                        IconButton(onPressed: () => _createEmployeeModal(context), icon: Icon(Icons.group_add_rounded)),
                        SizedBox(width: 10),
                      ],
                    ),
                    body: employeeProvider.employees.isEmpty && state is! FetchingAllEmployees
                        ? EmptyScreenWithAction(
                            iconData: Icons.group_add_rounded,
                            title: 'پرسونل جدید اضافه کنید',
                            description: 'برای مدیریت بهتر پروژه ها و دسترسی راحت و سریع به اطلاعات پرسونل/کارمندانتان اینجا اضافه کنید',
                            actionText: 'پرسونل جدید',
                            onCreate: () => _createEmployeeModal(context),
                          )
                        : Skeletonizer(
                            enabled: state is FetchingAllEmployees,
                            child: Column(
                              children: [
                                SizedBox(height: sizeConstants.spacing12),
                                _EmployeeOverview(employees: state is FetchingAllEmployees ? _employees : employeeProvider.employees),
                                SizedBox(height: sizeConstants.spacing12),
                                Expanded(
                                  child: ListView.separated(
                                    physics: Constants.bouncingScrollPhysics,
                                    itemBuilder: (context, index) => _EmployeeCard(
                                      employee: state is FetchingAllEmployees ? _employees[index] : employeeProvider.employees[index],
                                    ),
                                    separatorBuilder: (context, index) => Divider(height: 4, color: kTransparentColor),
                                    itemCount: state is FetchingAllEmployees ? _employees.length : employeeProvider.employees.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    floatingActionButton: FloatingActionButton.extended(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kWhiteColor,
                      onPressed: () => _createEmployeeModal(context),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('کارمند/پرسونل جدید'),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

_createEmployeeModal(BuildContext context) async {
  final done =
      await PopupHelper.showCustomFormSheet<bool>(
        context: context,
        content: CreateEmployeeModalBody(employeeBloc: context.read<EmployeeBloc>()),
      ) ??
      false;
}

class CreateEmployeeModalBody extends StatefulWidget {
  const CreateEmployeeModalBody({super.key, required this.employeeBloc});
  final EmployeeBloc employeeBloc;

  @override
  State<CreateEmployeeModalBody> createState() => _CreateEmployeeModalBodyState();
}

class _CreateEmployeeModalBodyState extends State<CreateEmployeeModalBody> {
  late GlobalKey<FormState> formKey;
  late TextEditingController nameController;
  late TextEditingController fatherNameController;
  late TextEditingController nickNameController;
  late TextEditingController phoneController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: 'امیر محسن');
    fatherNameController = TextEditingController(text: 'محمدداود');
    nickNameController = TextEditingController(text: 'زاهد');
    phoneController = TextEditingController(text: '0797627651');
    descController = TextEditingController(text: 'سلام دنیا من خوشحالم');
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    nameController.dispose();
    fatherNameController.dispose();
    nickNameController.dispose();
    phoneController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.employeeBloc,
      child: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is AddEmployeeSuccess) {
            ToastPackage.showSimpleToast(message: 'کارمند موفقانه ایجاد شد');
            nameController.clear();
            fatherNameController.clear();
            nickNameController.clear();
            phoneController.clear();
            descController.clear();
            widget.employeeBloc.add(FetchAllEmployees());
          } else if (state is AddEmployeeFailure) {
            ToastPackage.showSimpleToast(message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return Column(
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
                              controller: nameController,
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
                              controller: fatherNameController,
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
                              controller: nickNameController,
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
                              controller: phoneController,
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
                              controller: descController,
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
                    CustomTextButton(
                      onPressed: () {
                        context.pop(false);
                      },
                      child: Text('لغو'),
                      bgColor: kRedColor,
                    ),
                    SizedBox(width: sizeConstants.spacing8),
                    CustomTextButton(
                      loading: state is AddingEmployee,
                      onPressed: () {
                        try {
                          if (formKey.currentState?.validate() == true) {
                            final name = nameController.text.trim();
                            final fName = fatherNameController.text.trim();
                            final nickName = nickNameController.text.trim();
                            final phone = phoneController.text.trim();
                            final desc = descController.text.trim();
                            EmployeeCreateModel employeeCreateModel = EmployeeCreateModel(
                              id: UuidPackage.generateNumber(),
                              name: name,
                              fName: fName,
                              roleId: 1,
                              description: desc,
                              nickName: nickName,
                              phone: phone,
                            );

                            context.read<EmployeeBloc>().add(CreateEmployee(employeeModel: employeeCreateModel));
                          }
                        } catch (e) {}
                      },
                      child: Text('ثبت'),
                      bgColor: kGreenColor,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
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
