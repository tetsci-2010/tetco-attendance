import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/models/project_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/provider/employee_provider.dart';
import 'package:tetco_attendance/features/data/providers/project_attendance_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/providers/project_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class ProjectRollCallScreen extends StatelessWidget {
  const ProjectRollCallScreen({super.key, this.projectId});

  static const String id = '/project_roll_call_screen';
  static const String name = 'project_roll_call_screen';

  final String? projectId;

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final selectedProject = _selectedProject(projects);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حاضری پروژه'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: selectedProject == null ? const _MissingProject() : _RollCallBody(project: selectedProject),
        ),
      ),
    );
  }

  ProjectModel? _selectedProject(List<ProjectModel> projects) {
    if (projects.isEmpty) return null;
    if (projectId == null) return projects.first;

    for (final project in projects) {
      if (project.id == projectId) return project;
    }
    return projects.first;
  }
}

class _RollCallBody extends StatelessWidget {
  const _RollCallBody({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<EmployeeProvider>().employees;
    final attendance = context.watch<ProjectAttendanceProvider>();
    final date = Jalali.now();
    final dateKey = '${date.year}-${date.month}-${date.day}';
    final assignedEmployees = employees.where((employee) => project.employeeIds.contains(employee.id)).toList();
    final completed = attendance.completedCount(
      projectId: project.id,
      dateKey: dateKey,
      employeeIds: project.employeeIds,
    );
    final completion = assignedEmployees.isEmpty ? 0.0 : completed / assignedEmployees.length;

    return ListView(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      children: [
        _ProjectRollHeader(
          project: project,
          date: '${date.day} ${_monthName(date.month)} ${date.year}'.toPersianDigit(),
          completed: completed,
          total: assignedEmployees.length,
          completion: completion,
        ),
        SizedBox(height: sizeConstants.spacing16),
        if (assignedEmployees.isEmpty)
          const _NoAssignedEmployees()
        else
          ...assignedEmployees.map(
            (employee) {
              final record = attendance.recordFor(
                projectId: project.id,
                employeeId: employee.id,
                dateKey: dateKey,
              );

              return Padding(
                padding: EdgeInsets.only(bottom: sizeConstants.spacing12),
                child: _RollEmployeeCard(
                  employee: employee,
                  selectedStatus: record?.status,
                  onStatusSelected: (status) {
                    context.read<ProjectAttendanceProvider>().markAttendance(
                      projectId: project.id,
                      employeeId: employee.id,
                      dateKey: dateKey,
                      status: status,
                    );
                  },
                ),
              );
            },
          ),
        SizedBox(height: sizeConstants.spacing16),
        _ProjectHistory(project: project, employees: employees),
      ],
    );
  }
}

class _ProjectRollHeader extends StatelessWidget {
  const _ProjectRollHeader({
    required this.project,
    required this.date,
    required this.completed,
    required this.total,
    required this.completion,
  });

