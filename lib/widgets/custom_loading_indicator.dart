import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key, this.spinner});
  final Widget? spinner;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          spinner ??
          SpinKitDualRing(
            color: Theme.of(context).primaryColor,
            lineWidth: 2,
          ),
    );
  }
}
