import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tetco_attendance/constants/colors.dart';
import 'package:tetco_attendance/utils/my_media_query.dart';
import 'package:tetco_attendance/utils/size_constant.dart';

class PopupHelper {
  /// Displays a custom form inside an adaptive modal action sheet.
  /// Works on both Android (Material bottom sheet) and iOS (Cupertino action sheet).
  static Future<T?> showCustomFormSheet<T>({required BuildContext context, required Widget content}) async {
    final result = await showAdaptiveDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.fromLTRB(
            sizeConstants.spacing16,
            sizeConstants.spacing8,
            sizeConstants.spacing16,
            sizeConstants.spacing12,
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1, // 10% from edges
            vertical: sizeConstants.spacing20,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: sizeConstants.spacing12,
            vertical: sizeConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizeConstants.radiusMedium),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 300.w,
              maxWidth: getMediaQueryWidth(context, 0.85),
              minHeight: getMediaQueryHeight(context, 0.5),
              maxHeight: getMediaQueryHeight(context, 0.8),
            ),
            child: content,
          ),
        );
      },
    );
    return result;
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.onPressed, required this.child});
  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodySmall),
        backgroundColor: WidgetStatePropertyAll(kTransparentColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
        ),
      ),
      child: child,
    );
  }
}
