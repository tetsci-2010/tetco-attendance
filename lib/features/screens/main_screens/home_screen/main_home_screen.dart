import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/provider/employee_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/providers/project_provider.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/persian_calendar_screen/persian_calendar_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/employee_screen.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/projects_screen.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

enum _HomePeriod { daily, weekly, monthly, annual }

class MainHomeScreen extends StatefulWidget {
  static const String id = '/main_home_screen';
  static const String name = 'main_home_screen';
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  _HomePeriod _selectedPeriod = _HomePeriod.daily;

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<EmployeeProvider>().employees;
    final projectProvider = context.watch<ProjectProvider>();
    final summary = _AttendanceSummary.fromEmployees(employees);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 92.h,
          titleSpacing: sizeConstants.spacing16,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(ImagesPaths.demoProfileJpg),
                radius: sizeConstants.avatarSmall,
              ),
              SizedBox(width: sizeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'سلام، خوش آمدید',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kWhiteColor70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: sizeConstants.spacing4),
                    Text(
                      'داشبورد حضور و غیاب',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: sizeConstants.spacing12),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    tooltip: 'اعلان‌ها',
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active_rounded),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      width: 9.w,
                      height: 9.w,
                      decoration: const BoxDecoration(
                        color: kWarningColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            physics: Constants.bouncingScrollPhysics,
            padding: EdgeInsets.all(sizeConstants.spacing16),
            children: [
              _PeriodSelector(
                selectedPeriod: _selectedPeriod,
                onChanged: (period) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
              ),
              SizedBox(height: sizeConstants.spacing16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: switch (_selectedPeriod) {
                  _HomePeriod.daily => _DailyDashboard(
                    key: const ValueKey(_HomePeriod.daily),
                    summary: summary,
                    employees: employees,
                    activeProjectCount: projectProvider.activeProjectCount,
                    assignedEmployeeCount: projectProvider.assignedEmployeeCount,
                  ),
                  _HomePeriod.weekly => _PeriodOverview(
                    key: const ValueKey(_HomePeriod.weekly),
                    title: 'گزارش هفته',
                    subtitle: 'روند حضور، غیابت و تاخیرهای این هفته',
                    icon: Icons.view_week_rounded,
                    summary: summary,
                  ),
                  _HomePeriod.monthly => _PeriodOverview(
                    key: const ValueKey(_HomePeriod.monthly),
                    title: 'گزارش ماه',
                    subtitle: 'جمع‌بندی کارکرد، روزهای ناقص و عملکرد تیم',
                    icon: Icons.calendar_month_rounded,
                    summary: summary,
                  ),
                  _HomePeriod.annual => _PeriodOverview(
                    key: const ValueKey(_HomePeriod.annual),
                    title: 'گزارش سال',
                    subtitle: 'نمای کلی حضور و غیاب در تمام سال',
                    icon: Icons.insights_rounded,
                    summary: summary,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onChanged,
  });

  final _HomePeriod selectedPeriod;
  final ValueChanged<_HomePeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = [
      _PeriodOption(_HomePeriod.daily, 'روزانه', Icons.today_rounded),
      _PeriodOption(_HomePeriod.weekly, 'هفتگی', Icons.view_week_rounded),
      _PeriodOption(_HomePeriod.monthly, 'ماهانه', Icons.calendar_month_rounded),
      _PeriodOption(_HomePeriod.annual, 'سالانه', Icons.bar_chart_rounded),
    ];

    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedPeriod == option.period;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing2),
              child: InkWell(
                borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                onTap: () => onChanged(option.period),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 54.h,
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor : kTransparentColor,
                    borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        option.icon,
                        size: sizeConstants.iconS,
                        color: isSelected ? kWhiteColor : kPrimaryColor,
                      ),
                      SizedBox(height: sizeConstants.spacing4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          option.label,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isSelected ? kWhiteColor : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DailyDashboard extends StatelessWidget {
  const _DailyDashboard({
    super.key,
    required this.summary,
    required this.employees,
    required this.activeProjectCount,
    required this.assignedEmployeeCount,
  });

  final _AttendanceSummary summary;
  final List<EmployeeModel> employees;
  final int activeProjectCount;
  final int assignedEmployeeCount;

  @override
  Widget build(BuildContext context) {
    final today = Jalali.now();
    final actionEmployees = employees
        .where(
          (employee) => employee.status == null || employee.status == AttStatusEnums.absent || employee.status == AttStatusEnums.latee,
        )
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TodayCard(
          date: '${today.day} ${_monthName(today.month)} ${today.year}'.toPersianDigit(),
          completion: summary.completionRate,
        ),
        SizedBox(height: sizeConstants.spacing16),
        _SummaryGrid(summary: summary),
        SizedBox(height: sizeConstants.spacing16),
        _ProjectStatusCard(
          activeProjectCount: activeProjectCount,
          assignedEmployeeCount: assignedEmployeeCount,
        ),
        SizedBox(height: sizeConstants.spacing16),
        _AddEmployeeCard(totalEmployees: 0),
        SizedBox(height: sizeConstants.spacing16),
        _QuickActions(),
        SizedBox(height: sizeConstants.spacing16),
        _AttentionList(employees: actionEmployees),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.date,
    required this.completion,
  });

  final String date;
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sizeConstants.spacing12),
                decoration: BoxDecoration(
                  color: kWhiteColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                ),
                child: const Icon(Icons.wb_sunny_rounded, color: kWhiteColor),
              ),
              SizedBox(width: sizeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وضعیت امروز',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: kWhiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: sizeConstants.spacing4),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kWhiteColor70,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(completion * 100).round()}٪'.toPersianDigit(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sizeConstants.spacing16),
          ClipRRect(
            borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
            child: LinearProgressIndicator(
              minHeight: 8.h,
              value: completion,
              color: kWarningColor,
              backgroundColor: kWhiteColor.withAlpha(45),
            ),
          ),
          SizedBox(height: sizeConstants.spacing8),
          Text(
            'تکمیل حاضری روزانه',
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final _AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryItem('حاضر', summary.present, Icons.check_circle_rounded, kGreenColor),
      _SummaryItem('غایب', summary.absent, Icons.cancel_rounded, kRedColor),
      _SummaryItem('تاخیر', summary.late, Icons.schedule_rounded, kOrangeColor),
      _SummaryItem('ثبت نشده', summary.pending, Icons.pending_actions_rounded, kSecondaryColor),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.85,
        crossAxisSpacing: sizeConstants.spacing12,
        mainAxisSpacing: sizeConstants.spacing12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          padding: EdgeInsets.all(sizeConstants.spacing12),
          decoration: BoxDecoration(
            color: item.color.withAlpha(24),
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            border: Border.all(color: item.color.withAlpha(70)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(sizeConstants.spacing8),
                decoration: BoxDecoration(
                  color: item.color.withAlpha(35),
                  borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                ),
                child: Icon(item.icon, color: item.color, size: sizeConstants.iconM),
              ),
              SizedBox(width: sizeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.value.toString().toPersianDigit(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: sizeConstants.spacing2),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: kGreyColor600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProjectStatusCard extends StatelessWidget {
  const _ProjectStatusCard({
    required this.activeProjectCount,
    required this.assignedEmployeeCount,
  });

  final int activeProjectCount;
  final int assignedEmployeeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      onTap: () {
        context.push(ProjectsScreen.id);
      },
      child: Container(
        padding: EdgeInsets.all(sizeConstants.spacing16),
        decoration: BoxDecoration(
          color: kSecondaryColor.withAlpha(24),
          borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
          border: Border.all(color: kSecondaryColor.withAlpha(70)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(sizeConstants.spacing12),
              decoration: BoxDecoration(
                color: kSecondaryColor.withAlpha(35),
                borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
              ),
              child: Icon(Icons.business_center_rounded, color: kSecondaryColor),
            ),
            SizedBox(width: sizeConstants.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'پروژه‌های فعال',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: sizeConstants.spacing4),
                  Text(
                    '$activeProjectCount پروژه، $assignedEmployeeCount کارمند تخصیص شده'.toPersianDigit(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: kGreyColor600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_left_rounded, color: kSecondaryColor),
          ],
        ),
      ),
    );
  }
}

class _AddEmployeeCard extends StatelessWidget {
  const _AddEmployeeCard({
    required this.totalEmployees,
  });

  final int totalEmployees;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      onTap: () {
        context.push(EmployeeScreen.id);
      },
      child: Container(
        padding: EdgeInsets.all(sizeConstants.spacing16),
        decoration: BoxDecoration(
          color: kSecondaryColor.withAlpha(24),
          borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
          border: Border.all(color: kSecondaryColor.withAlpha(70)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(sizeConstants.spacing12),
              decoration: BoxDecoration(
                color: kSecondaryColor.withAlpha(35),
                borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
              ),
              child: Icon(Icons.groups_2_rounded, color: kSecondaryColor),
            ),
            SizedBox(width: sizeConstants.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تعداد کل پرسونل',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: sizeConstants.spacing4),
                  Text(
                    '$totalEmployees پرسونل',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: kGreyColor600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_left_rounded, color: kSecondaryColor),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.assignment_turned_in_rounded,
            title: 'ثبت حاضری',
            subtitle: 'لیست روزانه',
            onTap: () {
              context.push(PersianCalendarScreen.id);
            },
          ),
        ),
        SizedBox(width: sizeConstants.spacing12),
        Expanded(
          child: _ActionTile(
            icon: Icons.calendar_month_rounded,
            title: 'تقویم',
            subtitle: 'نمای ماه',
            onTap: () {
              context.push(PersianCalendarScreen.id);
            },
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sizeConstants.spacing12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(icon, color: kPrimaryColor, size: sizeConstants.iconM),
            SizedBox(width: sizeConstants.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: sizeConstants.spacing2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: kGreyColor600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttentionList extends StatelessWidget {
  const _AttentionList({required this.employees});

  final List<EmployeeModel> employees;

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.priority_high_rounded, color: kOrangeColor),
              SizedBox(width: sizeConstants.spacing8),
              Text(
                'نیازمند بررسی',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: sizeConstants.spacing12),
          if (employees.isEmpty)
            Text(
              'برای امروز موردی برای بررسی وجود ندارد.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kGreyColor600),
            )
          else
            ...employees.map((employee) {
              final statusColor = employee.status == null ? kSecondaryColor : getStatusColor(employee.status!);
              final statusText = employee.status == null ? 'ثبت نشده' : getStatus(context, employee.status!);

              return Padding(
                padding: EdgeInsets.only(bottom: sizeConstants.spacing8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: statusColor.withAlpha(35),
                      child: Text(
                        _employeeInitials(employee),
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: sizeConstants.spacing8),
                    Expanded(
                      child: Text(
                        '${employee.name} ${employee.fName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConstants.spacing8,
                        vertical: sizeConstants.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(28),
                        borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
                      ),
                      child: Text(
                        statusText,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
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

class _PeriodOverview extends StatelessWidget {
  const _PeriodOverview({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.summary,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final _AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kPrimaryColor, size: sizeConstants.iconL),
          SizedBox(height: sizeConstants.spacing12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sizeConstants.spacing4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kGreyColor600),
          ),
          SizedBox(height: sizeConstants.spacing16),
          _SummaryGrid(summary: summary),
          SizedBox(height: sizeConstants.spacing16),
          Text(
            'در قدم بعدی این بخش می‌تواند نمودار روند، بهترین روزها، افراد پرتاخیر و خروجی گزارش داشته باشد.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PeriodOption {
  const _PeriodOption(this.period, this.label, this.icon);

  final _HomePeriod period;
  final String label;
  final IconData icon;
}

class _SummaryItem {
  const _SummaryItem(this.label, this.value, this.icon, this.color);

  final String label;
  final int value;
  final IconData icon;
  final Color color;
}

class _AttendanceSummary {
  const _AttendanceSummary({
    required this.total,
    required this.present,
    required this.absent,
    required this.late,
  });

  final int total;
  final int present;
  final int absent;
  final int late;

  int get pending => total - present - absent - late;

  double get completionRate {
    if (total == 0) return 0;
    return (present + absent + late) / total;
  }

  factory _AttendanceSummary.fromEmployees(List<EmployeeModel> employees) {
    return _AttendanceSummary(
      total: employees.length,
      present: employees.where((employee) => employee.status == AttStatusEnums.present).length,
      absent: employees.where((employee) => employee.status == AttStatusEnums.absent).length,
      late: employees.where((employee) => employee.status == AttStatusEnums.latee).length,
    );
  }
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

String _employeeInitials(EmployeeModel employee) {
  final first = employee.name.isNotEmpty ? employee.name[0] : '';
  final second = employee.fName.isNotEmpty ? employee.fName[0] : '';

  return '$first$second';
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