  final ProjectModel project;
  final String date;
  final int completed;
  final int total;
  final double completion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sizeConstants.spacing4),
          Text(
            date,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kWhiteColor70),
          ),
          SizedBox(height: sizeConstants.spacing16),
          LinearProgressIndicator(
            value: completion,
            minHeight: 8.h,
            color: kWarningColor,
            backgroundColor: kWhiteColor.withAlpha(45),
          ),
          SizedBox(height: sizeConstants.spacing8),
          Text(
            '$completed از $total ثبت شده'.toPersianDigit(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: kWhiteColor70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RollEmployeeCard extends StatelessWidget {
  const _RollEmployeeCard({
    required this.employee,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  final EmployeeModel employee;
  final AttStatusEnums? selectedStatus;
  final ValueChanged<AttStatusEnums> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kPrimaryColor.withAlpha(24),
                child: Text(
                  _employeeInitials(employee),
                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: sizeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${employee.name} ${employee.fName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (employee.phone != null)
                      Text(
                        employee.phone!,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: kGreyColor600),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sizeConstants.spacing12),
          Row(
            children: [
              Expanded(
                child: _StatusButton(
                  label: AppLocalizations.of(context)!.present,
                  color: kGreenColor,
                  isSelected: selectedStatus == AttStatusEnums.present,
                  onTap: () => onStatusSelected(AttStatusEnums.present),
                ),
              ),
              SizedBox(width: sizeConstants.spacing8),
              Expanded(
                child: _StatusButton(
                  label: AppLocalizations.of(context)!.absent,
                  color: kRedColor,
                  isSelected: selectedStatus == AttStatusEnums.absent,
                  onTap: () => onStatusSelected(AttStatusEnums.absent),
                ),
              ),
              SizedBox(width: sizeConstants.spacing8),
              Expanded(
                child: _StatusButton(
                  label: AppLocalizations.of(context)!.late,
                  color: kOrangeColor,
                  isSelected: selectedStatus == AttStatusEnums.latee,
                  onTap: () => onStatusSelected(AttStatusEnums.latee),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
      onTap: onTap,
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: isSelected ? color : color.withAlpha(22),
          borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? kWhiteColor : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectHistory extends StatelessWidget {
  const _ProjectHistory({
    required this.project,
    required this.employees,
  });

  final ProjectModel project;
  final List<EmployeeModel> employees;

  @override
  Widget build(BuildContext context) {
    final records = context.watch<ProjectAttendanceProvider>().recordsForProject(project.id).take(6).toList();

    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آخرین تاریخچه پروژه',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sizeConstants.spacing12),
          if (records.isEmpty)
            Text(
              'هنوز حاضری برای این پروژه ثبت نشده است.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kGreyColor600),
            )
          else
            ...records.map((record) {
              final employee = _findEmployee(employees, record.employeeId);
              return Padding(
                padding: EdgeInsets.only(bottom: sizeConstants.spacing8),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded, color: _statusColor(record.status), size: sizeConstants.iconS),
                    SizedBox(width: sizeConstants.spacing8),
                    Expanded(
                      child: Text(
                        employee == null ? record.employeeId : '${employee.name} ${employee.fName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      _statusLabel(context, record.status),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _statusColor(record.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _NoAssignedEmployees extends StatelessWidget {
  const _NoAssignedEmployees();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      decoration: BoxDecoration(
        color: kWarningBgColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Text(
        'برای این پروژه هنوز کارمندی تخصیص نشده است. اول از صفحه پروژه‌ها کارمندان را اضافه کنید.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _MissingProject extends StatelessWidget {
  const _MissingProject();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'پروژه‌ای برای ثبت حاضری پیدا نشد.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

EmployeeModel? _findEmployee(List<EmployeeModel> employees, String employeeId) {
  for (final employee in employees) {
    if (employee.id == employeeId) return employee;
  }
  return null;
}

String _employeeInitials(EmployeeModel employee) {
  final first = employee.name.isNotEmpty ? employee.name[0] : '';
  final second = employee.fName.isNotEmpty ? employee.fName[0] : '';

  return '$first$second';
}

String _monthName(int month) {
  const monthNames = [
    '',
    'حمل',
    'ثور',
    'جوزا',
    'سرطان',
    'اسد',
    'سنبله',
    'میزان',
    'عقرب',
    'قوس',
    'جدی',
    'دلو',
    'حوت',
  ];

  return monthNames[month];
}

Color _statusColor(AttStatusEnums status) {
  switch (status) {
    case AttStatusEnums.present:
      return kGreenColor;
    case AttStatusEnums.absent:
      return kRedColor;
    case AttStatusEnums.latee:
      return kOrangeColor;
  }
}

String _statusLabel(BuildContext context, AttStatusEnums status) {
  switch (status) {
    case AttStatusEnums.present:
      return AppLocalizations.of(context)!.present;
    case AttStatusEnums.absent:
      return AppLocalizations.of(context)!.absent;
    case AttStatusEnums.latee:
      return AppLocalizations.of(context)!.late;
  }
}
