import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/features/screens/main_screens/attendance_screen/data/notifiers/attendance_notifiers.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/models/project_model.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/custom_simple_appbar.dart';

List<ProjectModel> _projects = [
  ProjectModel(id: '1', name: 'بادمرغان'),
  ProjectModel(id: '5', name: 'درب ملک، ساختمان دندان پزشکی'),
  ProjectModel(id: '2', name: 'شیدایی'),
  ProjectModel(id: '3', name: 'پل پشتو'),
  ProjectModel(id: '6', name: 'پنج راهی آب بخش'),
  ProjectModel(id: '7', name: 'مستوفیت، شفاخانه'),
  ProjectModel(id: '8', name: 'کلینیک زیبایی، مطب داکتر رضایی'),
];

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  static const String id = '/attendance_screen';
  static const String name = 'attendance';

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late ScrollController scrollController;
  final Jalali _today = Jalali.now();
  late Jalali _visibleMonth = Jalali(_today.year, _today.month);
  late Jalali _selectedDay = _today;

  @override
  void initState() {
    super.initState();
    AttendanceNotifiers.showAppbarTitle = ValueNotifier(true);
    scrollController = ScrollController();
    scrollController.addListener(() {
      final show = scrollController.offset <= 100;

      if (AttendanceNotifiers.showAppbarTitle.value != show) {
        AttendanceNotifiers.showAppbarTitle.value = show;
      }
    });
  }

  static const List<String> _weekDays = [
    'ش',
    'ی',
    'د',
    'س',
    'چ',
    'پ',
    'ج',
  ];

  static const List<String> _monthNames = [
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

  void _goToPreviousMonth() {
    setState(() {
      _visibleMonth = _shiftMonth(_visibleMonth, -1);
      _selectedDay = Jalali(_visibleMonth.year, _visibleMonth.month, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _visibleMonth = _shiftMonth(_visibleMonth, 1);
      _selectedDay = Jalali(_visibleMonth.year, _visibleMonth.month, 1);
    });
  }

  void _goToToday() {
    setState(() {
      _visibleMonth = Jalali(_today.year, _today.month);
      _selectedDay = _today;
    });
  }

  Jalali _shiftMonth(Jalali month, int amount) {
    final totalMonths = (month.year * 12) + (month.month - 1) + amount;
    return Jalali(totalMonths ~/ 12, (totalMonths % 12) + 1);
  }

  bool _isSameDay(Jalali first, Jalali second) {
    return first.year == second.year && first.month == second.month && first.day == second.day;
  }

  bool _isSameMonth(Jalali first, Jalali second) {
    return first.year == second.year && first.month == second.month;
  }

  String _formatJalali(Jalali date) {
    return '${date.day} ${_monthNames[date.month]} ${date.year}'.toPersianDigit();
  }

  String _formatGregorian(Jalali date) {
    final gregorian = intl.DateFormat('d/MMMM/yyyy').format(date.toDateTime());
    return gregorian.toPersianDigit();
  }

  List<_CalendarDay> _monthDays() {
    final firstDayOffset = Jalali(_visibleMonth.year, _visibleMonth.month, 1).weekDay - JalaliExt.saturday;
    final currentMonthLength = _visibleMonth.monthLength;
    final previousMonth = _shiftMonth(_visibleMonth, -1);
    final previousMonthLength = previousMonth.monthLength;
    final days = <_CalendarDay>[];

    for (var index = 0; index < 42; index++) {
      final dayNumber = index - firstDayOffset + 1;

      if (dayNumber < 1) {
        days.add(
          _CalendarDay(
            date: Jalali(
              previousMonth.year,
              previousMonth.month,
              previousMonthLength + dayNumber,
            ),
            isInVisibleMonth: false,
          ),
        );
        continue;
      }

      if (dayNumber > currentMonthLength) {
        final nextMonth = _shiftMonth(_visibleMonth, 1);
        days.add(
          _CalendarDay(
            date: Jalali(
              nextMonth.year,
              nextMonth.month,
              dayNumber - currentMonthLength,
            ),
            isInVisibleMonth: false,
          ),
        );
        continue;
      }

      days.add(
        _CalendarDay(
          date: Jalali(_visibleMonth.year, _visibleMonth.month, dayNumber),
          isInVisibleMonth: true,
        ),
      );
    }

    return days;
  }

  @override
  void dispose() {
    scrollController.dispose();
    AttendanceNotifiers.disposeShowAppbarTitle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomSimpleAppbar(
        title: ValueListenableBuilder(
          valueListenable: AttendanceNotifiers.showAppbarTitle,
          builder: (context, showTitle, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: showTitle ? Text(key: ValueKey('roll'), 'ثبت حاضری') : Text(key: ValueKey('today'), _formatJalali(_selectedDay)),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'امروز',
            onPressed: _goToToday,
            icon: const Icon(Icons.today_rounded),
          ),
          IconButton(
            tooltip: 'ثبت حاضری',
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
          SizedBox(width: sizeConstants.spacing8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          physics: Constants.bouncingScrollPhysics,
          padding: EdgeInsets.all(sizeConstants.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CalendarHeader(
                visibleMonth: _visibleMonth,
                monthName: _monthNames[_visibleMonth.month],
                onPrevious: _goToPreviousMonth,
                onNext: _goToNextMonth,
                gregorianDate: _formatGregorian(_selectedDay),
              ),
              SizedBox(height: sizeConstants.spacing16),
              _CalendarGrid(
                days: _monthDays(),
                selectedDay: _selectedDay,
                today: _today,
                weekDays: _weekDays,
                isSameDay: _isSameDay,
                onDaySelected: (day) {
                  setState(() {
                    _selectedDay = day;
                  });
                },
              ),
              // SizedBox(height: sizeConstants.spacing16),
              // _SelectedDayPanel(
              //   selectedDay: _selectedDay,
              //   isToday: _isSameDay(_selectedDay, _today),
              //   jalaliDate: _formatJalali(_selectedDay),
              //   gregorianDate: _formatGregorian(_selectedDay),
              //   visibleMonthName: _monthNames[_selectedDay.month],
              //   isCurrentMonth: _isSameMonth(_selectedDay, _visibleMonth),
              // ),
              SizedBox(height: sizeConstants.spacing16),
              SizedBox(
                width: getMediaQueryWidth(context),
                height: 27.w,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: Constants.bouncingScrollPhysics,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _ProjectChipWidget(name: 'همه پروژه ها', selected: true, index: index);
                    }
                    return _ProjectChipWidget(name: _projects[index - 1].name, index: index - 1);
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 5),
                  itemCount: _projects.length + 1,
                ),
              ),
              SizedBox(height: sizeConstants.spacing16),
              SizedBox(
                height: getMediaQueryHeight(context, 0.7),
                child: ListView.separated(
                  physics: Constants.bouncingScrollPhysics,
                  itemBuilder: (context, index) {
                    return _EmployeeRow(employeeName: 'امیر محسن', nickName: 'زاهد');
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 4);
                  },
                  itemCount: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmployeeRow extends StatelessWidget {
  const _EmployeeRow({super.key, required this.employeeName, this.nickName});
  final String employeeName;
  final String? nickName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMediaQueryWidth(context, 0.9),
      height: sizeConstants.spacing48,
      color: kTransparentColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: sizeConstants.spacing40,
                  height: sizeConstants.spacing40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(sizeConstants.radiusMax), color: kRedColor),
                ),
                SizedBox(width: sizeConstants.spacing8),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      text: '$employeeName',
                      children: [
                        TextSpan(
                          text: '${nickName == null ? "" : ' - '}',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kGreyColor),
                          children: [
                            TextSpan(
                              text: '${nickName ?? ''}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kGreyColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.check_circle_outline_outlined, color: kGreenColor),
              ),
              SizedBox(width: sizeConstants.spacing8),
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.clear_circled, color: kRedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectChipWidget extends StatelessWidget {
  const _ProjectChipWidget({
    super.key,
    this.onTap,
    required this.name,
    this.selected = false,
    required this.index,
  });

  final VoidCallback? onTap;
  final String name;
  final bool selected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor.withAlpha(30) : kTransparentColor,
          borderRadius: BorderRadius.circular(sizeConstants.radiusSmall),
          border: Border.all(color: selected ? Theme.of(context).primaryColor : kGreyColor),
        ),
        child: Text(name, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: selected ? Theme.of(context).primaryColor : kGreyColor)),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.visibleMonth,
    required this.monthName,
    required this.onPrevious,
    required this.onNext,
    required this.gregorianDate,
  });

  final Jalali visibleMonth;
  final String monthName;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String gregorianDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing16, vertical: sizeConstants.spacing12),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Row(
        children: [
          _RoundIconButton(
            icon: Icons.chevron_left_rounded,
            tooltip: 'ماه قبل',
            onPressed: onPrevious,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  monthName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: kWhiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: sizeConstants.spacing4),
                Text(
                  visibleMonth.year.toString().toPersianDigit(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kWhiteColor70,
                  ),
                ),
                Text(
                  gregorianDate.toPersianDigit(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: kWhiteColor70,
                  ),
                ),
              ],
            ),
          ),
          _RoundIconButton(
            icon: Icons.chevron_right_rounded,
            tooltip: 'ماه بعد',
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.days,
    required this.selectedDay,
    required this.today,
    required this.weekDays,
    required this.isSameDay,
    required this.onDaySelected,
  });

  final List<_CalendarDay> days;
  final Jalali selectedDay;
  final Jalali today;
  final List<String> weekDays;
  final bool Function(Jalali first, Jalali second) isSameDay;
  final ValueChanged<Jalali> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: weekDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  weekDays[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: index == 6 ? kRedColor : kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: sizeConstants.spacing8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day.isInVisibleMonth && isSameDay(day.date, selectedDay);
              final isToday = day.isInVisibleMonth && isSameDay(day.date, today);
              final isWeekend = day.date.weekDay == JalaliExt.friday;

              return _CalendarDayCell(
                day: day,
                isSelected: isSelected,
                isToday: isToday,
                isWeekend: isWeekend,
                onTap: day.isInVisibleMonth ? () => onDaySelected(day.date) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isWeekend,
    required this.onTap,
  });

  final _CalendarDay day;
  final bool isSelected;
  final bool isToday;
  final bool isWeekend;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !day.isInVisibleMonth;
    final textColor = isSelected
        ? kWhiteColor
        : isDisabled
        ? Theme.of(context).disabledColor
        : isWeekend
        ? kRedColor
        : Theme.of(context).textTheme.bodyMedium?.color;

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryColor
                : isToday
                ? kSecondaryColor.withAlpha(35)
                : kTransparentColor,
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
            border: Border.all(
              color: isToday && !isSelected ? kSecondaryColor : kTransparentColor,
            ),
          ),
          child: Center(
            child: Text(
              day.date.day.toString().toPersianDigit(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedDayPanel extends StatelessWidget {
  const _SelectedDayPanel({
    required this.selectedDay,
    required this.isToday,
    required this.jalaliDate,
    required this.gregorianDate,
    required this.visibleMonthName,
    required this.isCurrentMonth,
  });

  final Jalali selectedDay;
  final bool isToday;
  final String jalaliDate;
  final String gregorianDate;
  final String visibleMonthName;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sizeConstants.spacing16),
      decoration: BoxDecoration(
        color: kSecondaryColor.withAlpha(25),
        borderRadius: BorderRadius.circular(sizeConstants.radiusLarge),
        border: Border.all(color: kSecondaryColor.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
                ),
                child: Center(
                  child: Text(
                    selectedDay.day.toString().toPersianDigit(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: kWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: sizeConstants.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isToday ? 'امروز' : jalaliDate,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: sizeConstants.spacing4),
                    Text(
                      gregorianDate,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: kGreyColor600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sizeConstants.spacing16),
          Wrap(
            spacing: sizeConstants.spacing8,
            runSpacing: sizeConstants.spacing8,
            children: [
              _InfoChip(
                icon: Icons.calendar_month_rounded,
                label: visibleMonthName,
              ),
              _InfoChip(
                icon: Icons.check_circle_outline_rounded,
                label: isCurrentMonth ? 'قابل انتخاب' : 'خارج از ماه',
              ),
              const _InfoChip(
                icon: Icons.event_note_rounded,
                label: 'رویدادی ثبت نشده',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConstants.spacing12,
        vertical: sizeConstants.spacing8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: sizeConstants.iconS, color: kPrimaryColor),
          SizedBox(width: sizeConstants.spacing4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: kWhiteColor.withAlpha(30),
          foregroundColor: kWhiteColor,
        ),
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class _CalendarDay {
  const _CalendarDay({
    required this.date,
    required this.isInVisibleMonth,
  });

  final Jalali date;
  final bool isInVisibleMonth;
}
