import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/utils/size_constant.dart';
import 'package:tetco_attendance/widgets/buttons/filled_btn_with_icon.dart';

class EmptyScreenWithAction extends StatelessWidget {
  const EmptyScreenWithAction({required this.onCreate, required this.title, this.description, required this.actionText, this.icon, this.iconData});

  final VoidCallback onCreate;
  final String title;
  final String? description;
  final String actionText;
  final Icon? icon;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(sizeConstants.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ?? Icon(iconData ?? Icons.add, size: sizeConstants.iconXL, color: Theme.of(context).primaryColor),
            SizedBox(height: sizeConstants.spacing16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: sizeConstants.spacing8),
            Text(
              description ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kGreyColor600),
            ),
            SizedBox(height: sizeConstants.spacing16),
            FilledBtnWithIcon(text: actionText, onCreate: onCreate),
          ],
        ),
      ),
    );
  }
}
