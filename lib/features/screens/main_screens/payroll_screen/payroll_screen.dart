import 'package:flutter/material.dart';

import '../../../../constants/l10n/app_l10n.dart';

class PayrollScreen extends StatelessWidget {
  static const String id = '/payroll_screen';
  static const String name = 'payroll_screen';
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.comingSoon),
      ),
    );
  }
}
