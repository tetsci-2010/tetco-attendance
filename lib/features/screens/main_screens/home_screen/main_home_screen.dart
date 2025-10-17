import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/constants/constants.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/constants/l10n/app_l10n.dart';
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
      appBar: AppBar(
        toolbarHeight: 80.h,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CircleAvatar(
                backgroundImage: AssetImage(ImagesPaths.demoProfileJpg),
                radius: sizeConstants.iconMedium,
              ),
            ),
            SizedBox(width: sizeConstants.spacing8),
            Text('${AppLocalizations.of(context)!.hi} 👋\n${AppLocalizations.of(context)!.welcome}'),
          ],
        ),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        actions: [
          IconButton(
            onPressed: () {
              employees.clear();
              for (var i = 0; i < 20; i++) {
                employees.add(
                  EmployeeModel(
                    id: i + 1,
                    name: 'کارمند امتحانی ${i + 1}',
                    fName: 'پدر کارمند امتحانی ${i + 1}',
                    phone: (i + 1) % 2 == 0 ? '07978723717' : null,
                  ),
                );
              }
            },
            icon: Icon(Icons.notifications, color: kOrangeColor),
          ),
          SizedBox(width: sizeConstants.spacing8),
        ],
      ),
      body: ListView.separated(
        physics: Constants.bouncingScrollPhysics,
        itemBuilder: (context, index) {
          return EmployeeAttendCard(
            index: index,
            name: employees[index].name,
            fName: employees[index].fName,
            phone: employees[index].phone,
            image: employees[index].image,
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: sizeConstants.spacing12);
        },
        itemCount: employees.length,
      ),
    );
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
