import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

List<EmployeeModel> employees = [];

class MainHomeScreen extends StatelessWidget {
  static const String id = '/main_home_screen';
  static const String name = 'main_home_screen';
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //* Appbar
            Container(
              padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing4),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      size: sizeConstants.iconL,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_active_rounded,
                      color: kOrangeColor,
                      size: sizeConstants.iconL,
                    ),
                  ),
                ],
              ),
            ),
            //* Date
            Container(
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
                  IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
                ],
              ),
            ),
            //* Body
            Expanded(
              child: MasonryGridView.builder(
                gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                padding: EdgeInsets.all(sizeConstants.spacing16),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: 40,
                itemBuilder: (context, index) {
                  return EmployeeAttendanceCheckCard(
                    name: 'بهرام',
                    lName: 'افشار',
                    avatarColor: kRedColor.withAlpha(35),
                    onTap: () {},
                    status: AttStatusEnums.absent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(1000)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: kWhiteColor,
        onPressed: () {},
        child: Icon(Icons.person_add_alt_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: [Icons.calendar_today, Icons.money],
        activeColor: Theme.of(context).primaryColor,
        borderColor: Theme.of(context).primaryColor,
        inactiveColor: kGreyColor,
        gapLocation: GapLocation.center,
        activeIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

class EmployeeAttendanceCheckCard extends StatelessWidget {
  const EmployeeAttendanceCheckCard({
    super.key,
    required this.name,
    required this.lName,
    required this.status,
    required this.onTap,
    required this.avatarColor,
  });
  final String name;
  final String lName;
  final AttStatusEnums status;
  final VoidCallback onTap;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeConstants.cardStandardWidth,
      height: sizeConstants.cardStandardHeight,
      constraints: BoxConstraints(
        maxWidth: sizeConstants.cardStandardWidth,
        maxHeight: sizeConstants.cardStandardWidth,
      ),
      padding: EdgeInsets.all(sizeConstants.spacing12),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kRedColor.withAlpha(40),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${name[0]}.${lName[0]}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Positioned(
                  bottom: -7,
                  right: 5,
                  child: Container(
                    width: sizeConstants.iconM,
                    height: sizeConstants.iconM,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Theme.of(context).scaffoldBackgroundColor),
                      color: getStatusColor(status),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getStatus(context, status),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhiteColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeConstants.spacing16),
            Flexible(child: Text('بهرام افشار', style: Theme.of(context).textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }
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

class EmployeeAttendCard extends StatelessWidget {
  const EmployeeAttendCard({
    super.key,
    required this.name,
    required this.fName,
    this.phone,
    this.image,
    required this.index,
  });
  final String name;
  final String fName;
  final String? phone;
  final String? image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMediaQueryWidth(context, 0.9),
      margin: EdgeInsets.fromLTRB(
        sizeConstants.spacing16,
        index == 0 ? sizeConstants.spacing16 : 0,
        sizeConstants.spacing16,
        index == employees.length - 1 ? sizeConstants.spacing16 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
        color: Theme.of(context).cardColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing12, vertical: sizeConstants.spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(image ?? ImagesPaths.demoProfileJpg),
                  radius: sizeConstants.iconMedium,
                ),
                SizedBox(width: sizeConstants.spacing8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, overflow: TextOverflow.ellipsis),
                      Text(fName, overflow: TextOverflow.ellipsis),
                      if (phone != null) Text(phone!, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {},
                child: Icon(Icons.check_circle_outline_rounded, color: kGreenColor),
              ),
              SizedBox(width: sizeConstants.spacing8),
              InkWell(
                onTap: () {},
                child: Icon(Icons.edit_note_rounded, color: kBlueColor),
              ),
              SizedBox(width: sizeConstants.spacing8),
              InkWell(
                onTap: () {},
                child: Icon(Icons.clear, color: kRedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
