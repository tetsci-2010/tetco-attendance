import 'package:flutter/material.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

PopupMenuItem<String> popupMenuOpt<T>({
  required BuildContext context,
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required String value,
  required T emp,
  Color? color,
}) {
  return PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: sizeConstants.spacing8, vertical: sizeConstants.spacing8),
    value: value,
    onTap: onTap,
    child: Row(
      children: [
        Icon(icon, color: color, size: sizeConstants.iconS),
        SizedBox(width: 5),
        Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color)),
      ],
    ),
  );
}
