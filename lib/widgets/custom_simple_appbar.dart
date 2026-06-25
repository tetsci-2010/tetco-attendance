import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';

class CustomSimpleAppbar extends StatelessWidget implements PreferredSize {
  const CustomSimpleAppbar({super.key, required this.title, this.actions, this.centerTitle = false, this.noBgColor = false});
  final Widget title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool noBgColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: noBgColor ? kTransparentColor : Theme.of(context).appBarTheme.backgroundColor,
    );
  }

  @override
  Widget get child => child;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
