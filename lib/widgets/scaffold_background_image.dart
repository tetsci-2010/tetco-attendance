import 'package:flutter/material.dart';
import 'package:tetco_attendance/constants/images_paths.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';

class ScaffoldBackgroundImage extends StatelessWidget {
  const ScaffoldBackgroundImage({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMediaQueryWidth(context),
      height: getMediaQueryHeight(context),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(ImagesPaths.splashBackgroundPng), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
