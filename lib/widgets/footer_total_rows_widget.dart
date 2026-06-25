import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/colors.dart';

class FooterTotalRowsWidget extends StatelessWidget {
  const FooterTotalRowsWidget({super.key, required this.totalRows});
  final int totalRows;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: kPrimaryColor.withAlpha(20)),
      child: Text(
        'مجموع ردیف ها: $totalRows',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
