import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/main_home_screen.dart';
import 'package:tetco_attendance/utils/popup_menu_option.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class EmployeeAttendanceCheckCard extends StatelessWidget {
  const EmployeeAttendanceCheckCard({
    super.key,
    required this.onTap,
    required this.avatarColor,
    required this.employee,
    required this.onPresent,
    required this.onAbsent,
    required this.onLate,
    required this.onDetails,
  });
  final EmployeeModel employee;
  final VoidCallback onTap;
  final Color avatarColor;
  final Function(EmployeeModel emp) onPresent;
  final Function(EmployeeModel emp) onAbsent;
  final Function(EmployeeModel emp) onLate;
  final Function(EmployeeModel emp) onDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (details) async {
        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
        final Offset tapPosition = details.globalPosition;

        // Convert global position to Overlay-relative coordinates
        final Offset localPosition = overlay.globalToLocal(tapPosition);
        await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            localPosition.dx,
            localPosition.dy,
            overlay.size.width - localPosition.dx,
            overlay.size.height - localPosition.dy,
          ),
          items: [
            popupMenuOpt<EmployeeModel>(
              context: context,

              icon: Icons.done_all_rounded,
              onTap: () {
                onPresent(employee);
              },
              title: AppLocalizations.of(context)!.present,
              value: AttStatusEnums.present.name,
              color: kGreenColor,
            ),
            popupMenuOpt<EmployeeModel>(
              context: context,

              icon: Icons.close,
              onTap: () {
                onAbsent(employee);
              },
              title: AppLocalizations.of(context)!.absent,
              value: AttStatusEnums.absent.name,
              color: kRedColor,
            ),
            popupMenuOpt<EmployeeModel>(
              context: context,

              icon: Icons.hourglass_bottom,
              onTap: () {
                onLate(employee);
              },
              title: AppLocalizations.of(context)!.late,
              value: AttStatusEnums.latee.name,
              color: kOrangeColor,
            ),
            popupMenuOpt<EmployeeModel>(
              context: context,

              icon: Icons.info_outline,
              onTap: () {
                onDetails(employee);
              },
              title: AppLocalizations.of(context)!.details,
              value: 'info',
              color: kBlueColor,
            ),
          ],
        );
      },
      child: Container(
        width: sizeConstants.cardStandardWidth,
        height: sizeConstants.cardStandardHeight,
        constraints: BoxConstraints(
          maxWidth: sizeConstants.cardStandardWidth,
          maxHeight: sizeConstants.cardStandardWidth,
        ),
        padding: EdgeInsets.fromLTRB(sizeConstants.spacing12, sizeConstants.spacing12, sizeConstants.spacing12, sizeConstants.spacing4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              offset: Offset(0, 3),
              blurRadius: 7,
              spreadRadius: .8,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: sizeConstants.avatarResponsive(context, 0.7),
                    height: sizeConstants.avatarResponsive(context, 0.7),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: avatarColor,
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        '${employee.name[0]}.${employee.fName[0]}',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                  if (employee.status != null)
                    Positioned(
                      bottom: -7,
                      right: 5,
                      child: Container(
                        width: sizeConstants.iconM,
                        height: sizeConstants.iconM,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Theme.of(context).scaffoldBackgroundColor),
                          color: getStatusColor(employee.status!),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          getStatus(context, employee.status!),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: sizeConstants.spacing12),
              Flexible(
                child: Text(
                  '${employee.name} ${employee.fName}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(height: 1.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
