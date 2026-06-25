import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/features/screens/main_screens/attendance_screen/provider/attendance_provider.dart';
import 'package:tetco_attendance/helpers/helpers.dart';
import 'package:tetco_attendance/packages/syncfusion_datagrid_package/syncfusion_datagrid_package.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/widgets/buttons/retry_button.dart';
import 'package:tetco_attendance/widgets/custom_loading_indicator.dart';
import 'package:tetco_attendance/widgets/custom_simple_appbar.dart';
import 'package:tetco_attendance/widgets/footer_total_rows_widget.dart';

// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});
//   static const String id = '/attendance_screen';
//   static const String name = 'attendance';

//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   late DataGridController _dataGridController;
//   late DataPagerController _pagerController;

//   @override
//   void initState() {
//     _dataGridController = DataGridController();
//     _pagerController = DataPagerController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _dataGridController.dispose();
//     _pagerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => AttendanceProvider(),
//       child: Consumer<AttendanceProvider>(
//         builder: (context, attendanceProvider, child) {
//           return Scaffold(
//             appBar: CustomSimpleAppbar(title: Text('لیست حاضری'), centerTitle: true),
//             body: SafeArea(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(top: 5),
//                       width: getMediaQueryWidth(context),
//                       height: getMediaQueryHeight(context),
//                       child: _buildStack(
//                         isLoading: true,
//                         attendanceProvider: attendanceProvider,
//                         onRefresh: () {
//                           try {} catch (_) {}
//                         },
//                         onCellTap: (details) {},
//                         employees: [],
//                       ),
//                     ),
//                   ),
//                   if (true)
//                     SfDataPager(
//                       delegate: AttendanceDataGridSource(context, attendanceProvider.employees, () {}, 0),
//                       pageCount: 0,
//                       initialPageIndex: 0,
//                       availableRowsPerPage: Constants.perPages,
//                       visibleItemsCount: 4,
//                       controller: _pagerController,
//                       onRowsPerPageChanged: (value) {
//                         // try {
//                         //   if (value != null) {
//                         //     final rowsPerPage = attendanceProvider.rowsPerPage;
//                         //     final pageCount = attendanceProvider.pageCount;
//                         //     if (rowsPerPage + 1 > pageCount) {
//                         //       PurchaseBloc.page = 1;
//                         //     }
//                         //     context.read<PurchaseBloc>().add(
//                         //       FetchPurchases(page: PurchaseBloc.page, hideLoading: true, perPage: value),
//                         //     );
//                         //     context.read<attendanceProvider>().updateRowsPerPage(value);
//                         //   }
//                         // } catch (_) {}
//                       },
//                       onPageNavigationEnd: (pageIndex) {
//                         try {
//                           // context.read<PurchaseBloc>().add(FetchPurchases(page: pageIndex + 1, hideLoading: true, perPage: attendanceProvider.rowsPerPage));
//                           // PurchaseBloc.page = pageIndex + 1;
//                         } catch (_) {}
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStack({
//     required Function() onRefresh,
//     required List<EmployeeModel> employees,
//     required bool isLoading,
//     required AttendanceProvider attendanceProvider,
//     Function(DataGridCellTapDetails details)? onCellTap,
//   }) {
//     if (employees.isEmpty) {
//       return RetryIcon(
//         message: 'تلاش دوباره',
//         onRetry: () {
//           try {} catch (_) {}
//         },
//       );
//     }
//     return Stack(
//       children: [
//         SyncfusionDatagridPackage.syncfusionDataGrid(
//           controller: _dataGridController,
//           dataGridSource: AttendanceDataGridSource(context, employees, onRefresh, 0),
//           rowsPerPage: 0,
//           allowPullToRefresh: true,
//           onCellTap: onCellTap,
//           onColumnResizeUpdate: (details) {
//             return true;
//           },
//           allowColumnsResizing: true,
//           columns: _getColumns(),
//           footer: FooterTotalRowsWidget(totalRows: attendanceProvider.totalRows),
//           headerGridLinesVisibility: GridLinesVisibility.both,
//         ),
//         if (isLoading) Positioned.fill(child: CustomLoadingIndicator()),
//       ],
//     );
//   }

//   List<GridColumn> _getColumns() {
//     final headerStyle = Theme.of(context).textTheme.titleSmall!.copyWith(color: kWhiteColor);
//     final textAlign = TextAlign.center;
//     return [
//       GridColumn(
//         columnWidthMode: ColumnWidthMode.auto,
//         columnName: 'id',
//         maximumWidth: _idCWidth,
//         label: Container(
//           color: Theme.of(context).primaryColor,
//           alignment: Alignment.center,
//           child: Text('#', style: headerStyle, textAlign: textAlign),
//         ),
//       ),
//       GridColumn(
//         columnWidthMode: ColumnWidthMode.fill,
//         columnName: 'description',
//         maximumWidth: _descriptionCWidth,
//         label: Container(
//           color: Theme.of(context).primaryColor,
//           alignment: Alignment.center,
//           child: Text('توضیحات', style: headerStyle, textAlign: textAlign),
//         ),
//       ),
//       GridColumn(
//         columnWidthMode: ColumnWidthMode.auto,
//         columnName: 'cost',
//         maximumWidth: _costCWidth,
//         label: Container(
//           color: Theme.of(context).primaryColor,
//           alignment: Alignment.center,
//           child: Text('قیمت', style: headerStyle, textAlign: textAlign),
//         ),
//       ),
//     ];
//   }
// }

// class AttendanceDataGridSource extends DataGridSource {
//   AttendanceDataGridSource(this.context, this.purchases, this.onRefresh, this.perPage) {
//     buildPaginatedDataGridRows();
//   }

//   List<EmployeeModel> purchases;
//   List<DataGridRow> _paginatedRows = [];
//   BuildContext context;
//   Function() onRefresh;
//   int perPage;
//   @override
//   Future<void> handleRefresh() {
//     onRefresh();
//     return super.handleRefresh();
//   }

//   @override
//   List<DataGridRow> get rows => _paginatedRows;

//   void buildPaginatedDataGridRows({int startIndex = 0, int? rowsPerPage}) {
//     final paginatedEmployees = purchases.skip(startIndex).take(rowsPerPage ?? perPage);
//     int index = 0;
//     _paginatedRows = paginatedEmployees.map<DataGridRow>(
//       (employee) {
//         index++;
//         return DataGridRow(
//           cells: [
//             DataGridCell(columnName: 'id', value: index),
//             DataGridCell(columnName: 'description', value: employee.description),
//             DataGridCell(columnName: 'cost', value: ''),
//           ],
//         );
//       },
//     ).toList();

//     notifyListeners();
//   }

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       cells: row.getCells().map((cell) {
//         return Container(
//           alignment: cell.columnName == 'description' ? AlignmentDirectional.centerStart : Alignment.center,
//           padding: const EdgeInsets.all(5),
//           child: Text(
//             cell.value.toString(),
//             style: Theme.of(context).textTheme.bodySmall,
//             textDirection: cell.columnName == 'cost' ? TextDirection.ltr : null,
//           ),
//         );
//       }).toList(),
//     );
//   }

//   @override
//   Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
//     int startIndex = newPageIndex * 10;
//     buildPaginatedDataGridRows(startIndex: startIndex, rowsPerPage: perPage);
//     return true;
//   }
// }

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});
  static const String id = '/attendance_screen';
  static const String name = 'attendance';

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class PersianCalendarPage extends StatefulWidget {
  const PersianCalendarPage({super.key});
  static const String id = '/test_screen';
  static const String name = 'test';

  @override
  State<PersianCalendarPage> createState() => _PersianCalendarPageState();
}

class _PersianCalendarPageState extends State<PersianCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _isInFocusedMonth(DateTime day) {
    return day.year == _focusedDay.year && day.month == _focusedDay.month;
  }

  final List<String> weekDays = [
    'ش',
    'ی',
    'د',
    'س',
    'چ',
    'پ',
    'ج',
  ];

  final List<String> monthNames = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppbar(title: Text('تقویم حضور و غیاب'), centerTitle: true),

      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2035),
            focusedDay: _focusedDay,
            enabledDayPredicate: _isInFocusedMonth,

            selectedDayPredicate: (day) {
              return _isInFocusedMonth(day) && isSameDay(_selectedDay, day);
            },
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              isTodayHighlighted: true,
            ),
            sixWeekMonthsEnforced: false,

            onDaySelected: (selectedDay, focusedDay) {
              if (!_isInFocusedMonth(selectedDay)) return;

              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },

            headerStyle: HeaderStyle(
              headerMargin: EdgeInsets.all(10),
              formatButtonVisible: false,
              titleCentered: true,

              titleTextFormatter: (date, locale) {
                final jalali = Jalali.fromDateTime(date);

                final monthName = monthNames[jalali.month];

                return '$monthName '
                        '${jalali.year}'
                    .toString()
                    .toPersianDigit();
              },
            ),

            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                return Center(
                  child: Text(
                    weekDays[day.weekday % 7],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },

              defaultBuilder: (context, day, focusedDay) {
                final jalali = Jalali.fromDateTime(day);

                return Center(
                  child: Text(
                    jalali.day.toString().toPersianDigit(),
                  ),
                );
              },

              disabledBuilder: (context, day, focusedDay) {
                final jalali = Jalali.fromDateTime(day);

                return Center(
                  child: Text(
                    jalali.day.toString().toPersianDigit(),
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                );
              },

              outsideBuilder: (context, day, focusedDay) {
                final jalali = Jalali.fromDateTime(day);

                return Center(
                  child: Text(
                    jalali.day.toString().toPersianDigit(),
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                );
              },

              todayBuilder: (context, day, focusedDay) {
                final jalali = Jalali.fromDateTime(day);

                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Center(
                    child: Text(
                      jalali.day.toString().toPersianDigit(),

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },

              selectedBuilder: (context, day, focusedDay) {
                final jalali = Jalali.fromDateTime(day);

                return Container(
                  margin: const EdgeInsets.all(6),

                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Center(
                    child: Text(
                      jalali.day.toString().toPersianDigit(),

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          if (_selectedDay != null)
            Builder(
              builder: (_) {
                final jalali = Jalali.fromDateTime(
                  _selectedDay!,
                );

                return Text(
                  'تاریخ انتخاب شده: '
                          '${jalali.year}'
                          '/'
                          '${jalali.month}'
                          '/'
                          '${jalali.day}'
                      .toPersianDigit(),

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
