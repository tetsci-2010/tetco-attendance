import 'package:flutter/cupertino.dart';
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
          insetPadding: EdgeInsets.symmetric(
            horizontal: sizeConstants.spacing12,
            vertical: sizeConstants.spacing12,
          ),
          constraints: BoxConstraints(
            minWidth: getMediaQueryWidth(context),
            maxWidth: getMediaQueryWidth(context),
            minHeight: getMediaQueryHeight(context, 0.5),
            maxHeight: getMediaQueryHeight(context, 0.8),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            sizeConstants.spacing16,
            sizeConstants.spacing8,
            sizeConstants.spacing16,
            sizeConstants.spacing12,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: sizeConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              sizeConstants.radiusMedium,
            ),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: getMediaQueryWidth(
                context,
              ),
              maxWidth: getMediaQueryWidth(context),
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
  const CustomTextButton({super.key, required this.onPressed, required this.child, this.bgColor, this.loading = false});
  final void Function() onPressed;
  final Widget child;
  final Color? bgColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
        foregroundColor: WidgetStatePropertyAll(bgColor ?? Theme.of(context).primaryColor),
        overlayColor: WidgetStatePropertyAll(bgColor?.withAlpha(50) ?? Theme.of(context).primaryColor.withAlpha(50)),
        backgroundColor: WidgetStatePropertyAll(bgColor!.withAlpha(40)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(sizeConstants.radiusMedium)),
        ),
      ),
      child: loading ? CupertinoActivityIndicator() : child,
    );
  }
}
