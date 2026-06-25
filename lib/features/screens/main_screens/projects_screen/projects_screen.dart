import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/models/project_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/provider/employee_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/providers/project_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/project_roll_call_screen/project_roll_call_screen.dart';
import 'package:tetco_attendance/utils/popup_helper.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/buttons/filled_btn_with_icon.dart';
import 'package:tetco_attendance/widgets/custom_form_field.dart';
import 'package:tetco_attendance/widgets/custom_simple_appbar.dart';
import 'package:tetco_attendance/widgets/empty_screen_with_action.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  static const String id = '/projects_screen';
  static const String name = 'projects_screen';

  @override
  Widget build(BuildContext context) {
    var projects = context.watch<ProjectProvider>().projects;
    final employees = context.watch<EmployeeProvider>().employees;
    projects = [ProjectModel(id: '0', name: 'پروژه هرات')];

    return Scaffold(
      appBar: CustomSimpleAppbar(
        title: Text('پروژه ها'),
        actions: [
          IconButton(
            onPressed: () {
              _showProjectSheet(context);
            },
            icon: Icon(Icons.add_business_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        foregroundColor: kWhiteColor,
        onPressed: () => _showProjectSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('پروژه جدید'),
      ),
      body: SafeArea(
        child: projects.isEmpty
            ? EmptyScreenWithAction(
                onCreate: () => _showProjectSheet(context),
                description: 'بعد از ایجاد پروژه، می‌توانید کارمندان را به آن تخصیص دهید و بعدا حاضری را بر اساس پروژه ثبت کنید.',
                title: 'پروژه جدید بسازید',
                actionText: 'ایجاد پروژه',
              )
            : ListView(
                padding: EdgeInsets.all(sizeConstants.spacing16),
                children: [
                  _ProjectsOverview(projects: projects),
                  SizedBox(height: sizeConstants.spacing16),
                  ...projects.map(
                    (project) => Padding(
                      padding: EdgeInsets.only(bottom: sizeConstants.spacing12),
                      child: _ProjectCard(
                        project: project,
                        employees: employees,
                        onAssign: () => _showAssignmentSheet(
                          context: context,
                          project: project,
                          employees: employees,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
      ),
    );
  }

  void _showAssignmentSheet({
    required BuildContext context,
    required ProjectModel project,
    required List<EmployeeModel> employees,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.72,
            minChildSize: 0.42,
            maxChildSize: 0.92,
            builder: (context, controller) {
              return Consumer<ProjectProvider>(
                builder: (context, projectProvider, child) {
                  final currentProject = projectProvider.projects.firstWhere(
                    (item) => item.id == project.id,
                    orElse: () => project,
                  );

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(sizeConstants.spacing16),
                        child: Row(
                          children: [
                            Icon(Icons.groups_rounded, color: kPrimaryColor),
                            SizedBox(width: sizeConstants.spacing8),
                            Expanded(
                              child: Text(
                                'کارمندان ${currentProject.name}',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: employees.isEmpty
                            ? Center(
                                child: Text(
                                  'هنوز کارمندی ثبت نشده است.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kGreyColor600),
                                ),
                              )
                            : ListView.builder(
                                controller: controller,
                                itemCount: employees.length,
                                itemBuilder: (context, index) {
                                  final employee = employees[index];
                                  final isAssigned = currentProject.employeeIds.contains(employee.id);

                                  return CheckboxListTile(
                                    value: isAssigned,
                                    activeColor: kPrimaryColor,
                                    secondary: CircleAvatar(
                                      backgroundColor: kPrimaryColor.withAlpha(24),
                                      child: Text(
                                        _employeeInitials(employee),
                                        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text('${employee.name} ${employee.fName}'),
                                    subtitle: Text(employee.phone ?? 'بدون شماره تماس'),
                                    onChanged: (_) {
                                      projectProvider.toggleEmployeeAssignment(
                                        projectId: currentProject.id,
                                        employeeId: employee.id,
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
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

class _ProjectsOverview extends StatelessWidget {
  const _ProjectsOverview({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    final active = projects.where((project) => project.isActive).length;
    final assignedEmployees = projects.expand((project) => project.employeeIds).toSet().length;

    return Row(
      children: [
        Expanded(
          child: _OverviewTile(
            icon: Icons.business_center_rounded,
            value: projects.length.toString(),
            label: 'کل پروژه‌ها',
            color: kPrimaryColor,
          ),
        ),
        SizedBox(width: sizeConstants.spacing12),
        Expanded(
          child: _OverviewTile(
            icon: Icons.check_circle_rounded,
            value: active.toString(),
            label: 'فعال',
            color: kGreenColor,
          ),
        ),
        SizedBox(width: sizeConstants.spacing12),
        Expanded(
          child: _OverviewTile(
            icon: Icons.groups_rounded,
            value: assignedEmployees.toString(),
            label: 'کارمند',
            color: kOrangeColor,
          ),
        ),
      ],
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.employees,
    required this.onAssign,
  });

  final ProjectModel project;
  final List<EmployeeModel> employees;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final assignedNames = employees.where((employee) => project.employeeIds.contains(employee.id)).take(3).map((employee) => employee.name).join('، ');

    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sizeConstants.spacing12),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                ),
                child: Icon(Icons.business_rounded, color: kPrimaryColor),
              ),
              SizedBox(width: sizeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: sizeConstants.spacing4),
                    Text(
                      project.location ?? 'موقعیت ثبت نشده',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: kGreyColor600),
                    ),
                  ],
                ),
              ),
              Switch(
                value: project.isActive,
                activeColor: kPrimaryColor,
                onChanged: (_) {
                  context.read<ProjectProvider>().toggleProjectStatus(project.id);
                },
              ),
            ],
          ),
          SizedBox(height: sizeConstants.spacing12),
          Wrap(
            spacing: sizeConstants.spacing8,
            runSpacing: sizeConstants.spacing8,
            children: [
              _ProjectChip(
                icon: Icons.groups_rounded,
                label: '${project.employeeCount} کارمند',
              ),
              _ProjectChip(
                icon: Icons.person_rounded,
                label: project.supervisor ?? 'بدون مسئول',
              ),
              _ProjectChip(
                icon: project.isActive ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                label: project.isActive ? 'فعال' : 'غیرفعال',
              ),
            ],
          ),
          if (assignedNames.isNotEmpty) ...[
            SizedBox(height: sizeConstants.spacing12),
            Text(
              assignedNames,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kGreyColor600),
            ),
          ],
          SizedBox(height: sizeConstants.spacing12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAssign,
                  icon: const Icon(Icons.group_add_rounded),
                  label: const Text('تخصیص کارمند'),
                ),
              ),
              SizedBox(width: sizeConstants.spacing8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: project.employeeIds.isEmpty
                      ? null
                      : () {
                          context.push(ProjectRollCallScreen.id, extra: project.id);
                        },
                  icon: const Icon(Icons.how_to_reg_rounded),
                  label: const Text('ثبت حاضری'),
                ),
              ),
              SizedBox(width: sizeConstants.spacing8),
              IconButton(
                tooltip: 'حذف پروژه',
                color: kRedColor,
                onPressed: () {
                  context.read<ProjectProvider>().removeProject(project.id);
                },
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectChip extends StatelessWidget {
  const _ProjectChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConstants.spacing8,
        vertical: sizeConstants.spacing4,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withAlpha(18),
        borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: sizeConstants.iconS, color: kPrimaryColor),
          SizedBox(width: sizeConstants.spacing4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

String _employeeInitials(EmployeeModel employee) {
  final first = employee.name.isNotEmpty ? employee.name[0] : '';
  final second = employee.fName.isNotEmpty ? employee.fName[0] : '';

  return '$first$second';
}

Future<void> _showProjectSheet(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final supervisorController = TextEditingController();
  final descriptionController = TextEditingController();
  final done =
      await PopupHelper.showCustomFormSheet<bool>(
        context: context,
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: sizeConstants.spacing8),
              Text('پروژه جدید', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: sizeConstants.spacing12),
              Flexible(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextFormField(
                          isRequired: true,
                          labelText: 'نام پروژه',
                          hintText: 'نام پروژه را وارد کنید',
                          prefixIcon: Icons.business_center_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.requiredField;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: sizeConstants.spacing16),
                        CustomTextFormField(
                          labelText: 'سرپرست',
                          hintText: 'نام سرپرست پروژه را وارد کنید',
                          prefixIcon: Icons.supervised_user_circle,
                        ),
                        SizedBox(height: sizeConstants.spacing16),
                        CustomTextFormField(
                          labelText: 'موقعیت/آدرس',
                          hintText: 'موقعیت و یا آدرس پروژه را وارد کنید',
                          prefixIcon: Icons.location_on,
                        ),

                        SizedBox(height: sizeConstants.spacing16),
                        CustomTextFormField(
                          labelText: 'توضیحات',
                          hintText: 'در صورت نیاز توضیحات اضافه کنید',
                          prefixIcon: Icons.description,
                          isDescription: true,
                        ),
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
        ),
      ) ??
      false;
  if (done) {
    nameController.dispose();
    locationController.dispose();
    supervisorController.dispose();
    descriptionController.dispose();
  }
}
