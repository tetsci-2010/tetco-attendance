import 'package:flutter/material.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class FilledBtnWithIcon extends StatelessWidget {
  const FilledBtnWithIcon({super.key, this.onCreate, required this.text, this.icon, this.iconData});
  final VoidCallback? onCreate;
  final String text;
  final Widget? icon;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onCreate,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusLarge))),
        backgroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor.withAlpha(40)),
        foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        overlayColor: WidgetStatePropertyAll(Theme.of(context).primaryColor.withAlpha(30)),
      ),

      icon: icon ?? Icon(iconData ?? Icons.add_rounded),
      label: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
